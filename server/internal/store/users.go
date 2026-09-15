package store

import (
	"context"
	"time"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

// Users is the repository for the users collection.
type Users struct{}

// User is the default Users repository.
var User = Users{}

// Create inserts a new user, stamping the id and timestamps onto u.
func (Users) Create(ctx context.Context, u *models.User) error {
	_, err := insertOne(ctx, models.CollUsers, u)
	return err
}

// ByID looks a user up by primary key.
func (Users) ByID(ctx context.Context, id bson.ObjectID) (*models.User, error) {
	return findOne[models.User](ctx, models.CollUsers, bson.M{"_id": id})
}

// ByName looks a user up by the unique login name.
func (Users) ByName(ctx context.Context, name string) (*models.User, error) {
	return findOne[models.User](ctx, models.CollUsers, bson.M{"name": name})
}

// ByEmail looks a user up by the unique e-mail address.
func (Users) ByEmail(ctx context.Context, email string) (*models.User, error) {
	return findOne[models.User](ctx, models.CollUsers, bson.M{"email": email})
}

// ByNameOrEmail supports a single login field.
func (Users) ByNameOrEmail(ctx context.Context, login string) (*models.User, error) {
	return findOne[models.User](ctx, models.CollUsers,
		bson.M{"$or": bson.A{bson.M{"name": login}, bson.M{"email": login}}})
}

// NameTaken reports whether a name is already registered.
func (Users) NameTaken(ctx context.Context, name string) (bool, error) {
	return exists(ctx, models.CollUsers, bson.M{"name": name})
}

// EmailTaken reports whether an address is already registered.
func (Users) EmailTaken(ctx context.Context, email string) (bool, error) {
	return exists(ctx, models.CollUsers, bson.M{"email": email})
}

// All returns every user, newest first.
func (Users) All(ctx context.Context) ([]models.User, error) {
	return findMany[models.User](ctx, models.CollUsers, bson.M{}, sortDesc("createdAt"))
}

// Admins returns every administrator, used by the background jobs to report a
// problem to someone who can act on it.
func (Users) Admins(ctx context.Context) ([]models.User, error) {
	return findMany[models.User](ctx, models.CollUsers, bson.M{"isAdmin": true}, sortAsc("createdAt"))
}

// Count returns the document count; the first registered user becomes admin.
func (Users) Count(ctx context.Context) (int64, error) {
	return count(ctx, models.CollUsers, bson.M{})
}

// SetPassword replaces the stored password hash.
func (Users) SetPassword(ctx context.Context, id bson.ObjectID, hash string) error {
	_, err := updateOne(ctx, models.CollUsers, bson.M{"_id": id}, bson.M{"password": hash})
	return err
}

// SetEmail replaces the address and clears confirmation.
func (Users) SetEmail(ctx context.Context, id bson.ObjectID, email string, confirmed bool) error {
	_, err := updateOne(ctx, models.CollUsers, bson.M{"_id": id}, bson.M{
		"email":          email,
		"emailConfirmed": confirmed,
	})
	return err
}

// ConfirmEmail marks the address as verified.
func (Users) ConfirmEmail(ctx context.Context, id bson.ObjectID) error {
	_, err := updateOne(ctx, models.CollUsers, bson.M{"_id": id}, bson.M{"emailConfirmed": true})
	return err
}

// AddBalance applies a signed delta to the balance. The legacy code only ever
// added, but a negative delta is allowed for refunds.
func (Users) AddBalance(ctx context.Context, id bson.ObjectID, delta int64) error {
	_, err := updateOneRaw(ctx, models.CollUsers, bson.M{"_id": id}, incUpdate(bson.M{"balance": delta}))
	return err
}

// MarkPteCreated records that the Pterodactyl account mirror was created.
func (Users) MarkPteCreated(ctx context.Context, id bson.ObjectID, created bool) error {
	_, err := updateOne(ctx, models.CollUsers, bson.M{"_id": id}, bson.M{"pteUserCreated": created})
	return err
}

// AddUpTime accumulates the online duration tracked by the cron job.
func (Users) AddUpTime(ctx context.Context, id bson.ObjectID, d time.Duration) error {
	_, err := updateOneRaw(ctx, models.CollUsers, bson.M{"_id": id}, incUpdate(bson.M{"totalUpTime": int64(d)}))
	return err
}

// SetUUID stores the generated per-user UUID.
func (Users) SetUUID(ctx context.Context, id bson.ObjectID, uuid string) error {
	_, err := updateOne(ctx, models.CollUsers, bson.M{"_id": id}, bson.M{"uuid": uuid})
	return err
}

// PterodactylPasswords is the repository for cached panel passwords.
type PterodactylPasswords struct{}

// PtePassword is the default PterodactylPasswords repository.
var PtePassword = PterodactylPasswords{}

// Upsert stores (or replaces) the panel password of a user.
func (PterodactylPasswords) Upsert(ctx context.Context, userID bson.ObjectID, pw string) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	update := bson.M{
		"$set": bson.M{"password": pw, "updatedAt": time.Now()},
		"$setOnInsert": bson.M{
			"_id":       models.NewID(),
			"userId":    userID,
			"createdAt": time.Now(),
		},
	}
	_, err := Collection(models.CollPterodactylPassword).UpdateOne(
		ctx, bson.M{"userId": userID}, update, options.UpdateOne().SetUpsert(true))
	return err
}

// ByUser returns the cached password, or ErrNotFound.
func (PterodactylPasswords) ByUser(ctx context.Context, userID bson.ObjectID) (*models.PterodactylPassword, error) {
	return findOne[models.PterodactylPassword](ctx, models.CollPterodactylPassword, bson.M{"userId": userID})
}
