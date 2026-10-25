// Package store owns the MongoDB connection and provides typed repositories
// for every collection.
//
// The connection is created by Init and can be torn down with Reset. Its
// connection settings come from deployment environment variables.
package store

import (
	"context"
	"errors"
	"net/url"
	"sync"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
	"go.mongodb.org/mongo-driver/v2/mongo/readpref"
)

// ErrNotFound is returned by every single-document lookup that matched nothing.
// It is an alias of the driver error so callers can keep using errors.Is with
// either value.
var ErrNotFound = mongo.ErrNoDocuments

// ErrSettingsNotFound means the singleton application settings document has
// not been created yet.
var ErrSettingsNotFound = mongo.ErrNoDocuments

// DefaultTimeout bounds every database round trip so a hung MongoDB cannot
// block an HTTP handler indefinitely.
const DefaultTimeout = 10 * time.Second

var (
	mu     sync.RWMutex
	client *mongo.Client
	db     *mongo.Database
)

// Init connects to MongoDB, verifies the deployment is reachable and makes sure
// all indexes exist. It is safe to call repeatedly; an existing healthy
// connection is reused.
func Init() error {
	mu.RLock()
	ok := client != nil && db != nil
	mu.RUnlock()
	if ok {
		return nil
	}

	ctx, cancel := context.WithTimeout(context.Background(), DefaultTimeout)
	defer cancel()

	mongoURI := config.MongoURI()
	opts := options.Client().ApplyURI(mongoURI)
	if err := opts.Validate(); err != nil {
		return err
	}
	opts.SetAppName("peo")
	c, err := mongo.Connect(opts)
	if err != nil {
		return err
	}
	if err := c.Ping(ctx, readpref.Primary()); err != nil {
		_ = c.Disconnect(ctx)
		return err
	}
	databaseName := config.MongoDatabaseName()
	d := c.Database(databaseName)
	if d.Name() == "" {
		_ = c.Disconnect(context.Background())
		return errors.New("MongoDatabaseName is empty")
	}

	mu.Lock()
	client, db = c, d
	mu.Unlock()

	if err := EnsureIndexes(ctx); err != nil {
		glgf.Error("mongo: index bootstrap failed: ", err)
		_ = c.Disconnect(context.Background())
		mu.Lock()
		client, db = nil, nil
		mu.Unlock()
		return err
	}
	mongoEndpoint := "unknown"
	if parsedURI, err := url.Parse(mongoURI); err == nil && parsedURI.Host != "" {
		mongoEndpoint = parsedURI.Host
	}
	glgf.Success("mongodb connected: " + d.Name() + " at " + mongoEndpoint)
	return nil
}

// LoadAppSettings reads the singleton business configuration document.
func LoadAppSettings(ctx context.Context) (map[string]any, error) {
	var doc struct {
		Values bson.M `bson:"values"`
	}
	if err := Collection(models.CollAppSettings).FindOne(ctx, bson.M{"_id": "app"}).Decode(&doc); err != nil {
		return nil, err
	}
	settings := make(map[string]any, len(doc.Values))
	for key, value := range doc.Values {
		settings[key] = value
	}
	return settings, nil
}

// SaveAppSettings upserts the singleton business configuration document.
func SaveAppSettings(ctx context.Context, settings map[string]any) error {
	_, err := Collection(models.CollAppSettings).UpdateOne(
		ctx,
		bson.M{"_id": "app"},
		bson.M{
			"$set":         bson.M{"values": settings, "updatedAt": time.Now()},
			"$setOnInsert": bson.M{"_id": "app"},
		},
		options.UpdateOne().SetUpsert(true),
	)
	return err
}

// CreateAppSettings inserts the singleton only if startup has not created it.
// A duplicate-key result means another process won and callers must reload it.
func CreateAppSettings(ctx context.Context, settings map[string]any) error {
	_, err := Collection(models.CollAppSettings).InsertOne(ctx, bson.M{
		"_id": "app", "values": settings, "updatedAt": time.Now(),
	})
	return err
}

// ReplaceAppSettingIfCurrent performs a compare-and-set for one setting field.
func ReplaceAppSettingIfCurrent(ctx context.Context, key string, current any, exists bool, next any) (bool, error) {
	filter := bson.M{"_id": "app"}
	field := "values." + key
	if exists {
		filter[field] = current
	} else {
		filter[field] = bson.M{"$exists": false}
	}
	result, err := Collection(models.CollAppSettings).UpdateOne(ctx, filter, bson.M{
		"$set": bson.M{field: next, "updatedAt": time.Now()},
	})
	return err == nil && result.MatchedCount == 1, err
}

// Reset drops the cached connection. The next call to Init reconnects using the
// current environment settings. The process calls this during shutdown.
func Reset() {
	mu.Lock()
	c := client
	client, db = nil, nil
	mu.Unlock()
	if c != nil {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		_ = c.Disconnect(ctx)
	}
}

// Client returns the live client. It may be nil before a successful Init.
func Client() *mongo.Client {
	mu.RLock()
	defer mu.RUnlock()
	return client
}

// DB returns the live database handle. It may be nil before a successful Init.
func DB() *mongo.Database {
	mu.RLock()
	defer mu.RUnlock()
	return db
}

// Collection returns a handle to a named collection.
func Collection(name string) *mongo.Collection { return DB().Collection(name) }

// Ctx builds a context with the default query timeout applied.
func Ctx() (context.Context, context.CancelFunc) {
	return context.WithTimeout(context.Background(), DefaultTimeout)
}
