package service

import (
	"context"
	"strings"

	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// GalleryService owns the screenshot album: submission, moderation and the
// public listing.
type GalleryService struct{}

// Gallery is the default GalleryService.
var Gallery = GalleryService{}

// GalleryItem is one album entry as exposed by the API, with the poster's name
// resolved so the client does not need a second request per card.
type GalleryItem struct {
	ID              string `json:"id"`
	ItemName        string `json:"itemName"`
	ItemDescription string `json:"itemDescription"`
	ImgSource       string `json:"imgSource"`
	Likes           uint   `json:"likes"`
	ReviewPassed    bool   `json:"reviewPassed"`
	UserName        string `json:"userName"`
	CreatedAt       string `json:"createdAt"`
}

// List returns the approved album items, newest first.
func (GalleryService) List(ctx context.Context) ([]GalleryItem, error) {
	items, err := store.Gallery.Approved(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read the album", err)
	}
	return Gallery.decorate(ctx, items), nil
}

// ListMine returns the items submitted by one user, including the ones still
// waiting for review, so the owner can see their pending submissions.
func (GalleryService) ListMine(ctx context.Context, userID bson.ObjectID) ([]GalleryItem, error) {
	items, err := store.Gallery.ByUser(ctx, userID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot read your album items", err)
	}
	return Gallery.decorate(ctx, items), nil
}

// Submit records a new album item. A submission from an administrator is
// published immediately, which keeps a single operator site usable.
func (GalleryService) Submit(ctx context.Context, userID bson.ObjectID, isAdmin bool, name, description, imgSource string) (*models.GalleryItem, error) {
	name = strings.TrimSpace(name)
	imgSource = strings.TrimSpace(imgSource)
	if name == "" {
		return nil, apierr.Fail(apierr.CodeValidationFailed, "an image name is required")
	}
	if imgSource == "" {
		return nil, apierr.Fail(apierr.CodeValidationFailed, "an image address is required")
	}
	item := &models.GalleryItem{
		UserID:          userID,
		ItemName:        name,
		ItemDescription: strings.TrimSpace(description),
		ImgSource:       imgSource,
		ReviewPassed:    isAdmin,
	}
	if err := store.Gallery.Create(ctx, item); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot save the album item", err)
	}
	return item, nil
}

// Like adds one like to a published item. Legacy only ever counted likes in the
// database without offering a way to add one; the counter and its index are
// atomic now so two visitors cannot overwrite each other.
func (GalleryService) Like(ctx context.Context, itemID bson.ObjectID) (uint, error) {
	item, err := store.Gallery.ByID(ctx, itemID)
	if err != nil {
		return 0, apierr.Wrap(apierr.CodeNotFound, "album item not found", err)
	}
	if !item.ReviewPassed {
		return 0, apierr.Fail(apierr.CodeNotFound, "album item not found")
	}
	if err := store.Gallery.IncrementLikes(ctx, itemID); err != nil {
		return 0, apierr.Wrap(apierr.CodeInternal, "cannot add the like", err)
	}
	return item.Likes + 1, nil
}

// Delete removes an album item. Only the owner or an administrator may do so.
func (GalleryService) Delete(ctx context.Context, itemID, userID bson.ObjectID, isAdmin bool) error {
	item, err := store.Gallery.ByID(ctx, itemID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "album item not found", err)
	}
	if item.UserID != userID && !isAdmin {
		return apierr.Fail(apierr.CodeForbidden, "can only delete your own album items")
	}
	if err := store.Gallery.Delete(ctx, itemID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot delete the album item", err)
	}
	return nil
}

// decorate resolves the poster name for every item in one pass, so a listing of
// twenty items costs one user query per distinct author rather than twenty.
func (GalleryService) decorate(ctx context.Context, items []models.GalleryItem) []GalleryItem {
	names := make(map[bson.ObjectID]string, len(items))
	out := make([]GalleryItem, 0, len(items))
	for i := range items {
		it := &items[i]
		name, ok := names[it.UserID]
		if !ok {
			if u, err := store.User.ByID(ctx, it.UserID); err == nil {
				name = u.Name
			}
			names[it.UserID] = name
		}
		out = append(out, GalleryItem{
			ID:              it.ID.Hex(),
			ItemName:        it.ItemName,
			ItemDescription: it.ItemDescription,
			ImgSource:       it.ImgSource,
			Likes:           it.Likes,
			ReviewPassed:    it.ReviewPassed,
			UserName:        name,
			CreatedAt:       it.CreatedAt.Format("2006-01-02 15:04"),
		})
	}
	return out
}
