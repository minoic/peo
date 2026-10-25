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
)

func TestFinanceAtomicOperationsMongo(t *testing.T) {
	uri := strings.TrimSpace(os.Getenv("PEO_TEST_MONGO_URI"))
	if uri == "" {
		t.Skip("set PEO_TEST_MONGO_URI to run MongoDB concurrency integration test")
	}
	name := fmt.Sprintf("peo_migrationreview_%d", time.Now().UnixNano())
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

	u := &models.User{Name: "finance_test", Email: "finance@test.invalid", Balance: 1000, UUID: bson.NewObjectID().Hex()}
	if err := User.Create(ctx, u); err != nil {
		t.Fatal(err)
	}

	var applied atomic.Int32
	var wg sync.WaitGroup
	for i := 0; i < 32; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			ok, err := User.ApplyBalanceOnce(ctx, u.ID, "alipay:single-operation", 50)
			if err != nil {
				t.Errorf("ApplyBalanceOnce: %v", err)
			}
			if ok {
				applied.Add(1)
			}
		}()
	}
	wg.Wait()
	if got := applied.Load(); got != 1 {
		t.Fatalf("one operation applied %d times, want 1", got)
	}

	var charged atomic.Int32
	for i := 0; i < 20; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			if err := User.DebitBalance(ctx, u.ID, 100); err == nil {
				charged.Add(1)
			}
		}()
	}
	wg.Wait()
	if got := charged.Load(); got != 10 {
		t.Fatalf("successful charges=%d, want exactly 10", got)
	}
	updated, err := User.ByID(ctx, u.ID)
	if err != nil {
		t.Fatal(err)
	}
	if updated.Balance != 50 {
		t.Fatalf("balance=%d, want 50", updated.Balance)
	}

	key := &models.WareKey{SpecID: bson.NewObjectID(), KeyString: "single-claim", Exp: time.Now().Add(time.Hour)}
	if err := Key.Create(ctx, key); err != nil {
		t.Fatal(err)
	}
	var claimed atomic.Int32
	for i := 0; i < 24; i++ {
		owner := bson.NewObjectID()
		wg.Add(1)
		go func() {
			defer wg.Done()
			_, err := Key.Claim(ctx, key.ID, owner.Hex(), owner, key.SpecID, time.Now())
			if err == nil {
				claimed.Add(1)
			}
		}()
	}
	wg.Wait()
	if got := claimed.Load(); got != 1 {
		t.Fatalf("claimed key %d times, want exactly once", got)
	}
	claimedKey, err := Key.ByID(ctx, key.ID)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := Key.Claim(ctx, key.ID, claimedKey.ClaimID, claimedKey.ClaimUser, key.SpecID, time.Now().Add(24*time.Hour)); err != nil {
		t.Fatalf("same-owner retry after code expiry: %v", err)
	}

	deleteEntity := &models.WareEntity{UserID: u.ID, ServerExternalID: "delete-race", ValidDate: time.Now().Add(-24 * time.Hour), DeleteStatus: 1}
	if err := Entity.Create(ctx, deleteEntity); err != nil {
		t.Fatal(err)
	}
	if ok, err := Entity.ClaimDelete(ctx, deleteEntity.ID, 1); err != nil || !ok {
		t.Fatalf("ClaimDelete = (%v, %v), want true", ok, err)
	}
	if ok, err := Entity.Renew(ctx, deleteEntity.ID, deleteEntity.ValidDate, time.Now().Add(time.Hour)); err != nil || ok {
		t.Fatalf("renew after deletion claim = (%v, %v), want false", ok, err)
	}

	keyEntity := &models.WareEntity{UserID: u.ID, ServerExternalID: "key-renew-race", ValidDate: time.Now().Add(-24 * time.Hour), DeleteStatus: 1}
	if err := Entity.Create(ctx, keyEntity); err != nil {
		t.Fatal(err)
	}
	startedAt := time.Now()
	keyID := bson.NewObjectID()
	keyOp := models.KeyRenewalOperation{ID: "renew:" + keyEntity.ID.Hex() + ":" + keyID.Hex(), LeaseID: "lease-a", LeaseUntil: startedAt.Add(time.Minute), UserID: u.ID, KeyID: keyID, ValidDate: keyEntity.ValidDate.AddDate(0, 0, 30), CreatedAt: startedAt, UpdatedAt: startedAt}
	if ok, err := Entity.BeginKeyRenewal(ctx, keyEntity.ID, keyEntity.ValidDate, keyOp, startedAt); err != nil || !ok {
		t.Fatalf("BeginKeyRenewal = (%v, %v), want true", ok, err)
	}
	if ok, err := Entity.ClaimDelete(ctx, keyEntity.ID, 1); err != nil || ok {
		t.Fatalf("ClaimDelete during key renewal = (%v, %v), want false", ok, err)
	}
	if ok, err := Entity.BeginKeyRenewal(ctx, keyEntity.ID, keyEntity.ValidDate, keyOp, startedAt.Add(30*time.Second)); err != nil || ok {
		t.Fatalf("second worker before lease expiry = (%v, %v), want false", ok, err)
	}
	keyOp.LeaseID = "lease-b"
	keyOp.LeaseUntil = startedAt.Add(3 * time.Minute)
	keyOp.UpdatedAt = startedAt.Add(2 * time.Minute)
	if ok, err := Entity.BeginKeyRenewal(ctx, keyEntity.ID, keyEntity.ValidDate, keyOp, startedAt.Add(2*time.Minute)); err != nil || !ok {
		t.Fatalf("take over expired key renewal = (%v, %v), want true", ok, err)
	}
	if applied, done, err := Entity.CompleteKeyRenewal(ctx, keyEntity.ID, models.KeyRenewalOperation{ID: keyOp.ID, LeaseID: "lease-a", KeyID: keyID, ValidDate: keyOp.ValidDate}); err != nil || applied || done {
		t.Fatalf("stale worker completion = (%v, %v, %v), want false,false", applied, done, err)
	}
	if applied, done, err := Entity.CompleteKeyRenewal(ctx, keyEntity.ID, keyOp); err != nil || !applied || done {
		t.Fatalf("lease holder completion = (%v, %v, %v), want true,false", applied, done, err)
	}

	renewEntity := &models.WareEntity{UserID: u.ID, ServerExternalID: "renew-race", ValidDate: time.Now().Add(-24 * time.Hour), DeleteStatus: 1}
	if err := Entity.Create(ctx, renewEntity); err != nil {
		t.Fatal(err)
	}
	op := models.BalanceRenewal{ID: "renew-op", UserID: u.ID, Amount: 10, ValidDate: renewEntity.ValidDate.AddDate(0, 1, 0)}
	if ok, err := Entity.BeginBalanceRenewal(ctx, renewEntity.ID, renewEntity.ValidDate, op); err != nil || !ok {
		t.Fatalf("BeginBalanceRenewal = (%v, %v), want true", ok, err)
	}
	if ok, err := Entity.ClaimDelete(ctx, renewEntity.ID, 1); err != nil || ok {
		t.Fatalf("ClaimDelete during renewal = (%v, %v), want false", ok, err)
	}
	if _, err := User.ApplyBalanceOnce(ctx, u.ID, "server-renew:"+op.ID, -10); err != nil {
		t.Fatal(err)
	}
	if err := Entity.FinishBalanceRenewal(ctx, renewEntity.ID, op.ID, op.ValidDate); err != nil {
		t.Fatal(err)
	}
	finished, err := Entity.ByID(ctx, renewEntity.ID)
	if err != nil {
		t.Fatal(err)
	}
	if !finished.ValidDate.Equal(op.ValidDate.Truncate(time.Millisecond)) || finished.DeleteStatus != 0 || finished.BalanceRenewal != nil {
		t.Fatalf("renewal final state = (%v, %d, %+v)", finished.ValidDate, finished.DeleteStatus, finished.BalanceRenewal)
	}

	poor := &models.User{Name: "finance_poor", Email: "poor@test.invalid", Balance: 0, UUID: bson.NewObjectID().Hex()}
	if err := User.Create(ctx, poor); err != nil {
		t.Fatal(err)
	}
	if _, err := User.ApplyBalanceOnce(ctx, poor.ID, "short-funds", -100); err != ErrInsufficientBalance {
		t.Fatalf("initial underfunded operation error = %v", err)
	}
	if canceled, applied, err := User.CancelBalanceOperation(ctx, poor.ID, "short-funds", 100); err != nil || !canceled || applied {
		t.Fatalf("cancel underfunded operation = (%v, %v, %v)", canceled, applied, err)
	}
	if err := User.AddBalance(ctx, poor.ID, 200); err != nil {
		t.Fatal(err)
	}
	if _, err := User.ApplyBalanceOnce(ctx, poor.ID, "short-funds", -100); err != ErrBalanceOperationCanceled {
		t.Fatalf("stale operation after cancellation error = %v", err)
	}
	poorAfter, err := User.ByID(ctx, poor.ID)
	if err != nil || poorAfter.Balance != 200 {
		t.Fatalf("balance after canceled stale operation = (%v, %v)", poorAfter, err)
	}

	receipts := make([]string, maxBalanceOperationReceipts)
	for i := range receipts {
		receipts[i] = fmt.Sprintf("receipt-%d", i)
	}
	full := &models.User{Name: "finance_full", Email: "full@test.invalid", Balance: 100, UUID: bson.NewObjectID().Hex(), BalanceOperations: receipts}
	if err := User.Create(ctx, full); err != nil {
		t.Fatal(err)
	}
	if _, err := User.ApplyBalanceOnce(ctx, full.ID, "one-more", 1); err != ErrBalanceOperationCapacity {
		t.Fatalf("operation at receipt capacity error = %v", err)
	}
	if _, _, err := User.CancelBalanceOperation(ctx, full.ID, "one-more-cancel", 200); err != ErrBalanceOperationCapacity {
		t.Fatalf("cancellation at receipt capacity error = %v", err)
	}
}
