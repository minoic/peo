package store

import (
	"context"
	"errors"
	"time"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

// WareSpecs is the repository for product definitions.
type WareSpecs struct{}

// Spec is the default WareSpecs repository.
var Spec = WareSpecs{}

// Create inserts a product definition.
func (WareSpecs) Create(ctx context.Context, s *models.WareSpec) error {
	_, err := insertOne(ctx, models.CollWareSpecs, s)
	return err
}

// ByID looks a product up by primary key.
func (WareSpecs) ByID(ctx context.Context, id bson.ObjectID) (*models.WareSpec, error) {
	return findOne[models.WareSpec](ctx, models.CollWareSpecs, docIDFilter(id))
}

// All returns every product, oldest first so the storefront order is stable.
func (WareSpecs) All(ctx context.Context) ([]models.WareSpec, error) {
	return findMany[models.WareSpec](ctx, models.CollWareSpecs, bson.M{}, sortAsc("createdAt"))
}

// Count returns the number of product definitions.
func (WareSpecs) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollWareSpecs, bson.M{})
}

// Update replaces the editable fields of a product.
func (WareSpecs) Update(ctx context.Context, id bson.ObjectID, s *models.WareSpec) error {
	_, err := updateOne(ctx, models.CollWareSpecs, docIDFilter(id), bson.M{
		"pricePerMonth":     s.PricePerMonth,
		"wareName":          s.WareName,
		"wareDescription":   s.WareDescription,
		"node":              s.Node,
		"memory":            s.Memory,
		"cpu":               s.Cpu,
		"swap":              s.Swap,
		"disk":              s.Disk,
		"io":                s.Io,
		"backups":           s.Backups,
		"nest":              s.Nest,
		"legacyNestId":      s.LegacyNestID,
		"tagSlug":           s.TagSlug,
		"egg":               s.Egg,
		"allowedEggIds":     s.AllowedEggIDs,
		"discount":          s.Discount,
		"startOnCompletion": s.StartOnCompletion,
		"oomDisabled":       s.OomDisabled,
		"dockerImage":       s.DockerImage,
		"validDuration":     int64(s.ValidDuration),
		"deleteDuration":    int64(s.DeleteDuration),
	})
	return err
}

// Delete removes a product definition.
func (WareSpecs) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollWareSpecs, docIDFilter(id))
	return err
}

// WareEntities is the repository for provisioned servers.
type WareEntities struct{}

// Entity is the default WareEntities repository.
var Entity = WareEntities{}

// Create inserts a provisioned server record.
func (WareEntities) Create(ctx context.Context, e *models.WareEntity) error {
	_, err := insertOne(ctx, models.CollWareEntities, e)
	return err
}

// ByID looks a server up by primary key.
func (WareEntities) ByID(ctx context.Context, id bson.ObjectID) (*models.WareEntity, error) {
	return findOne[models.WareEntity](ctx, models.CollWareEntities, docIDFilter(id))
}

// ByUser returns the servers owned by a user, newest first.
func (WareEntities) ByUser(ctx context.Context, userID bson.ObjectID) ([]models.WareEntity, error) {
	return findMany[models.WareEntity](ctx, models.CollWareEntities,
		bson.M{"userId": userID}, sortDesc("createdAt"))
}

// All returns every server record.
func (WareEntities) All(ctx context.Context) ([]models.WareEntity, error) {
	return findMany[models.WareEntity](ctx, models.CollWareEntities, bson.M{})
}

// Count returns the number of provisioned servers.
func (WareEntities) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollWareEntities, bson.M{})
}

// Expired returns servers whose ValidDate is before the supplied instant,
// which is what the five-minute Pterodactyl sweeper consumes.
func (WareEntities) Expired(ctx context.Context, before time.Time) ([]models.WareEntity, error) {
	return findMany[models.WareEntity](ctx, models.CollWareEntities,
		bson.M{"validDate": bson.M{"$lt": before}}, sortAsc("validDate"))
}

