package email

import (
	"context"
	"errors"
	"time"

	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/random"
	"github.com/minoic/peo/server/internal/store"
)

// confirmKeyTTL is how long a registration confirmation link stays valid.
const confirmKeyTTL = 30 * time.Minute

// ErrExpiredKey marks a token that exists but is past its validity window, so
// the caller can delete it instead of leaving it in the database forever.
var ErrExpiredKey = errors.New("email: confirmation link has expired")

// IssueRegistrationKey creates a confirmation token for a freshly registered
// account and mails the link to it.
//
// Two legacy defects are fixed here:
//
//   - ConfirmKey looked the user up with the confirmation key's own primary key
//     instead of its UserID, so the lookup only matched by coincidence and the
//     e-mail was effectively never confirmed via the link.
//   - the key was created before the mail was sent and the send error was
//     discarded, leaving orphan tokens behind. A failed send now deletes the
//     token it just created.
func IssueRegistrationKey(ctx context.Context, u *models.User) error {
	if u.EmailConfirmed {
		return nil
	}
	keyString, err := random.String(15)
	if err != nil {
		return err
	}
	key := &models.RegConfirmKey{
		KeyString: keyString,
		UserName:  u.Name,
		UserID:    u.ID,
		UserEmail: u.Email,
		ValidTime: time.Now().Add(confirmKeyTTL),
	}
	if err := store.RegConfirm.Create(ctx, key); err != nil {
		return err
	}
	if err := SendConfirmRegister(u.Email, u.Name, key.KeyString); err != nil {
		// The token is useless if the user never received the link.
		_ = store.RegConfirm.Delete(ctx, key.ID)
		return err
	}
	return nil
}

// ConfirmKey resolves a registration confirmation token. It returns
// store.ErrNotFound for an unknown token and ErrExpiredKey for one that has
// aged out, so the caller can delete the stale token instead of leaving it in
// the database forever.
func ConfirmKey(ctx context.Context, key string) (*models.RegConfirmKey, error) {
	info, err := store.RegConfirm.ByString(ctx, key)
	if err != nil {
		return nil, err
	}
	if time.Now().After(info.ValidTime) {
		return info, ErrExpiredKey
	}
	return info, nil
}
