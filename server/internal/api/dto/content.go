package dto

import (
	"github.com/minoic/peo/server/internal/service"
)

// GalleryListResponse is the public gallery.
type GalleryListResponse struct {
	Items []service.GalleryItem `json:"items"`
}

// GallerySubmitRequest posts a new album entry for review.
type GallerySubmitRequest struct {
	ItemName        string `json:"itemName" binding:"required"`
	ItemDescription string `json:"itemDescription"`
	ImgSource       string `json:"imgSource" binding:"required"`
}

// GalleryItemResponse is one gallery entry; the like endpoint returns it with
// the fresh count so the client does not need a second round trip.
type GalleryItemResponse struct {
	Item *service.GalleryItem `json:"item"`
}

// LikeResponse reports the new number of likes.
type LikeResponse struct {
	Likes uint `json:"likes"`
}

// MessageListResponse is the inbox.
type MessageListResponse struct {
	Messages []MessageItem `json:"messages"`
}

// MessageItem is a message with a stable string id and timestamps.
type MessageItem struct {
	ID         string `json:"id"`
	SenderName string `json:"senderName"`
	Text       string `json:"text"`
	TimeText   string `json:"timeText"`
	HaveRead   bool   `json:"haveRead"`
	CreatedAt  string `json:"createdAt"`
}

// UnreadResponse is the unread counter polled by the navbar badge.
type UnreadResponse struct {
	Unread int64 `json:"unread"`
}

// WorkOrderListResponse is the customer's ticket list. The item shape is shared
// with the admin console, so it comes from the service rather than being
// duplicated in the transport layer.
type WorkOrderListResponse struct {
	Orders []service.WorkOrderItem `json:"orders"`
}

// CreateWorkOrderRequest opens a ticket.
type CreateWorkOrderRequest struct {
	Title string `json:"title" binding:"required"`
	Text  string `json:"text" binding:"required"`
}

// WorkOrderResponse is a single ticket.
type WorkOrderResponse struct {
	Order service.WorkOrderItem `json:"order"`
}
