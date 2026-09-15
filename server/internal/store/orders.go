package store

import (
	"context"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// Orders is the repository for purchase intents.
type Orders struct{}

// Order is the default Orders repository.
var Order = Orders{}

// Create inserts a pending order.
func (Orders) Create(ctx context.Context, o *models.Order) error {
	_, err := insertOne(ctx, models.CollOrders, o)
	return err
}

// ByID looks an order up by primary key.
func (Orders) ByID(ctx context.Context, id bson.ObjectID) (*models.Order, error) {
	return findOne[models.Order](ctx, models.CollOrders, bson.M{"_id": id})
}

// ByUser returns the orders of a user, newest first.
func (Orders) ByUser(ctx context.Context, userID bson.ObjectID) ([]models.Order, error) {
	return findMany[models.Order](ctx, models.CollOrders,
		bson.M{"userId": userID}, sortDesc("createdAt"))
}

// Confirmed returns every paid order, which is what the admin list shows.
func (Orders) Confirmed(ctx context.Context) ([]models.Order, error) {
	return findMany[models.Order](ctx, models.CollOrders, bson.M{"confirmed": true}, sortDesc("createdAt"))
}

// Count returns the total number of orders.
func (Orders) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollOrders, bson.M{})
}

// CountConfirmed returns the number of paid orders.
func (Orders) CountConfirmed(ctx context.Context) (int64, error) {
	return count(ctx, models.CollOrders, bson.M{"confirmed": true})
}

// SetPaid flags an order as paid.
func (Orders) SetPaid(ctx context.Context, id bson.ObjectID, paid bool) error {
	_, err := updateOne(ctx, models.CollOrders, bson.M{"_id": id}, bson.M{"paid": paid})
	return err
}

// SetConfirmed flags an order as fulfilled, which also implies paid.
func (Orders) SetConfirmed(ctx context.Context, id bson.ObjectID, confirmed bool) error {
	fields := bson.M{"confirmed": confirmed}
	if confirmed {
		fields["paid"] = true
	}
	_, err := updateOne(ctx, models.CollOrders, bson.M{"_id": id}, fields)
	return err
}

// SetAllocation records the Pterodactyl allocation chosen for the order.
func (Orders) SetAllocation(ctx context.Context, id bson.ObjectID, allocationID int) error {
	_, err := updateOne(ctx, models.CollOrders, bson.M{"_id": id}, bson.M{"allocationId": allocationID})
	return err
}

// Messages is the repository for internal site mail.
type Messages struct{}

// Message is the default Messages repository.
var Message = Messages{}

// Create inserts a message.
func (Messages) Create(ctx context.Context, m *models.Message) error {
	_, err := insertOne(ctx, models.CollMessages, m)
	return err
}

// CreateBatch inserts many messages at once.
func (Messages) CreateBatch(ctx context.Context, ms []models.Message) error {
	docs := make([]any, len(ms))
	for i := range ms {
		docs[i] = &ms[i]
	}
	return insertMany(ctx, models.CollMessages, docs)
}

// ByID looks a message up by primary key, which the API layer needs before it
// can check that the caller is the receiver.
func (Messages) ByID(ctx context.Context, id bson.ObjectID) (*models.Message, error) {
	return findOne[models.Message](ctx, models.CollMessages, bson.M{"_id": id})
}

// ByUser returns the messages of a user, newest first.
func (Messages) ByUser(ctx context.Context, userID bson.ObjectID) ([]models.Message, error) {
	return findMany[models.Message](ctx, models.CollMessages,
		bson.M{"receiverId": userID}, sortDesc("createdAt"))
}

// UnreadCount is the badge number shown in the navigation bar.
func (Messages) UnreadCount(ctx context.Context, userID bson.ObjectID) (int64, error) {
	return count(ctx, models.CollMessages, bson.M{"receiverId": userID, "haveRead": false})
}

// MarkRead flags a single message as read.
func (Messages) MarkRead(ctx context.Context, id bson.ObjectID) error {
	_, err := updateOne(ctx, models.CollMessages, bson.M{"_id": id}, bson.M{"haveRead": true})
	return err
}

// MarkAllRead flags every message of a user as read.
func (Messages) MarkAllRead(ctx context.Context, userID bson.ObjectID) error {
	_, err := updateMany(ctx, models.CollMessages,
		bson.M{"receiverId": userID, "haveRead": false}, bson.M{"haveRead": true})
	return err
}

// Delete removes a message.
func (Messages) Delete(ctx context.Context, id bson.ObjectID) error {
	_, err := deleteOne(ctx, models.CollMessages, bson.M{"_id": id})
	return err
}

// Broadcast stores the same message body for a set of recipients.
func (Messages) Broadcast(ctx context.Context, sender, text, timeText string, receivers []bson.ObjectID) error {
	if len(receivers) == 0 {
		return nil
	}
	ms := make([]models.Message, 0, len(receivers))
	for _, r := range receivers {
		ms = append(ms, models.Message{SenderName: sender, ReceiverID: r, Text: text, TimeText: timeText})
	}
	return (Messages{}).CreateBatch(ctx, ms)
}
