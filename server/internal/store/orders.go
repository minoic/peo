package store

import (
	"context"
	"errors"
	"time"

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
	return findOne[models.Order](ctx, models.CollOrders, docIDFilter(id))
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
	_, err := updateOne(ctx, models.CollOrders, docIDFilter(id), bson.M{"paid": paid})
	return err
}

// SetConfirmed flags an order as fulfilled, which also implies paid.
func (Orders) SetConfirmed(ctx context.Context, id bson.ObjectID, confirmed bool) error {
	fields := bson.M{"confirmed": confirmed}
	if confirmed {
		fields["paid"] = true
	}
	_, err := updateOne(ctx, models.CollOrders, docIDFilter(id), fields)
	return err
}

// CloseExpired marks unpaid orders closed after the payment window. An active
// provisioning operation wins the race and remains recoverable.
func (Orders) CloseExpired(ctx context.Context, now time.Time) (int64, error) {
	return closeExpired(ctx, bson.M{}, now)
}

// CloseExpiredByUser lazily closes only the caller's expired orders.
func (Orders) CloseExpiredByUser(ctx context.Context, userID bson.ObjectID, now time.Time) (int64, error) {
	return closeExpired(ctx, bson.M{"userId": userID}, now)
}

func closeExpired(ctx context.Context, scope bson.M, now time.Time) (int64, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	cutoff := now.Add(-models.OrderPaymentWindow)
	filters := bson.A{scope,
		bson.M{"closed": bson.M{"$ne": true}},
		bson.M{"paid": bson.M{"$ne": true}},
		orderCreatedAtAtOrBefore(cutoff),
		bson.M{"confirmed": bson.M{"$ne": true}},
		bson.M{"$or": bson.A{bson.M{"provision": bson.M{"$exists": false}}, bson.M{"provision.state": "payment_failed"}}},
	}
	res, err := Collection(models.CollOrders).UpdateMany(ctx, bson.M{"$and": filters}, bson.M{"$set": bson.M{"closed": true, "closedAt": now, "updatedAt": now}})
	if err != nil {
		return 0, err
	}
	return res.ModifiedCount, nil
}

// CloseIfExpired applies the same conditional transition to one order before
// returning it to the customer.
func (Orders) CloseIfExpired(ctx context.Context, id bson.ObjectID, now time.Time) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	cutoff := now.Add(-models.OrderPaymentWindow)
	filters := bson.A{
		docIDFilter(id), bson.M{"closed": bson.M{"$ne": true}}, bson.M{"paid": bson.M{"$ne": true}}, bson.M{"confirmed": bson.M{"$ne": true}},
		orderCreatedAtAtOrBefore(cutoff),
		bson.M{"$or": bson.A{bson.M{"provision": bson.M{"$exists": false}}, bson.M{"provision.state": "payment_failed"}}},
	}
	_, err := Collection(models.CollOrders).UpdateOne(ctx, bson.M{"$and": filters}, bson.M{"$set": bson.M{"closed": true, "closedAt": now, "updatedAt": now}})
	return err
}

func orderCreatedAtAtOrBefore(cutoff time.Time) bson.M {
	return bson.M{"$or": bson.A{
		bson.M{"createdAt": bson.M{"$lte": cutoff}},
		bson.M{"createdAt": bson.M{"$exists": false}, "doc.createdAt": bson.M{"$lte": cutoff}},
	}}
}

func orderCreatedAtAfter(cutoff time.Time) bson.M {
	return bson.M{"$or": bson.A{
		bson.M{"createdAt": bson.M{"$gt": cutoff}},
		bson.M{"createdAt": bson.M{"$exists": false}, "doc.createdAt": bson.M{"$gt": cutoff}},
	}}
}

// SetAllocation records the Pterodactyl allocation chosen for the order.
func (Orders) SetAllocation(ctx context.Context, id bson.ObjectID, allocationID int) error {
	_, err := updateOne(ctx, models.CollOrders, docIDFilter(id), bson.M{"allocationId": allocationID})
	return err
}

// BeginProvision claims the order for one durable payment and provisioning
// operation before any payment or panel mutation occurs.
func (Orders) BeginProvision(ctx context.Context, id bson.ObjectID, op *models.ProvisionOperation) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	op.CreatedAt = time.Now()
	op.UpdatedAt = op.CreatedAt
	now := op.CreatedAt
	cutoff := now.Add(-models.OrderPaymentWindow)
	res, err := Collection(models.CollOrders).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"paid": bson.M{"$ne": true}}, bson.M{"confirmed": bson.M{"$ne": true}}, bson.M{"closed": bson.M{"$ne": true}},
		orderCreatedAtAfter(cutoff),
		bson.M{"$or": bson.A{bson.M{"provision": bson.M{"$exists": false}}, bson.M{"provision.state": "payment_failed"}}},
	}}, bson.M{"$set": bson.M{"provision": op, "updatedAt": op.UpdatedAt}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (Orders) AcquireProvisionLease(ctx context.Context, id bson.ObjectID, opID, leaseID string, now, until time.Time) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollOrders).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"provision.id": opID, "provision.state": bson.M{"$nin": bson.A{"completed", "payment_failed"}}},
		bson.M{"$or": bson.A{bson.M{"provision.leaseUntil": bson.M{"$exists": false}}, bson.M{"provision.leaseUntil": bson.M{"$lte": now}}, bson.M{"provision.leaseId": leaseID}}},
	}}, bson.M{"$set": bson.M{"provision.leaseId": leaseID, "provision.leaseUntil": until, "updatedAt": now}})
	if err != nil {
		return false, err
	}
	return res.MatchedCount == 1, nil
}