// CountByUser counts the servers owned by a user.
func (WareEntities) CountByUser(ctx context.Context, userID bson.ObjectID) (int64, error) {
	return count(ctx, models.CollWareEntities, bson.M{"userId": userID})
}

// SetValidDate stores a new expiry instant.
func (WareEntities) SetValidDate(ctx context.Context, id bson.ObjectID, t time.Time) error {
	_, err := updateOne(ctx, models.CollWareEntities, docIDFilter(id), bson.M{"validDate": t})
	return err
}

// Renew atomically advances expiry and clears a pending deletion only if
// deletion has not already been claimed.
func (WareEntities) Renew(ctx context.Context, id bson.ObjectID, expected, next time.Time) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"validDate": expected, "deleteStatus": bson.M{"$ne": 3}, "balanceRenewal": bson.M{"$exists": false}, "keyRenewal": bson.M{"$exists": false}},
	}}, bson.M{"$set": bson.M{"validDate": next, "deleteStatus": 0, "updatedAt": time.Now()}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (WareEntities) BeginBalanceRenewal(ctx context.Context, id bson.ObjectID, expected time.Time, operation models.BalanceRenewal) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"validDate": expected, "deleteStatus": bson.M{"$ne": 3}, "balanceRenewal": bson.M{"$exists": false}, "keyRenewal": bson.M{"$exists": false}},
	}}, bson.M{"$set": bson.M{"balanceRenewal": operation, "updatedAt": time.Now()}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (WareEntities) FinishBalanceRenewal(ctx context.Context, id bson.ObjectID, operationID string, validDate time.Time) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"balanceRenewal.id": operationID},
	}}, bson.M{
		"$set":   bson.M{"validDate": validDate, "deleteStatus": 0, "updatedAt": time.Now()},
		"$unset": bson.M{"balanceRenewal": ""},
	})
	if err != nil {
		return err
	}
	if res.MatchedCount == 1 {
		return nil
	}
	current, err := findOne[models.WareEntity](ctx, models.CollWareEntities, docIDFilter(id))
	if err != nil {
		return err
	}
	if current.BalanceRenewal == nil && current.ValidDate.Equal(validDate) {
		return nil
	}
	return errors.New("store: renewal operation no longer matches entity state")
}

func (WareEntities) CancelBalanceRenewal(ctx context.Context, id bson.ObjectID, operationID string) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	_, err := Collection(models.CollWareEntities).UpdateOne(ctx,
		bson.M{"$and": bson.A{docIDFilter(id), bson.M{"balanceRenewal.id": operationID}}},
		bson.M{"$unset": bson.M{"balanceRenewal": ""}, "$set": bson.M{"updatedAt": time.Now()}},
	)
	return err
}

func (WareEntities) PendingBalanceRenewals(ctx context.Context) ([]models.WareEntity, error) {
	return findMany[models.WareEntity](ctx, models.CollWareEntities,
		bson.M{"balanceRenewal": bson.M{"$exists": true}}, sortAsc("updatedAt"), limitDocs(100))
}

