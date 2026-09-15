package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/service"
)

// GalleryHandler serves the screenshot album.
type GalleryHandler struct{}

// NewGalleryHandler builds the handler.
func NewGalleryHandler() *GalleryHandler { return &GalleryHandler{} }

// List returns the approved album items. The album can be switched off in the
// settings, but the route stays registered either way: the flag is published by
// /site/config (`AlbumEnabled`) and the Flutter shell is what hides the pages.
// Refusing the request here would turn a presentation switch into an API error,
// so no check is made.
//
// GET /api/v1/gallery
func (h *GalleryHandler) List(c *gin.Context) {
	items, err := service.Gallery.List(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if items == nil {
		items = []service.GalleryItem{}
	}
	ok(c, dto.GalleryListResponse{Items: items})
}

// MyItems returns the caller's submissions, including the pending ones.
//
// GET /api/v1/gallery/mine
func (h *GalleryHandler) MyItems(c *gin.Context) {
	items, err := service.Gallery.ListMine(c.Request.Context(), middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	if items == nil {
		items = []service.GalleryItem{}
	}
	ok(c, dto.GalleryListResponse{Items: items})
}

// Submit posts a new album item, which waits for review unless the author is an
// administrator.
//
// POST /api/v1/gallery
func (h *GalleryHandler) Submit(c *gin.Context) {
	var req dto.GallerySubmitRequest
	if !bind(c, &req) {
		return
	}
	item, err := service.Gallery.Submit(c.Request.Context(), middleware.UserID(c), middleware.IsAdmin(c),
		req.ItemName, req.ItemDescription, req.ImgSource)
	if err != nil {
		fail(c, err)
		return
	}
	created(c, dto.GalleryItemResponse{Item: &service.GalleryItem{
		ID:              item.ID.Hex(),
		ItemName:        item.ItemName,
		ItemDescription: item.ItemDescription,
		ImgSource:       item.ImgSource,
		Likes:           item.Likes,
		ReviewPassed:    item.ReviewPassed,
		CreatedAt:       item.CreatedAt.Format("2006-01-02 15:04"),
	}})
}

// Like adds one like to a published item and reports the new count.
//
// POST /api/v1/gallery/:id/like
func (h *GalleryHandler) Like(c *gin.Context) {
	itemID, valid := idParam(c, "id", "album item")
	if !valid {
		return
	}
	likes, err := service.Gallery.Like(c.Request.Context(), itemID)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.LikeResponse{Likes: likes})
}

// Delete removes an album item owned by the caller.
//
// DELETE /api/v1/gallery/:id
func (h *GalleryHandler) Delete(c *gin.Context) {
	itemID, valid := idParam(c, "id", "album item")
	if !valid {
		return
	}
	err := service.Gallery.Delete(c.Request.Context(), itemID, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("album item deleted"))
}
