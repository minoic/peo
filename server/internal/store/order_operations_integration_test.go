package store

import (
	"context"
	"fmt"
	"os"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
)

func TestOrderProvisionOperationMongoCASAndRecovery(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run MongoDB order recovery integration test")
	}
	name := fmt.Sprintf("peo_order_recovery_%d", time.Now().UnixNano())
	t.Setenv(config.MongoURIEnv, uri)
	t.Setenv(config.MongoDBEnv, name)
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	if err := Init(); err != nil {
		t.Fatal(err)
	}
	db := DB()
	t.Cleanup(func() {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		_ = db.Drop(ctx)
		Reset()
	})
	ctx := context.Background()
	if err := EnsureIndexes(ctx); err != nil {
		t.Fatal(err)
	}
	order := &models.Order{UserID: bson.NewObjectID(), SpecID: bson.NewObjectID(), FinalPrice: 100}
	if err := Order.Create(ctx, order); err != nil {
		t.Fatal(err)
	}
	op := &models.ProvisionOperation{ID: "order:" + order.ID.Hex() + ":attempt-1", PaymentMethod: "balance", Amount: 100, AllocationID: 42, ExternalID: "user" + order.ID.Hex(), PanelHost: "https://panel.test", TokenFingerprint: "fingerprint", ExpiresAt: time.Now().Add(time.Hour), CreatePayload: []byte(`{"external_id":"test"}`), State: "claimed"}
	if ok, err := Order.BeginProvision(ctx, order.ID, op); err != nil || !ok {
		t.Fatalf("BeginProvision = (%v, %v)", ok, err)
	}
	if ok, err := Order.BeginProvision(ctx, order.ID, op); err != nil || ok {
		t.Fatalf("duplicate BeginProvision = (%v, %v), want false", ok, err)
	}
	now := time.Now()
	if ok, err := Order.AcquireProvisionLease(ctx, order.ID, op.ID, "lease-one", now, now.Add(time.Minute)); err != nil || !ok {
		t.Fatalf("Acquire lease one = (%v, %v)", ok, err)
	}
	if ok, err := Order.AcquireProvisionLease(ctx, order.ID, op.ID, "lease-two", now, now.Add(time.Minute)); err != nil || ok {
		t.Fatalf("overlapping lease = (%v, %v), want false", ok, err)
	}
	if err := Order.AdvanceProvision(ctx, order.ID, op.ID, "lease-one", "ready"); err != nil {
		t.Fatal(err)
	}
	if err := Order.AdvanceProvision(ctx, order.ID, op.ID, "lease-one", "server_created"); err != nil {
		t.Fatal(err)
	}
	if err := Order.AdvanceProvision(ctx, order.ID, op.ID, "lease-one", "entity_recorded"); err != nil {
		t.Fatal(err)
	}
	if err := Order.CompleteProvision(ctx, order.ID, op.ID, "lease-one", op.AllocationID); err != nil {
		t.Fatal(err)
	}
	if err := Order.ReleaseProvisionLease(ctx, order.ID, op.ID, "lease-one"); err != nil {
		t.Fatal(err)
	}
	got, err := Order.ByID(ctx, order.ID)
	if err != nil || !got.Paid || !got.Confirmed || got.Provision.State != "completed" {
		t.Fatalf("completed order = %#v, %v", got, err)
	}
	if pending, err := Order.PendingProvisions(ctx); err != nil || len(pending) != 0 {
		t.Fatalf("PendingProvisions = %d, %v", len(pending), err)
	}

	failedOrder := &models.Order{UserID: bson.NewObjectID(), SpecID: bson.NewObjectID()}
	if err := Order.Create(ctx, failedOrder); err != nil {
		t.Fatal(err)
	}
	failed := &models.ProvisionOperation{ID: "order:" + failedOrder.ID.Hex() + ":attempt-1", State: "claimed"}
	if ok, err := Order.BeginProvision(ctx, failedOrder.ID, failed); err != nil || !ok {
		t.Fatalf("begin failed-attempt fixture = (%v, %v)", ok, err)
	}
	if ok, err := Order.AcquireProvisionLease(ctx, failedOrder.ID, failed.ID, "failed-lease", now, now.Add(time.Minute)); err != nil || !ok {
		t.Fatalf("acquire failed-attempt fixture = (%v, %v)", ok, err)
	}
	if err := Order.AdvanceProvision(ctx, failedOrder.ID, failed.ID, "failed-lease", "payment_failed"); err != nil {
		t.Fatal(err)
	}
	if err := Order.ReleaseProvisionLease(ctx, failedOrder.ID, failed.ID, "failed-lease"); err != nil {
		t.Fatal(err)
	}
	retry := &models.ProvisionOperation{ID: "order:" + failedOrder.ID.Hex() + ":attempt-2", State: "claimed"}
	if ok, err := Order.BeginProvision(ctx, failedOrder.ID, retry); err != nil || !ok {
		t.Fatalf("new no-effect attempt = (%v, %v), want true", ok, err)
	}

	closeNow := time.Now()
	makeExpired := func(label string) *models.Order {
		t.Helper()
		o := &models.Order{UserID: bson.NewObjectID(), SpecID: bson.NewObjectID()}
		if err := Order.Create(ctx, o); err != nil {
			t.Fatalf("create %s order: %v", label, err)
		}
		if _, err := Collection(models.CollOrders).UpdateOne(ctx, docIDFilter(o.ID), bson.M{"$set": bson.M{"createdAt": closeNow.Add(-15 * time.Minute)}}); err != nil {
			t.Fatalf("age %s order: %v", label, err)
		}
		return o
	}
	expired := makeExpired("expired")
	active := makeExpired("active")
	activeOp := &models.ProvisionOperation{ID: "order:" + active.ID.Hex() + ":active", State: "claimed"}
	// Claim while fresh, then age it to model an operation held over the window.
	if _, err := Collection(models.CollOrders).UpdateOne(ctx, docIDFilter(active.ID), bson.M{"$set": bson.M{"createdAt": closeNow}}); err != nil {
		t.Fatal(err)
	}
	if ok, err := Order.BeginProvision(ctx, active.ID, activeOp); err != nil || !ok {
		t.Fatalf("begin active fixture = (%v, %v)", ok, err)
	}
	if _, err := Collection(models.CollOrders).UpdateOne(ctx, docIDFilter(active.ID), bson.M{"$set": bson.M{"createdAt": closeNow.Add(-16 * time.Minute)}}); err != nil {
		t.Fatal(err)
	}
	paid := makeExpired("paid")
	if err := Order.SetPaid(ctx, paid.ID, true); err != nil {
		t.Fatal(err)
	}
	confirmed := makeExpired("confirmed")
	if _, err := Collection(models.CollOrders).UpdateOne(ctx, docIDFilter(confirmed.ID), bson.M{"$set": bson.M{"confirmed": true, "paid": false}}); err != nil {
		t.Fatal(err)
	}
	failedPayment := makeExpired("failed-payment")
	if _, err := Collection(models.CollOrders).UpdateOne(ctx, docIDFilter(failedPayment.ID), bson.M{"$set": bson.M{"provision.state": "payment_failed"}}); err != nil {
		t.Fatal(err)
	}
	freshOrder := makeExpired("fresh")
	if _, err := Collection(models.CollOrders).UpdateOne(ctx, docIDFilter(freshOrder.ID), bson.M{"$set": bson.M{"createdAt": closeNow.Add(-time.Minute), "doc.createdAt": closeNow.Add(-time.Hour)}}); err != nil {
		t.Fatal(err)
	}
	legacyID := bson.NewObjectID()
	legacy := bson.M{"doc": bson.M{"_id": legacyID, "createdAt": closeNow.Add(-16 * time.Minute), "updatedAt": closeNow.Add(-16 * time.Minute)}, "userId": bson.NewObjectID(), "specId": bson.NewObjectID()}
	if _, err := Collection(models.CollOrders).InsertOne(ctx, legacy); err != nil {
		t.Fatal(err)
	}
	expiredUnclosed := makeExpired("expired-unclosed")
	if ok, err := Order.BeginProvision(ctx, expiredUnclosed.ID, &models.ProvisionOperation{ID: "expired-unclosed", State: "claimed"}); err != nil || ok {
		t.Fatalf("expired but unclosed BeginProvision = (%v, %v), want false", ok, err)
	}
	raceOrder := makeExpired("race")
	startRace := make(chan struct{})
	var raceWG sync.WaitGroup
	var closeErr error
	var claimOK bool
	var claimErr error
	raceWG.Add(2)
	go func() {
		defer raceWG.Done()
		<-startRace
		closeErr = Order.CloseIfExpired(ctx, raceOrder.ID, closeNow)
	}()
	go func() {
		defer raceWG.Done()
		<-startRace
		claimOK, claimErr = Order.BeginProvision(ctx, raceOrder.ID, &models.ProvisionOperation{ID: "race-claim", State: "claimed"})
	}()
	close(startRace)
	raceWG.Wait()
	if closeErr != nil || claimErr != nil || claimOK {
		t.Fatalf("expire/claim race = close(%v), claim(%v, %v); expired order must never be claimed", closeErr, claimOK, claimErr)
	}
	closedCount, err := Order.CloseExpired(ctx, closeNow)
	if err != nil || closedCount != 4 {
		t.Fatalf("CloseExpired = (%d, %v), want expired, failed-payment, legacy and unclosed orders", closedCount, err)
	}
	if closedCount, err = Order.CloseExpired(ctx, closeNow.Add(time.Minute)); err != nil || closedCount != 0 {
		t.Fatalf("repeat CloseExpired = (%d, %v), want no transition", closedCount, err)
	}
	closedOrder, err := Order.ByID(ctx, expired.ID)
	if err != nil || !closedOrder.Closed || !closedOrder.ClosedAt.Equal(closeNow.Truncate(time.Millisecond)) {
		t.Fatalf("expired order = %#v, %v", closedOrder, err)
	}
	activeOrder, err := Order.ByID(ctx, active.ID)
	if err != nil || activeOrder.Closed {
		t.Fatalf("active operation order = %#v, %v", activeOrder, err)
	}
	paidOrder, err := Order.ByID(ctx, paid.ID)
	if err != nil || paidOrder.Closed {
		t.Fatalf("paid order = %#v, %v", paidOrder, err)
	}
	confirmedOrder, err := Order.ByID(ctx, confirmed.ID)
	if err != nil || confirmedOrder.Closed {
		t.Fatalf("confirmed order = %#v, %v", confirmedOrder, err)
	}
	freshRead, err := Order.ByID(ctx, freshOrder.ID)
	if err != nil || freshRead.Closed {
		t.Fatalf("new top-level timestamp did not take precedence: %#v, %v", freshRead, err)
	}
	legacyRead, err := Order.ByID(ctx, legacyID)
	if err != nil || !legacyRead.Closed {
		t.Fatalf("legacy order was not closed: %#v, %v", legacyRead, err)
	}
	raceRead, err := Order.ByID(ctx, raceOrder.ID)
	if err != nil || !raceRead.Closed || raceRead.Provision != nil {
		t.Fatalf("expire/claim race left an unsafe state: %#v, %v", raceRead, err)
	}
	if ok, err := Order.BeginProvision(ctx, expired.ID, &models.ProvisionOperation{ID: "too-late", State: "claimed"}); err != nil || ok {
		t.Fatalf("expired BeginProvision = (%v, %v), want false", ok, err)
	}
}
