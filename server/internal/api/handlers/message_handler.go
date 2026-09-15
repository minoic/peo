package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// MessageHandler serves the in-site mail box.
type MessageHandler struct{}

// NewMessageHandler builds the handler.
func NewMessageHandler() *MessageHandler { return &MessageHandler{} }

// List returns the inbox, newest first.
//
// GET /api/v1/messages
func (h *MessageHandler) List(c *gin.Context) {
	msgs, err := service.Messages.List(c.Request.Context(), middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.MessageListResponse{Messages: messageItems(msgs)})
}

// Unread returns the unread counter for the navbar badge.
//
// GET /api/v1/messages/unread
func (h *MessageHandler) Unread(c *gin.Context) {
	n, err := service.Messages.Unread(c.Request.Context(), middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.UnreadResponse{Unread: n})
}

// Read marks one message as opened.
//
// POST /api/v1/messages/:id/read
func (h *MessageHandler) Read(c *gin.Context) {
	messageID, valid := idParam(c, "id", "message")
	if !valid {
		return
	}
	if err := service.Messages.Read(c.Request.Context(), messageID, middleware.UserID(c)); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("message marked as read"))
}

// ReadAll marks the whole inbox as opened.
//
// POST /api/v1/messages/read-all
func (h *MessageHandler) ReadAll(c *gin.Context) {
	if err := service.Messages.ReadAll(c.Request.Context(), middleware.UserID(c)); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("every message marked as read"))
}

// Delete removes one message.
//
// DELETE /api/v1/messages/:id
func (h *MessageHandler) Delete(c *gin.Context) {
	messageID, valid := idParam(c, "id", "message")
	if !valid {
		return
	}
	if err := service.Messages.Delete(c.Request.Context(), messageID, middleware.UserID(c)); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("message deleted"))
}

// messageItems converts the stored documents into the wire shape, which carries
// a string id and the pre-formatted timestamp the client shows verbatim.
func messageItems(msgs []models.Message) []dto.MessageItem {
	out := make([]dto.MessageItem, 0, len(msgs))
	for i := range msgs {
		m := &msgs[i]
		out = append(out, dto.MessageItem{
			ID:         m.ID.Hex(),
			SenderName: m.SenderName,
			Text:       m.Text,
			TimeText:   m.TimeText,
			HaveRead:   m.HaveRead,
			CreatedAt:  m.CreatedAt.Format("2006-01-02 15:04"),
		})
	}
	return out
}
