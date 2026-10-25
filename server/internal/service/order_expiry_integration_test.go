package service

import (
	"context"
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

func TestExpiredOrderRejectsBothPaymentMethodsBeforeExternalWork(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run order expiry integration test")
	}
	dbName := fmt.Sprintf("peo_order_expiry_service_%d", time.Now().UnixNano())
	t.Setenv(config.MongoURIEnv, uri)
	t.Setenv(config.MongoDBEnv, dbName)
	if err := config.Init(); err != nil {
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
	user := &models.User{Name: "expiry_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex(), Balance: 500}
	if err := store.User.Create(ctx, user); err != nil {
		t.Fatal(err)
	}
	order := &models.Order{UserID: user.ID, SpecID: bson.NewObjectID(), FinalPrice: 100}
	if err := store.Order.Create(ctx, order); err != nil {
		t.Fatal(err)
	}
	key := &models.WareKey{SpecID: order.SpecID, KeyString: "expiry-" + bson.NewObjectID().Hex(), Exp: time.Now().Add(time.Hour)}
	if err := store.Key.Create(ctx, key); err != nil {
		t.Fatal(err)
	}
	if _, err := store.Collection(models.CollOrders).UpdateOne(ctx, bson.M{"_id": order.ID}, bson.M{"$set": bson.M{"createdAt": time.Now().Add(-PendingOrderLifetime)}}); err != nil {
		t.Fatal(err)
	}
	for _, pay := range []struct {
		name string
		fn   func() error
	}{
		{"balance", func() error { return Order.PayWithBalance(ctx, order.ID, user.ID, 1, "expired-host") }},
		{"key", func() error { return Order.PayWithKey(ctx, order.ID, user.ID, key.KeyString, 1, "expired-host") }},
	} {
		t.Run(pay.name, func(t *testing.T) {
			err := pay.fn()
			coded := apierr.AsError(err)
			if coded == nil || coded.Code != apierr.CodeConflict {
				t.Fatalf("payment error = %v, want conflict", err)
			}
		})
	}
	freshUser, err := store.User.ByID(ctx, user.ID)
	if err != nil || freshUser.Balance != user.Balance || len(freshUser.BalanceOperations) != 0 {
		t.Fatalf("expired payment changed balance state: %#v, %v", freshUser, err)
	}
	freshKey, err := store.Key.ByID(ctx, key.ID)
	if err != nil || freshKey.ClaimID != "" || !freshKey.ClaimUser.IsZero() {
		t.Fatalf("expired payment claimed key: %#v, %v", freshKey, err)
	}
	freshOrder, err := store.Order.ByID(ctx, order.ID)
	if err != nil || !freshOrder.Closed || freshOrder.Provision != nil {
		t.Fatalf("expired payment state = %#v, %v", freshOrder, err)
	}
}