// BeginKeyRenewal persists the target date before a code claim. Only one worker
// may hold its lease; after expiry a retry can acquire a fresh fencing token.
func (WareEntities) BeginKeyRenewal(ctx context.Context, entityID bson.ObjectID, expected time.Time, operation models.KeyRenewalOperation, now time.Time) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(entityID), bson.M{"$or": bson.A{
			bson.M{"validDate": expected, "deleteStatus": bson.M{"$ne": 3}, "balanceRenewal": bson.M{"$exists": false}, "keyRenewal": bson.M{"$exists": false}},
			bson.M{"validDate": expected, "keyRenewal.id": operation.ID, "keyRenewal.leaseUntil": bson.M{"$lte": now}},
		}},
	}}, bson.M{"$set": bson.M{"keyRenewal": operation, "updatedAt": now}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (WareEntities) CompleteKeyRenewal(ctx context.Context, entityID bson.ObjectID, operation models.KeyRenewalOperation) (applied, alreadyApplied bool, err error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(entityID), bson.M{"keyRenewal.id": operation.ID, "keyRenewal.leaseId": operation.LeaseID, "deleteStatus": bson.M{"$ne": 3}},
	}}, bson.M{
		"$set":      bson.M{"validDate": operation.ValidDate, "deleteStatus": 0, "updatedAt": time.Now()},
		"$addToSet": bson.M{"renewedKeyIds": operation.KeyID},
		"$unset":    bson.M{"keyRenewal": ""},
	})
	if err != nil {
		return false, false, err
	}
	if res.MatchedCount == 1 {
		return true, false, nil
	}
	current, err := findOne[models.WareEntity](ctx, models.CollWareEntities, docIDFilter(entityID))
	if err != nil {
		return false, false, err
	}
	for _, keyID := range current.RenewedKeyIDs {
		if keyID == operation.KeyID {
			return false, true, nil
		}
	}
	return false, false, nil
}

func (WareEntities) CancelKeyRenewal(ctx context.Context, entityID bson.ObjectID, operation models.KeyRenewalOperation) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	_, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(entityID), bson.M{"keyRenewal.id": operation.ID, "keyRenewal.leaseId": operation.LeaseID},
	}}, bson.M{"$unset": bson.M{"keyRenewal": ""}, "$set": bson.M{"updatedAt": time.Now()}})
	return err
}

func (WareEntities) PendingKeyRenewals(ctx context.Context, before time.Time) ([]models.WareEntity, error) {
	return findMany[models.WareEntity](ctx, models.CollWareEntities, bson.M{
		"keyRenewal.leaseUntil": bson.M{"$lte": before},
	}, sortAsc("updatedAt"), limitDocs(100))
}

// ClaimDelete fences renewal before panel deletion. Status 3 remains retryable
// after an upstream error.
func (WareEntities) ClaimDelete(ctx context.Context, id bson.ObjectID, status int) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	if status != 1 && status != 2 && status != 3 {
		return false, nil
	}
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"deleteStatus": status, "balanceRenewal": bson.M{"$exists": false}, "keyRenewal": bson.M{"$exists": false}},
	}}, bson.M{"$set": bson.M{"deleteStatus": 3, "updatedAt": time.Now()}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

// BeginPanelDelete atomically fences renewal and records the immutable Panel
// target before any remote deletion is attempted.
func (WareEntities) BeginPanelDelete(ctx context.Context, id bson.ObjectID, status int, op *models.PanelDeleteOperation) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	if status != 1 && status != 2 && status != 3 {
		return false, nil
	}
	if op.CreatedAt.IsZero() {
		op.CreatedAt = time.Now()
	}
	op.UpdatedAt = op.CreatedAt
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"deleteStatus": status, "balanceRenewal": bson.M{"$exists": false}, "keyRenewal": bson.M{"$exists": false}},
		bson.M{"$or": bson.A{bson.M{"panelDelete": bson.M{"$exists": false}}, bson.M{"panelDelete.id": op.ID}}},
	}}, bson.M{"$set": bson.M{"deleteStatus": 3, "panelDelete": op, "updatedAt": op.UpdatedAt}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (WareEntities) PendingPanelDeletes(ctx context.Context) ([]models.WareEntity, error) {
	return findMany[models.WareEntity](ctx, models.CollWareEntities, bson.M{"panelDelete.state": bson.M{"$ne": "completed"}, "deleteStatus": 3})
}

func (WareEntities) SetPanelDeleteState(ctx context.Context, id bson.ObjectID, opID, state string) error {
	_, err := updateOne(ctx, models.CollWareEntities, bson.M{"$and": bson.A{docIDFilter(id), bson.M{"panelDelete.id": opID}}}, bson.M{"panelDelete.state": state})
	return err
}

// ByOrder returns the local entity for a completed order if one exists.
func (WareEntities) ByOrder(ctx context.Context, orderID bson.ObjectID) (*models.WareEntity, error) {
	return findOne[models.WareEntity](ctx, models.CollWareEntities, bson.M{"orderId": orderID})
}

func (WareEntities) EnsureForOrder(ctx context.Context, orderID bson.ObjectID, entity *models.WareEntity) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	entity.OrderID = orderID
	entity.EnsureID()
	entity.StampNow(true)
	_, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"orderId": orderID}, bson.M{"$setOnInsert": entity}, options.UpdateOne().SetUpsert(true))
	return err
}

