package store

import (
	"context"
	"errors"
	"time"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
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
	return findOne[models.WareKey](ctx, models.CollWareKeys, docIDFilter(id))
}

// ByString looks an activation code up by its redeem string.
func (Keys) ByString(ctx context.Context, s string) (*models.WareKey, error) {
	return findOne[models.WareKey](ctx, models.CollWareKeys, bson.M{"keyString": s})
}

// Claim atomically assigns a key to one operation. A missing claimId is treated
// as unclaimed so documents created before claims were introduced keep working.
func (Keys) Claim(ctx context.Context, id bson.ObjectID, claimID string, userID bson.ObjectID, specID bson.ObjectID, now time.Time) (*models.WareKey, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	filter := bson.M{"$and": bson.A{docIDFilter(id), bson.M{"$or": bson.A{
		bson.M{"claimId": bson.M{"$exists": false}},
		bson.M{"claimId": ""},
		bson.M{"claimId": claimID, "claimUser": userID},
	}}, bson.M{"$or": bson.A{bson.M{"exp": bson.M{"$gte": now}}, bson.M{"claimId": claimID, "claimUser": userID}}}}}
	if !specID.IsZero() {
		filter["$and"] = append(filter["$and"].(bson.A), bson.M{"specId": specID})
	}
	var key models.WareKey
	err := Collection(models.CollWareKeys).FindOneAndUpdate(ctx, filter, bson.M{
		"$set": bson.M{"claimId": claimID, "claimUser": userID, "updatedAt": time.Now()},
	}, options.FindOneAndUpdate().SetReturnDocument(options.After)).Decode(&key)
	if err != nil {
		return nil, err
	}
	return &key, nil
}

func (Keys) ClaimedBefore(ctx context.Context, before time.Time) ([]models.WareKey, error) {
	return findMany[models.WareKey](ctx, models.CollWareKeys, bson.M{
		"claimId":   bson.M{"$exists": true, "$ne": ""},
		"updatedAt": bson.M{"$lt": before},
	}, sortAsc("updatedAt"), limitDocs(100))
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
	_, err := deleteOne(ctx, models.CollWareKeys, docIDFilter(id))
	return err
}

func (Keys) DeleteClaimed(ctx context.Context, id bson.ObjectID, claimID string, userID bson.ObjectID) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareKeys).DeleteOne(ctx, bson.M{"$and": bson.A{docIDFilter(id), bson.M{"claimId": claimID, "claimUser": userID}}})
	if err != nil {
		return err
	}
	if res.DeletedCount == 1 {
		return nil
	}
	key, err := findOne[models.WareKey](ctx, models.CollWareKeys, docIDFilter(id))
	if errors.Is(err, ErrNotFound) {
		return nil
	}
	if err != nil {
		return err
	}
	if key.ClaimID != claimID || key.ClaimUser != userID {
		return errors.New("store: activation code claim changed before consumption")
	}
	return nil
}

// DeleteExpired removes every code whose expiry has passed and returns the
// number of documents removed.
func (Keys) DeleteExpired(ctx context.Context, before time.Time) (int64, error) {
	entities, err := findMany[models.WareEntity](ctx, models.CollWareEntities, bson.M{"keyRenewal.keyId": bson.M{"$exists": true}})
	if err != nil {
		return 0, err
	}
	filter := bson.M{"exp": bson.M{"$lt": before}, "$or": bson.A{
		bson.M{"claimId": bson.M{"$exists": false}}, bson.M{"claimId": ""},
	}}
	if len(entities) > 0 {
		pendingIDs := make(bson.A, 0, len(entities))
		for i := range entities {
			if entities[i].KeyRenewal == nil {
				continue
			}
			pendingIDs = append(pendingIDs, entities[i].KeyRenewal.KeyID)
		}
		if len(pendingIDs) > 0 {
			filter["_id"] = bson.M{"$nin": pendingIDs}
		}
	}
	return deleteMany(ctx, models.CollWareKeys, filter)
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

// Claim atomically assigns an unexpired recharge code to one redemption.
func (RechargeKeys) Claim(ctx context.Context, id bson.ObjectID, claimID string, userID bson.ObjectID, now time.Time) (*models.RechargeKey, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	filter := bson.M{"$and": bson.A{docIDFilter(id), bson.M{"$or": bson.A{
		bson.M{"claimId": bson.M{"$exists": false}},
		bson.M{"claimId": ""},
		bson.M{"claimId": claimID, "claimUser": userID},
	}}, bson.M{"$or": bson.A{bson.M{"exp": bson.M{"$gte": now}}, bson.M{"claimId": claimID, "claimUser": userID}}}}}
	var key models.RechargeKey
	err := Collection(models.CollRechargeKeys).FindOneAndUpdate(ctx, filter, bson.M{
		"$set": bson.M{"claimId": claimID, "claimUser": userID, "updatedAt": time.Now()},
	}, options.FindOneAndUpdate().SetReturnDocument(options.After)).Decode(&key)
	if err != nil {
		return nil, err
	}
	return &key, nil
}

func (RechargeKeys) ClaimedBefore(ctx context.Context, before time.Time) ([]models.RechargeKey, error) {
	return findMany[models.RechargeKey](ctx, models.CollRechargeKeys, bson.M{
		"claimId":   bson.M{"$exists": true, "$ne": ""},
		"updatedAt": bson.M{"$lt": before},
	}, sortAsc("updatedAt"), limitDocs(100))
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
	_, err := deleteOne(ctx, models.CollRechargeKeys, docIDFilter(id))
	return err
}

// DeleteExpired removes every code whose expiry has passed.
func (RechargeKeys) DeleteExpired(ctx context.Context, before time.Time) (int64, error) {
	return deleteMany(ctx, models.CollRechargeKeys, bson.M{"exp": bson.M{"$lt": before}, "$or": bson.A{
		bson.M{"claimId": bson.M{"$exists": false}}, bson.M{"claimId": ""},
	}})
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
	_, err := deleteOne(ctx, models.CollRegConfirmKeys, docIDFilter(id))
	return err
}
