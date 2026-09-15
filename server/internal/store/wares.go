package store

import (
	"context"
	"time"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
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
	return findOne[models.WareSpec](ctx, models.CollWareSpecs, bson.M{"_id": id})
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
	_, err := updateOne(ctx, models.CollWareSpecs, bson.M{"_id": id}, bson.M{
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
		"egg":               s.Egg,
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
	_, err := deleteOne(ctx, models.CollWareSpecs, bson.M{"_id": id})
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
	return findOne[models.WareEntity](ctx, models.CollWareEntities, bson.M{"_id": id})
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
	_, err := updateOne(ctx, models.CollWareEntities, bson.M{"_id": id}, bson.M{"validDate": t})
	return err
}

// SetDeleteStatus advances the deletion state machine (0 keep, 1 notice, 2 confirmed).
func (WareEntities) SetDeleteStatus(ctx context.Context, id bson.ObjectID, status int) error {
	_, err := updateOne(ctx, models.CollWareEntities, bson.M{"_id": id}, bson.M{"deleteStatus": status})
	return err
}

// Delete removes a server record.
func (WareEntities) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollWareEntities, bson.M{"_id": id})
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
	_, err := deleteOne(ctx, models.CollDeleteConfirms, bson.M{"_id": id})
	return err
}

// Count returns the number of pending deletions.
func (DeleteConfirms) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollDeleteConfirms, bson.M{})
}
