package store

import (
	"context"
	"fmt"
	"os"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

func TestFirstAdminClaimIsAtomicAndRecoveryIsIdempotent(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run MongoDB bootstrap concurrency test")
	}
	name := fmt.Sprintf("peo_admin_bootstrap_%d", time.Now().UnixNano())
	ctx := context.Background()
	t.Setenv(config.MongoURIEnv, uri)
	t.Setenv(config.MongoDBEnv, name)
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	if err := Init(); err != nil {
		t.Fatal(err)
	}
	indexCursor, err := Collection(models.CollUsers).Indexes().List(ctx)
	if err != nil {
		t.Fatal(err)
	}
	foundBootstrapIndex := false
	for indexCursor.Next(ctx) {
		var index bson.M
		if err := indexCursor.Decode(&index); err != nil {
			t.Fatal(err)
		}
		if index["name"] == "uniq_bootstrap_key" {
			foundBootstrapIndex = true
			break
		}
	}
	_ = indexCursor.Close(ctx)
	if !foundBootstrapIndex {
		t.Fatal("required unique bootstrap index was not installed")
	}
	db := DB()
	t.Cleanup(func() {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		_ = db.Drop(ctx)
		Reset()
	})
	users := []*models.User{
		{Name: "bootstrap_a", Email: "bootstrap_a@test.invalid", UUID: bson.NewObjectID().Hex()},
		{Name: "bootstrap_b", Email: "bootstrap_b@test.invalid", UUID: bson.NewObjectID().Hex()},
	}

	var winners atomic.Int32
	var winnerID bson.ObjectID
	var winnerMu sync.Mutex
	var wg sync.WaitGroup
	for _, u := range users {
		wg.Add(1)
		go func(u *models.User) {
			defer wg.Done()
			claimed, err := User.CreateWithBootstrapAdmin(ctx, u, true)
			if err != nil {
				t.Errorf("CreateWithBootstrapAdmin: %v", err)
				return
			}
			if claimed {
				winners.Add(1)
				winnerMu.Lock()
				winnerID = u.ID
				winnerMu.Unlock()
			}
		}(u)
	}
	wg.Wait()
	if got := winners.Load(); got != 1 {
		t.Fatalf("bootstrap winners=%d, want exactly 1", got)
	}

	promoted, err := User.ByID(ctx, winnerID)
	if err != nil || !promoted.IsAdmin {
		t.Fatalf("atomic bootstrap insert: admin=%v err=%v", promoted != nil && promoted.IsAdmin, err)
	}

	if _, err := Collection(models.CollUsers).UpdateOne(ctx, docIDFilter(winnerID), bson.M{"$set": bson.M{"isAdmin": false}}); err != nil {
		t.Fatal(err)
	}
	if err := EnsureBootstrapAdmin(ctx); err != nil {
		t.Fatal(err)
	}
	demoted, err := User.ByID(ctx, winnerID)
	if err != nil || demoted.IsAdmin {
		t.Fatalf("startup recovery changed a later demotion: admin=%v err=%v", demoted != nil && demoted.IsAdmin, err)
	}
	if err := EnsureBootstrapAdmin(ctx); err != nil {
		t.Fatal(err)
	}
	demoted, err = User.ByID(ctx, winnerID)
	if err != nil || demoted.IsAdmin {
		t.Fatalf("startup recovery promoted an intentionally demoted admin: admin=%v err=%v", demoted != nil && demoted.IsAdmin, err)
	}
	ordinary := &models.User{Name: "bootstrap_c", Email: "bootstrap_c@test.invalid", UUID: bson.NewObjectID().Hex()}
	won, err := User.CreateWithBootstrapAdmin(ctx, ordinary, true)
	if err != nil || won || ordinary.IsAdmin {
		t.Fatalf("existing users database granted bootstrap admin: won=%v admin=%v err=%v", won, ordinary.IsAdmin, err)
	}
}

func TestInitFailsWhenBootstrapUniqueIndexCannotBeCreated(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run MongoDB bootstrap index test")
	}
	name := fmt.Sprintf("peo_admin_index_failure_%d", time.Now().UnixNano())
	t.Setenv(config.MongoURIEnv, uri)
	t.Setenv(config.MongoDBEnv, name)
	Reset()
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	client, err := mongo.Connect(options.Client().ApplyURI(uri))
	if err != nil {
		t.Fatal(err)
	}
	db := client.Database(name)
	_, err = db.Collection(models.CollUsers).InsertMany(ctx, []any{
		bson.M{"name": "duplicate_bootstrap_a", "email": "duplicate_bootstrap_a@test.invalid", "uuid": bson.NewObjectID().Hex(), "bootstrapKey": "initial-admin"},
		bson.M{"name": "duplicate_bootstrap_b", "email": "duplicate_bootstrap_b@test.invalid", "uuid": bson.NewObjectID().Hex(), "bootstrapKey": "initial-admin"},
	})
	if err != nil {
		_ = client.Disconnect(context.Background())
		t.Fatal(err)
	}
	if err := client.Disconnect(ctx); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() {
		cleanupClient, connectErr := mongo.Connect(options.Client().ApplyURI(uri))
		if connectErr == nil {
			_ = cleanupClient.Database(name).Drop(context.Background())
			_ = cleanupClient.Disconnect(context.Background())
		}
		Reset()
	})
	if err := Init(); err == nil {
		t.Fatal("store.Init succeeded without being able to enforce the bootstrap uniqueness constraint")
	}
	if DB() != nil {
		t.Fatal("failed initialization retained an active database handle")
	}
}
