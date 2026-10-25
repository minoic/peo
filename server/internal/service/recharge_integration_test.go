package service

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
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/store"
	"github.com/smartwalle/alipay/v3"
	"go.mongodb.org/mongo-driver/v2/bson"
)

func TestRechargeConcurrencyMongo(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run MongoDB recharge concurrency integration test")
	}
	dbName := fmt.Sprintf("peo_recharge_review_%d", time.Now().UnixNano())
	t.Setenv(config.MongoURIEnv, uri)
	t.Setenv(config.MongoDBEnv, dbName)
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	settings, err := config.DefaultSettings()
	if err != nil {
		t.Fatal(err)
	}
	settings["alipayappid"] = "migration-test-app"
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
		redis.Reset()
		_ = config.Init()
	})
	ctx := context.Background()
	if err := store.EnsureIndexes(ctx); err != nil {
		t.Fatal(err)
	}

	var owners []*models.User
	for i := 0; i < 8; i++ {
		u := &models.User{Name: fmt.Sprintf("keyredeem_%d_%d", time.Now().UnixNano(), i), Email: fmt.Sprintf("keyredeem_%d_%d@test.invalid", time.Now().UnixNano(), i), UUID: bson.NewObjectID().Hex()}
		if err := store.User.Create(ctx, u); err != nil {
			t.Fatal(err)
		}
		owners = append(owners, u)
	}
	key := &models.RechargeKey{KeyString: bson.NewObjectID().Hex(), Balance: 30, Exp: time.Now().Add(time.Hour)}
	if err := store.RKey.Create(ctx, key); err != nil {
		t.Fatal(err)
	}
	var redeemed atomic.Int32
	var wg sync.WaitGroup
	for _, owner := range owners {
		owner := owner
		wg.Add(1)
		go func() {
			defer wg.Done()
			if err := Recharge.ByKey(ctx, owner.ID, key.KeyString); err == nil {
				redeemed.Add(1)
			}
		}()
	}
	wg.Wait()
	if got := redeemed.Load(); got != 1 {
		t.Fatalf("successful recharge key redemptions=%d, want exactly 1", got)
	}
	var credited uint
	for _, owner := range owners {
		fresh, err := store.User.ByID(ctx, owner.ID)
		if err != nil {
			t.Fatal(err)
		}
		credited += fresh.Balance
	}
	if credited != key.Balance {
		t.Fatalf("total credited from one recharge key=%d, want %d", credited, key.Balance)
	}
	if _, err := store.RKey.ByString(ctx, key.KeyString); !store.IsNotFound(err) {
		t.Fatalf("redeemed recharge key remains queryable, err=%v", err)
	}

	user := &models.User{Name: "callback_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex()}
	if err := store.User.Create(ctx, user); err != nil {
		t.Fatal(err)
	}
	log := &models.RechargeLog{
		UserID: user.ID, Method: "Alipay", Balance: 11, OutTradeNo: bson.NewObjectID().Hex(),
		PaymentAppID: "migration-test-app", Status: RechargePending,
	}
	if err := store.RechargeLog.Create(ctx, log); err != nil {
		t.Fatal(err)
	}
	notify := &alipay.Notification{
		TradeStatus: alipay.TradeStatusSuccess,
		OutTradeNo:  log.OutTradeNo,
		TotalAmount: "11.00",
		AppId:       "migration-test-app",
	}
	var settled atomic.Int32
	for i := 0; i < 24; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			if Recharge.HandleAlipayNotification(ctx, notify) == "success" {
				settled.Add(1)
			}
		}()
	}
	wg.Wait()
	settledUser, err := store.User.ByID(ctx, user.ID)
	if err != nil {
		t.Fatal(err)
	}
	settledLog, err := store.RechargeLog.ByTradeNo(ctx, log.OutTradeNo)
	if err != nil {
		t.Fatal(err)
	}
	if settledUser.Balance != 11 || settledLog.Status != RechargeSuccess {
		t.Fatalf("settled callback state balance=%d status=%s", settledUser.Balance, settledLog.Status)
	}

	recoveryUser := &models.User{Name: "recovery_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex()}
	if err := store.User.Create(ctx, recoveryUser); err != nil {
		t.Fatal(err)
	}
	recoveryLog := &models.RechargeLog{
		UserID: recoveryUser.ID, Method: "Alipay", Balance: 7, OutTradeNo: bson.NewObjectID().Hex(),
		PaymentAppID: "migration-test-app", Status: "processing",
	}
	if err := store.RechargeLog.Create(ctx, recoveryLog); err != nil {
		t.Fatal(err)
	}
	if _, err := store.User.ApplyBalanceOnce(ctx, recoveryUser.ID, "alipay:"+recoveryLog.ID.Hex(), 7); err != nil {
		t.Fatal(err)
	}
	_, err = store.Collection(models.CollRechargeLogs).UpdateOne(ctx, bson.M{"_id": recoveryLog.ID}, bson.M{"$set": bson.M{"updatedAt": time.Now().Add(-2 * time.Minute)}})
	if err != nil {
		t.Fatal(err)
	}
	RecoverOperations(ctx)
	recoveredUser, err := store.User.ByID(ctx, recoveryUser.ID)
	if err != nil {
		t.Fatal(err)
	}
	recoveredLog, err := store.RechargeLog.ByTradeNo(ctx, recoveryLog.OutTradeNo)
	if err != nil {
		t.Fatal(err)
	}
	if recoveredUser.Balance != 7 || recoveredLog.Status != RechargeSuccess {
		t.Fatalf("recovered post-credit settlement balance=%d status=%s", recoveredUser.Balance, recoveredLog.Status)
	}

	legacyUser := &models.User{Name: "legacy_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex()}
	if err := store.User.Create(ctx, legacyUser); err != nil {
		t.Fatal(err)
	}
	legacyLog := &models.RechargeLog{UserID: legacyUser.ID, Method: "Alipay", Balance: 9, OutTradeNo: bson.NewObjectID().Hex(), Status: RechargePending}
	if err := store.RechargeLog.Create(ctx, legacyLog); err != nil {
		t.Fatal(err)
	}
	legacyNotify := &alipay.Notification{TradeStatus: alipay.TradeStatusSuccess, OutTradeNo: legacyLog.OutTradeNo, TotalAmount: "9.00", AppId: "migration-test-app"}
	if got := Recharge.HandleAlipayNotification(ctx, legacyNotify); got != "fail" {
		t.Fatalf("unbound legacy pending trade callback=%q, want fail-closed", got)
	}
	RecoverOperations(ctx)
	legacyUser, err = store.User.ByID(ctx, legacyUser.ID)
	if err != nil {
		t.Fatal(err)
	}
	if legacyUser.Balance != 0 {
		t.Fatalf("unbound legacy pending trade credited balance=%d, want 0", legacyUser.Balance)
	}

	renewUser := &models.User{Name: "renew_cancel_" + bson.NewObjectID().Hex(), Email: bson.NewObjectID().Hex() + "@test.invalid", UUID: bson.NewObjectID().Hex()}
	if err := store.User.Create(ctx, renewUser); err != nil {
		t.Fatal(err)
	}
	renewal := &models.WareEntity{UserID: renewUser.ID, ServerExternalID: "renew-cancel-" + bson.NewObjectID().Hex(), ValidDate: time.Now().Add(24 * time.Hour)}
	if err := store.Entity.Create(ctx, renewal); err != nil {
		t.Fatal(err)
	}
	originalDate := renewal.ValidDate
	validDate := renewal.ValidDate.AddDate(0, 1, 0)
	renewOp := models.BalanceRenewal{ID: "crash-cancel-" + bson.NewObjectID().Hex(), UserID: renewUser.ID, Amount: 5, ValidDate: validDate}
	if ok, err := store.Entity.BeginBalanceRenewal(ctx, renewal.ID, renewal.ValidDate, renewOp); err != nil || !ok {
		t.Fatalf("begin underfunded renewal = (%v, %v)", ok, err)
	}
	if _, err := store.User.ApplyBalanceOnce(ctx, renewUser.ID, "server-renew:"+renewOp.ID, -5); err != store.ErrInsufficientBalance {
		t.Fatalf("underfunded renewal debit error = %v", err)
	}
	if canceled, applied, err := store.User.CancelBalanceOperation(ctx, renewUser.ID, "server-renew:"+renewOp.ID, 5); err != nil || !canceled || applied {
		t.Fatalf("persist cancellation receipt = (%v, %v, %v)", canceled, applied, err)
	}
	RecoverOperations(ctx)
	renewal, err = store.Entity.ByID(ctx, renewal.ID)
	if err != nil {
		t.Fatal(err)
	}
	if renewal.BalanceRenewal != nil || !renewal.ValidDate.Equal(originalDate.Truncate(time.Millisecond)) {
		t.Fatalf("recovery of canceled renewal = op:%+v date:%v, want clear op and unchanged date", renewal.BalanceRenewal, renewal.ValidDate)
	}
	if err := store.User.AddBalance(ctx, renewUser.ID, 5); err != nil {
		t.Fatal(err)
	}
	newOp := models.BalanceRenewal{ID: "retry-" + bson.NewObjectID().Hex(), UserID: renewUser.ID, Amount: 5, ValidDate: validDate}
	if ok, err := store.Entity.BeginBalanceRenewal(ctx, renewal.ID, renewal.ValidDate, newOp); err != nil || !ok {
		t.Fatalf("start funded retry after cancellation recovery = (%v, %v)", ok, err)
	}
}