func (Orders) AdvanceProvision(ctx context.Context, id bson.ObjectID, opID, leaseID, state string) error {
	allowed := map[string][]string{
		"ready":           {"claimed", "ready"},
		"creating":        {"ready", "creating"},
		"server_created":  {"claimed", "ready", "creating", "server_created"},
		"entity_recorded": {"claimed", "ready", "creating", "server_created", "entity_recorded"},
		"completed":       {"claimed", "ready", "creating", "server_created", "entity_recorded", "completed"},
		"payment_failed":  {"claimed"},
	}
	from, ok := allowed[state]
	if !ok {
		return errors.New("store: invalid provision state")
	}
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollOrders).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"provision.id": opID, "provision.leaseId": leaseID, "provision.state": bson.M{"$in": from}},
	}}, bson.M{"$set": bson.M{"provision.state": state, "updatedAt": time.Now()}})
	if err != nil {
		return err
	}
	if res.MatchedCount != 1 {
		return errors.New("store: provision lease lost or state already advanced")
	}
	return nil
}

func (Orders) RebaseProvisionExpiry(ctx context.Context, id bson.ObjectID, opID, leaseID string, expires time.Time, payload []byte) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollOrders).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id), bson.M{"provision.id": opID, "provision.leaseId": leaseID, "provision.state": bson.M{"$in": bson.A{"ready", "creating"}}},
	}}, bson.M{"$set": bson.M{"provision.expiresAt": expires, "provision.createPayload": payload, "updatedAt": time.Now()}})
	if err != nil {
		return err
	}
	if res.MatchedCount != 1 {
		return errors.New("store: provision lease lost while rebasing expiry")
	}
	return nil
}

func (Orders) ReleaseProvisionLease(ctx context.Context, id bson.ObjectID, opID, leaseID string) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	_, err := Collection(models.CollOrders).UpdateOne(ctx, bson.M{"$and": bson.A{docIDFilter(id), bson.M{"provision.id": opID, "provision.leaseId": leaseID}}}, bson.M{"$unset": bson.M{"provision.leaseId": "", "provision.leaseUntil": ""}, "$set": bson.M{"updatedAt": time.Now()}})
	return err
}

// CompleteProvision records payment and confirmation in one order update.
func (Orders) CompleteProvision(ctx context.Context, id bson.ObjectID, opID, leaseID string, allocationID int) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollOrders).UpdateOne(ctx, bson.M{"$and": bson.A{docIDFilter(id), bson.M{"provision.id": opID, "provision.leaseId": leaseID, "provision.state": bson.M{"$in": bson.A{"claimed", "ready", "creating", "server_created", "entity_recorded", "completed"}}}}}, bson.M{"$set": bson.M{
		"allocationId": allocationID, "paid": true, "confirmed": true, "provision.state": "completed", "updatedAt": time.Now(),
	}})
	if err != nil {
		return err
	}
	if res.MatchedCount != 1 {
		return errors.New("store: provision lease lost before completion")
	}
	return nil
}

func (Orders) PendingProvisions(ctx context.Context) ([]models.Order, error) {
	return findMany[models.Order](ctx, models.CollOrders, bson.M{"provision.state": bson.M{"$in": bson.A{"claimed", "ready", "creating", "server_created", "entity_recorded"}}})
}

func (Orders) PendingProvisionKeyCleanup(ctx context.Context) ([]models.Order, error) {
	return findMany[models.Order](ctx, models.CollOrders, bson.M{"provision.state": "completed", "provision.paymentMethod": "key", "provision.keyConsumed": bson.M{"$ne": true}}, sortAsc("updatedAt"), limitDocs(100))
}

func (Orders) MarkProvisionKeyConsumed(ctx context.Context, id bson.ObjectID, opID string) error {
	_, err := updateOne(ctx, models.CollOrders, bson.M{"$and": bson.A{docIDFilter(id), bson.M{"provision.id": opID, "provision.state": "completed", "provision.paymentMethod": "key"}}}, bson.M{"provision.keyConsumed": true})
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
	return findOne[models.Message](ctx, models.CollMessages, docIDFilter(id))
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
	_, err := updateOne(ctx, models.CollMessages, docIDFilter(id), bson.M{"haveRead": true})
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
	_, err := deleteOne(ctx, models.CollMessages, docIDFilter(id))
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
