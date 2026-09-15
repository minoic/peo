package store

import (
	"context"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// GalleryItems is the repository for the public screenshot album.
type GalleryItems struct{}

// Gallery is the default GalleryItems repository.
var Gallery = GalleryItems{}

// Create inserts an album item; it starts unapproved.
func (GalleryItems) Create(ctx context.Context, g *models.GalleryItem) error {
	_, err := insertOne(ctx, models.CollGalleryItems, g)
	return err
}

// ByID looks an album item up by primary key.
func (GalleryItems) ByID(ctx context.Context, id bson.ObjectID) (*models.GalleryItem, error) {
	return findOne[models.GalleryItem](ctx, models.CollGalleryItems, bson.M{"_id": id})
}

// Approved returns the publicly visible items, newest first.
func (GalleryItems) Approved(ctx context.Context) ([]models.GalleryItem, error) {
	return findMany[models.GalleryItem](ctx, models.CollGalleryItems,
		bson.M{"reviewPassed": true}, sortDesc("createdAt"))
}

// All returns every item including unapproved ones, for the admin list.
func (GalleryItems) All(ctx context.Context) ([]models.GalleryItem, error) {
	return findMany[models.GalleryItem](ctx, models.CollGalleryItems, bson.M{}, sortDesc("createdAt"))
}

// ByUser returns the items submitted by one user.
func (GalleryItems) ByUser(ctx context.Context, userID bson.ObjectID) ([]models.GalleryItem, error) {
	return findMany[models.GalleryItem](ctx, models.CollGalleryItems,
		bson.M{"userId": userID}, sortDesc("createdAt"))
}

// SetApproved flips the moderation flag.
func (GalleryItems) SetApproved(ctx context.Context, id bson.ObjectID, approved bool) error {
	_, err := updateOne(ctx, models.CollGalleryItems, bson.M{"_id": id}, bson.M{"reviewPassed": approved})
	return err
}

// IncrementLikes adds one like. The atomic $inc avoids a read-modify-write race
// that the legacy implementation had.
func (GalleryItems) IncrementLikes(ctx context.Context, id bson.ObjectID) error {
	_, err := updateOneRaw(ctx, models.CollGalleryItems, bson.M{"_id": id}, incUpdate(bson.M{"likes": 1}))
	return err
}

// Delete removes an album item.
func (GalleryItems) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollGalleryItems, bson.M{"_id": id})
	return err
}

// WorkOrders is the repository for support tickets.
type WorkOrders struct{}

// WorkOrder is the default WorkOrders repository.
var WorkOrder = WorkOrders{}

// Create opens a ticket.
func (WorkOrders) Create(ctx context.Context, w *models.WorkOrder) error {
	_, err := insertOne(ctx, models.CollWorkOrders, w)
	return err
}

// ByID looks a ticket up by primary key.
func (WorkOrders) ByID(ctx context.Context, id bson.ObjectID) (*models.WorkOrder, error) {
	return findOne[models.WorkOrder](ctx, models.CollWorkOrders, bson.M{"_id": id})
}

// Open returns every unclosed ticket, oldest first, for the admin list.
func (WorkOrders) Open(ctx context.Context) ([]models.WorkOrder, error) {
	return findMany[models.WorkOrder](ctx, models.CollWorkOrders,
		bson.M{"closed": false}, sortAsc("createdAt"))
}

// ByUser returns the tickets of a user, newest first.
func (WorkOrders) ByUser(ctx context.Context, userID bson.ObjectID) ([]models.WorkOrder, error) {
	return findMany[models.WorkOrder](ctx, models.CollWorkOrders,
		bson.M{"userId": userID}, sortDesc("createdAt"))
}

// CountOpen counts the unclosed tickets.
func (WorkOrders) CountOpen(ctx context.Context) (int64, error) {
	return count(ctx, models.CollWorkOrders, bson.M{"closed": false})
}

// Close marks a ticket as resolved.
func (WorkOrders) Close(ctx context.Context, id bson.ObjectID) error {
	_, err := updateOne(ctx, models.CollWorkOrders, bson.M{"_id": id}, bson.M{"closed": true})
	return err
}

// RechargeLogs is the repository for balance top-up history.
type RechargeLogs struct{}

// RechargeLog is the default RechargeLogs repository.
var RechargeLog = RechargeLogs{}

// Create appends a top-up attempt.
func (RechargeLogs) Create(ctx context.Context, l *models.RechargeLog) error {
	_, err := insertOne(ctx, models.CollRechargeLogs, l)
	return err
}

// ByUser returns the top-up history of a user, newest first.
func (RechargeLogs) ByUser(ctx context.Context, userID bson.ObjectID) ([]models.RechargeLog, error) {
	return findMany[models.RechargeLog](ctx, models.CollRechargeLogs,
		bson.M{"userId": userID}, sortDesc("createdAt"))
}

// ByTradeNo looks a top-up up by the Alipay trade number. The outTradeNo index
// is unique and sparse so many legacy rows without one remain valid.
func (RechargeLogs) ByTradeNo(ctx context.Context, tradeNo string) (*models.RechargeLog, error) {
	return findOne[models.RechargeLog](ctx, models.CollRechargeLogs, bson.M{"outTradeNo": tradeNo})
}

// MarkPaid records the outcome of an asynchronous Alipay callback.
func (RechargeLogs) MarkPaid(ctx context.Context, id bson.ObjectID, status string) error {
	_, err := updateOne(ctx, models.CollRechargeLogs, bson.M{"_id": id}, bson.M{"status": status})
	return err
}

// SetCode rewrites the human readable description of a top-up, which carries
// the balance before and after the credit.
func (RechargeLogs) SetCode(ctx context.Context, id bson.ObjectID, code string) error {
	_, err := updateOne(ctx, models.CollRechargeLogs, bson.M{"_id": id}, bson.M{"code": code})
	return err
}
