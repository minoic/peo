package service

import (
	"context"

	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// MessageService is the read side of the internal mail box.
type MessageService struct{}

// Messages is the default MessageService.
var Messages = MessageService{}

// List returns the inbox of a user, newest first.
func (MessageService) List(ctx context.Context, userID bson.ObjectID) ([]models.Message, error) {
	msgs, err := store.Message.ByUser(ctx, userID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the messages", err)
	}
	return msgs, nil
}

// Unread counts the messages a user has not opened, which the navbar badge and
// the storefront depend on.
func (MessageService) Unread(ctx context.Context, userID bson.ObjectID) (int64, error) {
	n, err := store.Message.UnreadCount(ctx, userID)
	if err != nil {
		return 0, apierr.Wrap(apierr.CodeInternal, "cannot count the messages", err)
	}
	return n, nil
}

// Read marks one message as opened. A message that belongs to somebody else is
// reported as missing rather than forbidden, so the endpoint cannot be used to
// probe which ids exist.
func (MessageService) Read(ctx context.Context, messageID, userID bson.ObjectID) error {
	m, err := store.Message.ByID(ctx, messageID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "message not found", err)
	}
	if m.ReceiverID != userID {
		if isAdmin, _ := store.User.ByID(ctx, userID); isAdmin == nil || !isAdmin.IsAdmin {
			return apierr.Fail(apierr.CodeNotFound, "message not found")
		}
	}
	if err := store.Message.MarkRead(ctx, messageID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot mark the message as read", err)
	}
	return nil
}

// ReadAll marks every message of a user as opened.
func (MessageService) ReadAll(ctx context.Context, userID bson.ObjectID) error {
	if err := store.Message.MarkAllRead(ctx, userID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot mark the messages as read", err)
	}
	return nil
}

// Delete removes one message from a user's inbox. Messages are addressed to a
// single receiver, so the ownership check is the whole authorisation story.
func (MessageService) Delete(ctx context.Context, messageID, userID bson.ObjectID) error {
	m, err := store.Message.ByID(ctx, messageID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "message not found", err)
	}
	if m.ReceiverID != userID {
		return apierr.Fail(apierr.CodeNotFound, "message not found")
	}
	if err := store.Message.Delete(ctx, messageID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot delete the message", err)
	}
	return nil
}
