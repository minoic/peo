package store

import (
	"context"
	"time"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// Keys is the repository for product activation codes.
type Keys struct{}

// Key is the default Keys repository.
var Key = Keys{}

// Create inserts one activation code.
func (Keys) Create(ctx context.Context, k *models.WareKey) error {
	_, err := insertOne(ctx, models.CollWareKeys, k)
	return err
}

// CreateBatch inserts many activation codes in a single round trip.
func (Keys) CreateBatch(ctx context.Context, ks []models.WareKey) error {
	docs := make([]any, len(ks))
	for i := range ks {
		docs[i] = &ks[i]
	}
	return insertMany(ctx, models.CollWareKeys, docs)
}

// ByID looks an activation code up by primary key.
func (Keys) ByID(ctx context.Context, id bson.ObjectID) (*models.WareKey, error) {
	return findOne[models.WareKey](ctx, models.CollWareKeys, bson.M{"_id": id})
}

// ByString looks an activation code up by its redeem string.
func (Keys) ByString(ctx context.Context, s string) (*models.WareKey, error) {
	return findOne[models.WareKey](ctx, models.CollWareKeys, bson.M{"keyString": s})
}

// All returns every activation code, newest first.
func (Keys) All(ctx context.Context) ([]models.WareKey, error) {
	return findMany[models.WareKey](ctx, models.CollWareKeys, bson.M{}, sortDesc("createdAt"))
}

// BySpec returns the codes belonging to one product.
func (Keys) BySpec(ctx context.Context, specID bson.ObjectID) ([]models.WareKey, error) {
	return findMany[models.WareKey](ctx, models.CollWareKeys, bson.M{"specId": specID})
}

// Count returns the number of product codes.
func (Keys) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollWareKeys, bson.M{})
}

// Delete removes an activation code after it has been redeemed.
func (Keys) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollWareKeys, bson.M{"_id": id})
	return err
}

// DeleteExpired removes every code whose expiry has passed and returns the
// number of documents removed.
func (Keys) DeleteExpired(ctx context.Context, before time.Time) (int64, error) {
	return deleteMany(ctx, models.CollWareKeys, bson.M{"exp": bson.M{"$lt": before}})
}

// RechargeKeys is the repository for balance top-up codes.
type RechargeKeys struct{}

// RKey is the default RechargeKeys repository.
var RKey = RechargeKeys{}

// Create inserts one recharge code.
func (RechargeKeys) Create(ctx context.Context, k *models.RechargeKey) error {
	_, err := insertOne(ctx, models.CollRechargeKeys, k)
	return err
}

// CreateBatch inserts many recharge codes in a single round trip.
func (RechargeKeys) CreateBatch(ctx context.Context, ks []models.RechargeKey) error {
	docs := make([]any, len(ks))
	for i := range ks {
		docs[i] = &ks[i]
	}
	return insertMany(ctx, models.CollRechargeKeys, docs)
}

// ByString looks a recharge code up by its redeem string.
func (RechargeKeys) ByString(ctx context.Context, s string) (*models.RechargeKey, error) {
	return findOne[models.RechargeKey](ctx, models.CollRechargeKeys, bson.M{"keyString": s})
}

// All returns every recharge code, newest first.
func (RechargeKeys) All(ctx context.Context) ([]models.RechargeKey, error) {
	return findMany[models.RechargeKey](ctx, models.CollRechargeKeys, bson.M{}, sortDesc("createdAt"))
}

// ByBalance returns the codes worth a specific amount.
func (RechargeKeys) ByBalance(ctx context.Context, balance uint) ([]models.RechargeKey, error) {
	return findMany[models.RechargeKey](ctx, models.CollRechargeKeys, bson.M{"balance": balance})
}

// Count returns the number of recharge codes.
func (RechargeKeys) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollRechargeKeys, bson.M{})
}

// Delete removes a recharge code after it has been redeemed.
func (RechargeKeys) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollRechargeKeys, bson.M{"_id": id})
	return err
}

// DeleteExpired removes every code whose expiry has passed.
func (RechargeKeys) DeleteExpired(ctx context.Context, before time.Time) (int64, error) {
	return deleteMany(ctx, models.CollRechargeKeys, bson.M{"exp": bson.M{"$lt": before}})
}

// RegConfirmKeys is the repository for registration confirmation tokens.
type RegConfirmKeys struct{}

// RegConfirm is the default RegConfirmKeys repository.
var RegConfirm = RegConfirmKeys{}

// Create inserts a confirmation token.
func (RegConfirmKeys) Create(ctx context.Context, k *models.RegConfirmKey) error {
	_, err := insertOne(ctx, models.CollRegConfirmKeys, k)
	return err
}

// ByString looks a confirmation token up by its string.
func (RegConfirmKeys) ByString(ctx context.Context, s string) (*models.RegConfirmKey, error) {
	return findOne[models.RegConfirmKey](ctx, models.CollRegConfirmKeys, bson.M{"keyString": s})
}

// Delete removes a used confirmation token.
func (RegConfirmKeys) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollRegConfirmKeys, bson.M{"_id": id})
	return err
}
