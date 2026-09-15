// Package message writes the internal site mail shown in the user's inbox.
package message

import (
	"context"
	"strings"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// SenderAdmin is the display name every automated message is sent under.
const SenderAdmin = "ADMIN"

// timeLayout is the timestamp rendered into the message body. The client shows
// it verbatim, so it is formatted server side to keep the text identical across
// platforms.
const timeLayout = "2006-01-02 15:04:05"

// Send stores a message for one recipient.
func Send(ctx context.Context, senderName string, receiverID bson.ObjectID, text string) {
	m := &models.Message{
		SenderName: senderName,
		ReceiverID: receiverID,
		Text:       text,
		TimeText:   time.Now().Format(timeLayout),
	}
	if err := store.Message.Create(ctx, m); err != nil {
		// A message is a courtesy, never a reason to fail the operation that
		// triggered it.
		glgf.Errorf("message: cannot store message for %s: %v", receiverID.Hex(), err)
	}
}

// SendAdmin messages a single user on behalf of the site.
func SendAdmin(ctx context.Context, receiverID bson.ObjectID, text string) {
	Send(ctx, SenderAdmin, receiverID, text)
}

// SendToAdmins messages every administrator, which is how the background jobs
// report a problem to a human.
func SendToAdmins(ctx context.Context, text string) {
	admins, err := store.User.Admins(ctx)
	if err != nil {
		glgf.Errorf("message: cannot list administrators: %v", err)
		return
	}
	for _, a := range admins {
		Send(ctx, SenderAdmin, a.ID, text)
	}
}

// UnreadNum is the badge count shown next to the inbox.
func UnreadNum(ctx context.Context, receiverID bson.ObjectID) int64 {
	n, err := store.Message.UnreadCount(ctx, receiverID)
	if err != nil {
		glgf.Errorf("message: cannot count unread messages: %v", err)
		return 0
	}
	return n
}

// GetMessages returns a user's inbox, newest first.
func GetMessages(ctx context.Context, receiverID bson.ObjectID) []models.Message {
	ms, err := store.Message.ByUser(ctx, receiverID)
	if err != nil {
		glgf.Errorf("message: cannot load messages: %v", err)
		return nil
	}
	return ms
}

// ReadAll marks every message of a user as read.
func ReadAll(ctx context.Context, receiverID bson.ObjectID) {
	if err := store.Message.MarkAllRead(ctx, receiverID); err != nil {
		glgf.Errorf("message: cannot mark messages read: %v", err)
	}
}

// Compose joins fragments into one body. It replaces the legacy
// fmt.Sprint(slice) that wrapped notifications in square brackets.
func Compose(fragments ...string) string { return strings.Join(fragments, "") }

// SiteName is the display name used when the site speaks in its own voice.
func SiteName() string { return config.String("WebApplicationName") }