// SetDeleteStatus advances the deletion state machine (0 keep, 1 notice, 2 confirmed).
func (WareEntities) SetDeleteStatus(ctx context.Context, id bson.ObjectID, status int) error {
	_, err := updateOne(ctx, models.CollWareEntities, docIDFilter(id), bson.M{"deleteStatus": status})
	return err
}

func (WareEntities) SetDeleteStatusCAS(ctx context.Context, id bson.ObjectID, expectedStatus int, expectedDate time.Time, nextStatus int) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"deleteStatus": expectedStatus, "validDate": expectedDate, "balanceRenewal": bson.M{"$exists": false}, "keyRenewal": bson.M{"$exists": false}},
	}}, bson.M{"$set": bson.M{"deleteStatus": nextStatus, "updatedAt": time.Now()}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (WareEntities) ResetDeleteRequest(ctx context.Context, id bson.ObjectID) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx,
		bson.M{"$and": bson.A{docIDFilter(id), bson.M{"deleteStatus": 1, "keyRenewal": bson.M{"$exists": false}, "balanceRenewal": bson.M{"$exists": false}}}},
		bson.M{"$set": bson.M{"deleteStatus": 0, "updatedAt": time.Now()}},
	)
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (WareEntities) RequestDelete(ctx context.Context, id bson.ObjectID) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollWareEntities).UpdateOne(ctx,
		bson.M{"$and": bson.A{docIDFilter(id), bson.M{"deleteStatus": 0, "keyRenewal": bson.M{"$exists": false}, "balanceRenewal": bson.M{"$exists": false}}}},
		bson.M{"$set": bson.M{"deleteStatus": 1, "updatedAt": time.Now()}},
	)
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

// Delete removes a server record.
func (WareEntities) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollWareEntities, docIDFilter(id))
	return err
}

// DeleteConfirms is the repository for pending server deletions.
type DeleteConfirms struct{}

// DeleteConfirm is the default DeleteConfirms repository.
var DeleteConfirm = DeleteConfirms{}

// Create records that a server owner accepted deletion.
func (DeleteConfirms) Create(ctx context.Context, d *models.DeleteConfirm) error {
	_, err := insertOne(ctx, models.CollDeleteConfirms, d)
	return err
}

// All returns every pending deletion, oldest first.
func (DeleteConfirms) All(ctx context.Context) ([]models.DeleteConfirm, error) {
	return findMany[models.DeleteConfirm](ctx, models.CollDeleteConfirms, bson.M{}, sortAsc("createdAt"))
}

// ByWare returns the deletion record of a server, if any.
func (DeleteConfirms) ByWare(ctx context.Context, wareID bson.ObjectID) (*models.DeleteConfirm, error) {
	return findOne[models.DeleteConfirm](ctx, models.CollDeleteConfirms, bson.M{"wareId": wareID})
}

// DeleteByWare removes the deletion record of a server.
func (DeleteConfirms) DeleteByWare(ctx context.Context, wareID bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollDeleteConfirms, bson.M{"wareId": wareID})
	return err
}

// DeleteByID removes a single deletion record.
func (DeleteConfirms) DeleteByID(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollDeleteConfirms, docIDFilter(id))
	return err
}

// Count returns the number of pending deletions.
func (DeleteConfirms) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollDeleteConfirms, bson.M{})
}
