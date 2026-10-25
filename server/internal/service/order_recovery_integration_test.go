package service

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

func TestOrderProvisionRecoveryResolvesAmbiguousPanelCreateMongo(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run MongoDB order recovery integration test")
	}
	var exists atomic.Bool
	var creates atomic.Int32
	var delayedExists atomic.Bool
	var delayedCreates atomic.Int32
	var delayedDescription atomic.Value
	panel := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		isExternalLookup := strings.HasPrefix(r.URL.Path, "/api/application/servers/external/")
		if r.URL.Path != "/api/application/servers" && !isExternalLookup {
			http.NotFound(w, r)
			return
		}
		if r.Method == http.MethodGet {
			externalID := strings.TrimPrefix(r.URL.Path, "/api/application/servers/external/")
			found := externalID == "ambiguous" && exists.Load()
			if externalID == "delayed" {
				found = delayedExists.Load()
			}
			if !found {
				http.Error(w, `{"errors":[{"code":"NotFoundHttpException"}]}`, http.StatusNotFound)
				return
			}
			_, _ = io.WriteString(w, `{"attributes":{"id":987,"identifier":"ambiguous"}}`)
			return
		}
		if r.Method == http.MethodPost {
			var body struct {
				ExternalID  string `json:"external_id"`
				Description string `json:"description"`
			}
			if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
				t.Errorf("decode create body: %v", err)
			}
			if body.ExternalID == "delayed" {
				attempt := delayedCreates.Add(1)
				delayedDescription.Store(body.Description)
				if attempt == 1 {
					http.Error(w, "definitive rejection", http.StatusBadRequest)
					return
				}
				delayedExists.Store(true)
				w.WriteHeader(http.StatusCreated)
				_, _ = io.WriteString(w, `{"attributes":{"id":988,"identifier":"delayed"}}`)
				return
			}
			if body.ExternalID == "ambiguous" {
				creates.Add(1)
				exists.Store(true)
				http.Error(w, "upstream response lost", http.StatusBadGateway)
				return
			}
			w.WriteHeader(http.StatusCreated)
			_, _ = io.WriteString(w, `{"attributes":{"id":989,"identifier":"replacement"}}`)
			return
		}
		http.NotFound(w, r)
	}))
	defer panel.Close()
	dbName := fmt.Sprintf("peo_order_recovery_%d", time.Now().UnixNano())
	t.Setenv(config.MongoURIEnv, uri)
	t.Setenv(config.MongoDBEnv, dbName)
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	settings, err := config.DefaultSettings()
	if err != nil {
		t.Fatal(err)
	}
	settings["pterodactylhostname"] = panel.URL
	settings["pterodactyltoken"] = "integration-panel-token"
	if err := config.LoadSettings(settings); err != nil {
		t.Fatal(err)
	}
	if err := store.Init(); err != nil {
		t.Fatal(err)
	}
	db := store.DB()
	t.Cleanup(func() {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		_ = db.Drop(ctx)
		store.Reset()
		_ = config.Init()
	})
	ctx := context.Background()
	if err := store.EnsureIndexes(ctx); err != nil {
		t.Fatal(err)
	}
	user := &models.User{Name: "recovery_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex(), Balance: 1000}
	if err := store.User.Create(ctx, user); err != nil {
		t.Fatal(err)
	}
	order := &models.Order{UserID: user.ID, SpecID: bson.NewObjectID(), FinalPrice: 125}
	if err := store.Order.Create(ctx, order); err != nil {
		t.Fatal(err)
	}
	client := pterodactyl.ClientFromConf()
	externalID := "ambiguous"
	request := []byte(`{"external_id":"ambiguous","name":"ambiguous"}`)
	op := &models.ProvisionOperation{ID: "order:" + order.ID.Hex() + ":attempt-1", PaymentMethod: "balance", Amount: 125, AllocationID: 19, ExternalID: externalID, CustomerHost: "customer.example", PanelHost: client.HostName(), TokenFingerprint: client.IdentityFingerprint(), ExpiresAt: time.Now().Add(24 * time.Hour), ValidDuration: 30 * 24 * time.Hour, CreatePayload: request, State: "claimed"}
	if ok, err := store.Order.BeginProvision(ctx, order.ID, op); err != nil || !ok {
		t.Fatalf("BeginProvision = (%v, %v)", ok, err)
	}
	changedSettings := make(map[string]any, len(settings))
	for key, value := range settings {
		changedSettings[key] = value
	}
	changedSettings["pterodactylhostname"] = "https://different-panel.invalid"
	changedSettings["pterodactyltoken"] = "rotated-token"
	if err := config.LoadSettings(changedSettings); err != nil {
		t.Fatal(err)
	}
	RecoverOperations(ctx)
	uncharged, err := store.User.ByID(ctx, user.ID)
	if err != nil || uncharged.Balance != 1000 || creates.Load() != 0 {
		t.Fatalf("config switch caused side effect: balance=%d creates=%d err=%v", uncharged.Balance, creates.Load(), err)
	}
	deleteEntity := &models.WareEntity{UserID: user.ID, SpecID: order.SpecID, ServerExternalID: "already-deleted", DeleteStatus: 3, ValidDate: time.Now().Add(-24 * time.Hour), PanelDelete: &models.PanelDeleteOperation{ID: "delete:integration", ExternalID: "already-deleted", PanelHost: client.HostName(), TokenFingerprint: client.IdentityFingerprint(), State: "upstream_deleted"}}
	if err := store.Entity.Create(ctx, deleteEntity); err != nil {
		t.Fatal(err)
	}
	pterodactyl.CheckServers(ctx)
	stillDeleting, err := store.Entity.ByID(ctx, deleteEntity.ID)
	if err != nil || stillDeleting.DeleteStatus != 3 {
		t.Fatalf("sweep changed active deletion: entity=%#v err=%v", stillDeleting, err)
	}
	if err := pterodactyl.ConfirmDelete(ctx, deleteEntity.ID); err != nil {
		t.Fatalf("local delete finalization after config switch: %v", err)
	}
	if _, err := store.Entity.ByID(ctx, deleteEntity.ID); !store.IsNotFound(err) {
		t.Fatalf("upstream-deleted local entity remains, err=%v", err)
	}
	if err := config.LoadSettings(settings); err != nil {
		t.Fatal(err)
	}
	lateUser := &models.User{Name: "recovery_late_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex(), Balance: 500}
	if err := store.User.Create(ctx, lateUser); err != nil {
		t.Fatal(err)
	}
	lateOrder := &models.Order{UserID: lateUser.ID, SpecID: bson.NewObjectID(), FinalPrice: 50}
	if err := store.Order.Create(ctx, lateOrder); err != nil {
		t.Fatal(err)
	}
	past := time.Now().Add(-48 * time.Hour).Truncate(time.Second)
	latePayload, _ := json.Marshal(map[string]any{"external_id": "delayed", "name": "delayed", "description": ExpiryLabel + past.Format(dateOnly)})
	lateOp := &models.ProvisionOperation{ID: "order:" + lateOrder.ID.Hex() + ":attempt-1", PaymentMethod: "balance", Amount: 50, AllocationID: 21, ExternalID: "delayed", CustomerHost: "late.example", PanelHost: client.HostName(), TokenFingerprint: client.IdentityFingerprint(), ExpiresAt: past, ValidDuration: 24 * time.Hour, CreatePayload: latePayload, State: "claimed"}
	if ok, err := store.Order.BeginProvision(ctx, lateOrder.ID, lateOp); err != nil || !ok {
		t.Fatalf("begin delayed order = (%v,%v)", ok, err)
	}
	firstCreateErr := runProvision(ctx, lateOrder, lateOp)
	if firstCreateErr == nil {
		t.Fatal("first definitive Panel rejection unexpectedly succeeded")
	}
	past = time.Now().Add(-48 * time.Hour).Truncate(time.Second)
	latePayload, _ = json.Marshal(map[string]any{"external_id": "delayed", "name": "delayed", "description": ExpiryLabel + past.Format(dateOnly)})
	if _, err := store.Collection(models.CollOrders).UpdateOne(ctx, bson.M{"_id": lateOrder.ID, "provision.id": lateOp.ID}, bson.M{"$set": bson.M{"provision.expiresAt": past, "provision.createPayload": latePayload}}); err != nil {
		t.Fatal(err)
	}
	latePending, err := store.Order.ByID(ctx, lateOrder.ID)
	if err != nil {
		t.Fatalf("read first failed create: firstRunErr=%v readErr=%v", firstCreateErr, err)
	}
	if latePending.Provision.State != "creating" || !latePending.Provision.ExpiresAt.Equal(past) {
		t.Fatalf("first failed create: firstRunErr=%v state=%q expiresAt=%s want=%s", firstCreateErr, latePending.Provision.State, latePending.Provision.ExpiresAt, past)
	}
	RecoverOperations(ctx)
	lateDone, err := store.Order.ByID(ctx, lateOrder.ID)
	if err != nil || !lateDone.Paid || lateDone.Provision.State != "completed" || !lateDone.Provision.ExpiresAt.After(time.Now().Add(23*time.Hour)) {
		t.Fatalf("delayed create recovery = %#v, %v", lateDone, err)
	}
	if delayedCreates.Load() != 2 {
		t.Fatalf("delayed create attempts = %d, want 2", delayedCreates.Load())
	}
	if got, _ := delayedDescription.Load().(string); got != ExpiryLabel+lateDone.Provision.ExpiresAt.Local().Format(dateOnly) {
		t.Fatalf("persisted create description=%q, expiry=%s", got, lateDone.Provision.ExpiresAt)
	}
	// A restart sees the stored payload, sends it once, loses the response, then
	// discovers the server by an uncached external-id lookup.
	RecoverOperations(ctx)
	fresh, err := store.Order.ByID(ctx, order.ID)
	if err != nil || !fresh.Paid || !fresh.Confirmed || fresh.Provision.State != "completed" {
		t.Fatalf("recovered order = %#v, %v", fresh, err)
	}
	if got := creates.Load(); got != 1 {
		t.Fatalf("Panel create requests = %d, want 1", got)
	}
	entity, err := store.Entity.ByOrder(ctx, order.ID)
	if err != nil || entity.ServerExternalID != externalID || entity.HostName != "customer.example" {
		t.Fatalf("recovered entity = %#v, %v", entity, err)
	}
	charged, err := store.User.ByID(ctx, user.ID)
	if err != nil || charged.Balance != 875 {
		t.Fatalf("user balance = %d, %v, want 875", charged.Balance, err)
	}
	poor := &models.User{Name: "recovery_poor_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex()}
	if err := store.User.Create(ctx, poor); err != nil {
		t.Fatal(err)
	}
	failedOrder := &models.Order{UserID: poor.ID, SpecID: bson.NewObjectID(), FinalPrice: 100}
	if err := store.Order.Create(ctx, failedOrder); err != nil {
		t.Fatal(err)
	}
	poorExternalID := "poor" + failedOrder.ID.Hex()
	poorPayload, _ := json.Marshal(map[string]any{"external_id": poorExternalID, "name": poorExternalID})
	failedOp := &models.ProvisionOperation{ID: "order:" + failedOrder.ID.Hex() + ":attempt-1", PaymentMethod: "balance", Amount: 100, AllocationID: 20, ExternalID: poorExternalID, PanelHost: client.HostName(), TokenFingerprint: client.IdentityFingerprint(), ExpiresAt: time.Now().Add(time.Hour), ValidDuration: 24 * time.Hour, CreatePayload: poorPayload, State: "claimed"}
	if canceled, applied, err := store.User.CancelBalanceOperation(ctx, poor.ID, failedOp.ID, failedOp.Amount); err != nil || !canceled || applied {
		t.Fatalf("insufficient attempt tombstone = (%v,%v,%v)", canceled, applied, err)
	}
	if ok, err := store.Order.BeginProvision(ctx, failedOrder.ID, failedOp); err != nil || !ok {
		t.Fatalf("begin canceled attempt = (%v,%v)", ok, err)
	}
	RecoverOperations(ctx)
	failedFresh, err := store.Order.ByID(ctx, failedOrder.ID)
	if err != nil || failedFresh.Provision.State != "payment_failed" || failedFresh.Paid {
		t.Fatalf("canceled attempt state = %#v, %v", failedFresh, err)
	}
	if err := store.User.AddBalance(ctx, poor.ID, 100); err != nil {
		t.Fatal(err)
	}
	retry := *failedOp
	retry.ID += ":retry"
	retry.State = "claimed"
	if ok, err := store.Order.BeginProvision(ctx, failedOrder.ID, &retry); err != nil || !ok {
		t.Fatalf("funded replacement attempt = (%v,%v)", ok, err)
	}
	if err := runProvision(ctx, failedFresh, &retry); err != nil {
		t.Fatalf("funded replacement payment/provision = %v", err)
	}
	retriedOrder, err := store.Order.ByID(ctx, failedOrder.ID)
	if err != nil || !retriedOrder.Paid || retriedOrder.Provision.State != "completed" {
		t.Fatalf("funded replacement order = %#v, %v", retriedOrder, err)
	}
	retriedUser, err := store.User.ByID(ctx, poor.ID)
	if err != nil || retriedUser.Balance != 0 {
		t.Fatalf("funded replacement balance = %d, %v, want 0", retriedUser.Balance, err)
	}
	freeUser := &models.User{Name: "recovery_free_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex(), Balance: 25}
	if err := store.User.Create(ctx, freeUser); err != nil {
		t.Fatal(err)
	}
	freeOrder := &models.Order{UserID: freeUser.ID, SpecID: bson.NewObjectID(), FinalPrice: 0}
	if err := store.Order.Create(ctx, freeOrder); err != nil {
		t.Fatal(err)
	}
	freeID := "free" + freeOrder.ID.Hex()
	freePayload, _ := json.Marshal(map[string]any{"external_id": freeID, "name": freeID})
	freeOp := &models.ProvisionOperation{ID: "order:" + freeOrder.ID.Hex() + ":attempt-1", PaymentMethod: "balance", AllocationID: 22, ExternalID: freeID, PanelHost: client.HostName(), TokenFingerprint: client.IdentityFingerprint(), ExpiresAt: time.Now().Add(time.Hour), ValidDuration: 24 * time.Hour, CreatePayload: freePayload, State: "claimed"}
	if ok, err := store.Order.BeginProvision(ctx, freeOrder.ID, freeOp); err != nil || !ok {
		t.Fatalf("begin zero-price order = (%v,%v)", ok, err)
	}
	if err := runProvision(ctx, freeOrder, freeOp); err != nil {
		t.Fatalf("zero-price payment/provision = %v", err)
	}
	freeFresh, err := store.User.ByID(ctx, freeUser.ID)
	if err != nil || freeFresh.Balance != 25 {
		t.Fatalf("zero-price balance = %d, %v, want 25", freeFresh.Balance, err)
	}
}
