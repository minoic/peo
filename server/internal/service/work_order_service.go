package service

import (
	"context"
	"strings"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/service/email"
	"github.com/minoic/peo/server/internal/service/message"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

const (
	// workOrderCooldown throttles ticket creation, matching the legacy limit of
	// one ticket per user per ten seconds.
	workOrderCooldown = 10 * time.Second
	// workOrderNotifyTimeout bounds the background fan-out to the staff.
	workOrderNotifyTimeout = 30 * time.Second
)

// WorkOrderService owns the support tickets.
type WorkOrderService struct{}

// WorkOrders is the default WorkOrderService.
var WorkOrders = WorkOrderService{}

// Create opens a ticket and notifies every administrator. The notification runs
// in the background: a slow SMTP server must not make the customer wait, and it
// must not fail their submission either.
//
// The user record is resolved here rather than by the caller: the handler layer
// is not allowed to reach into `store` (layer rule 1), and the ticket needs more
// than the id -- the username keys the rate limiter and the staff notification.
func (WorkOrderService) Create(ctx context.Context, userID models.ObjectID, title, text string) (*models.WorkOrder, error) {
	user, err := store.User.ByID(ctx, userID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	title = strings.TrimSpace(title)
	text = strings.TrimSpace(text)
	if title == "" {
		return nil, apierr.Fail(apierr.CodeValidationFailed, "a subject is required")
	}
	if text == "" {
		return nil, apierr.Fail(apierr.CodeValidationFailed, "a message body is required")
	}
	limitKey := "WORKORDER" + user.Name
	if redis.Limited(ctx, limitKey) {
		return nil, apierr.Fail(apierr.CodeRateLimited, "please do not open tickets so often")
	}
	order := &models.WorkOrder{
		UserID:     user.ID,
		UserName:   user.Name,
		OrderTitle: title,
		OrderText:  text,
	}
	if err := store.WorkOrder.Create(ctx, order); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot create the work order", err)
	}
	redis.Limit(ctx, limitKey, workOrderCooldown)

	customer := user
	go notifyAdminsOfWorkOrder(order, customer)
	return order, nil
}

// ListMine returns the tickets of a user, newest first.
func (WorkOrderService) ListMine(ctx context.Context, userID bson.ObjectID) ([]models.WorkOrder, error) {
	orders, err := store.WorkOrder.ByUser(ctx, userID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read your work orders", err)
	}
	return orders, nil
}

// ListOpen returns the unresolved tickets, oldest first, for the admin console.
func (WorkOrderService) ListOpen(ctx context.Context) ([]models.WorkOrder, error) {
	orders, err := store.WorkOrder.Open(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the work orders", err)
	}
	return orders, nil
}

// Close resolves a ticket and tells its owner. A ticket that is already closed
// is left alone so the customer is not mailed twice.
func (WorkOrderService) Close(ctx context.Context, orderID bson.ObjectID) error {
	return WorkOrders.CloseWithInfo(ctx, orderID, "")
}

// CloseWithInfo resolves a ticket and forwards the operator's reply to the
// customer, which is what the back office uses. The reply is optional: an empty
// one produces the plain acknowledgement.
func (WorkOrderService) CloseWithInfo(ctx context.Context, orderID bson.ObjectID, closeInfo string) error {
	order, err := store.WorkOrder.ByID(ctx, orderID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "work order not found", err)
	}
	if order.Closed {
		return nil
	}
	if err := store.WorkOrder.Close(ctx, orderID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot close the work order", err)
	}
	notice := message.Compose("Your work order \"", order.OrderTitle, "\" has been handled. Thank you for your feedback.")
	if reply := strings.TrimSpace(closeInfo); reply != "" {
		notice = message.Compose(notice, " Resolution: ", reply)
	}
	message.SendAdmin(ctx, order.UserID, notice)
	if owner, err := store.User.ByID(ctx, order.UserID); err == nil {
		if err := email.SendAnyEmail(owner.Email, notice); err != nil {
			glgf.Error("workorder: cannot mail the ticket owner ", owner.Email, ": ", err)
		}
	}
	return nil
}

// notifyAdminsOfWorkOrder messages and mails every administrator. It runs on a
// context of its own, because the request that triggered it has already
// finished by the time the first mail is sent.
func notifyAdminsOfWorkOrder(order *models.WorkOrder, customer *models.User) {
	ctx, cancel := context.WithTimeout(context.Background(), workOrderNotifyTimeout)
	defer cancel()
	admins, err := store.User.Admins(ctx)
	if err != nil {
		glgf.Error("workorder: cannot list administrators: ", err)
		return
	}
	text := message.Compose(
		"User ", customer.Name, " opened a work order: \"", order.OrderTitle, "\": ", order.OrderText)
	for i := range admins {
		admin := &admins[i]
		message.Send(ctx, customer.Name, admin.ID, text)
		// The legacy code mailed the *customer* once per administrator; the
		// notification belongs in the staff inbox, so the administrator's own
		// address is used now.
		if err := email.SendAnyEmail(admin.Email, text); err != nil {
			glgf.Error("workorder: cannot mail administrator ", admin.Email, ": ", err)
		}
	}
}
