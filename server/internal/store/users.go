package store

import (
	"context"
	"errors"
	"math"
	"time"

	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

var ErrInsufficientBalance = errors.New("store: insufficient balance")
var ErrBalanceOperationCanceled = errors.New("store: balance operation was canceled")
var ErrBalanceOperationCapacity = errors.New("store: balance operation receipt capacity reached")

const maxBalanceOperationReceipts = 10000

func hasBalanceReceiptCapacity() bson.M {
	return bson.M{"$expr": bson.M{"$lt": bson.A{
		bson.M{"$size": bson.M{"$ifNull": bson.A{"$balanceOperations", bson.A{}}}},
		maxBalanceOperationReceipts,
	}}}
}

// Users is the repository for the users collection.
type Users struct{}

// User is the default Users repository.
var User = Users{}

// Create inserts a new user, stamping the id and timestamps onto u.
func (Users) Create(ctx context.Context, u *models.User) error {
	_, err := insertOne(ctx, models.CollUsers, u)
	return err
}

// CreateWithBootstrapAdmin atomically assigns the first-registration role.
// The unique sparse bootstrap key makes concurrent empty-database registrations
// elect one administrator in the same insert that creates the account.
func (Users) CreateWithBootstrapAdmin(ctx context.Context, u *models.User, eligible bool) (bool, error) {
	if !eligible {
		return false, User.Create(ctx, u)
	}
	u.IsAdmin = true
	u.BootstrapKey = "initial-admin"
	if err := User.Create(ctx, u); err == nil {
		return true, nil
	} else {
		var winner struct {
			ID bson.ObjectID `bson:"_id"`
		}
		lookupErr := Collection(models.CollUsers).FindOne(ctx, bson.M{"bootstrapKey": "initial-admin"}).Decode(&winner)
		if lookupErr != nil {
			return false, err
		}
		// A bootstrap-key collision means another registration won. Retry as an
		// ordinary user so name/email uniqueness errors retain their normal path.
		u.IsAdmin = false
		u.BootstrapKey = ""
		return false, User.Create(ctx, u)
	}
}

// ByID looks a user up by primary key.
func (Users) ByID(ctx context.Context, id bson.ObjectID) (*models.User, error) {
	return findOne[models.User](ctx, models.CollUsers, docIDFilter(id))
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

// ClaimFirstAdmin assigns the one-time administrator bootstrap claim to the
// first registration that wins. Existing users are never promoted by a count
// check, and competing registrations cannot both win this unique document ID.
func (Users) ClaimFirstAdmin(ctx context.Context, id bson.ObjectID) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	_, err := Collection(models.CollAppSettings).InsertOne(ctx, bson.M{
		"_id": "first_admin_bootstrap", "userId": id, "status": "pending", "createdAt": time.Now(),
	})
	if mongo.IsDuplicateKeyError(err) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	result, err := Collection(models.CollUsers).UpdateOne(ctx, docIDFilter(id), bson.M{
		"$set": bson.M{"isAdmin": true, "updatedAt": time.Now()},
	})
	if err != nil || result.MatchedCount != 1 {
		return false, err
	}
	_, err = Collection(models.CollAppSettings).UpdateOne(ctx,
		bson.M{"_id": "first_admin_bootstrap", "userId": id, "status": "pending"},
		bson.M{"$set": bson.M{"status": "complete", "updatedAt": time.Now()}},
	)
	if err != nil {
		return false, err
	}
	return true, nil
}

// EnsureBootstrapAdmin completes a bootstrap claim if a process stopped after
// recording the winning user but before promoting it.
func EnsureBootstrapAdmin(ctx context.Context) error {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	var marker struct {
		UserID bson.ObjectID `bson:"userId"`
		Status string        `bson:"status"`
	}
	err := Collection(models.CollAppSettings).FindOne(ctx, bson.M{"_id": "first_admin_bootstrap"}).Decode(&marker)
	if err != nil {
		if errors.Is(err, mongo.ErrNoDocuments) {
			return nil
		}
		return err
	}
	if marker.Status == "complete" {
		return nil
	}
	result, err := Collection(models.CollUsers).UpdateOne(ctx, docIDFilter(marker.UserID), bson.M{
		"$set": bson.M{"isAdmin": true, "updatedAt": time.Now()},
	})
	if err != nil {
		return err
	}
	if result.MatchedCount != 1 {
		return nil
	}
	_, err = Collection(models.CollAppSettings).UpdateOne(ctx,
		bson.M{"_id": "first_admin_bootstrap", "userId": marker.UserID, "status": "pending"},
		bson.M{"$set": bson.M{"status": "complete", "updatedAt": time.Now()}},
	)
	return err
}

// SetPassword replaces the stored password hash.
func (Users) SetPassword(ctx context.Context, id bson.ObjectID, hash string) error {
	_, err := updateOne(ctx, models.CollUsers, docIDFilter(id), bson.M{"password": hash})
	return err
}

// SetEmail replaces the address and clears confirmation.
func (Users) SetEmail(ctx context.Context, id bson.ObjectID, email string, confirmed bool) error {
	_, err := updateOne(ctx, models.CollUsers, docIDFilter(id), bson.M{
		"email":          email,
		"emailConfirmed": confirmed,
	})
	return err
}

// ConfirmEmail marks the address as verified.
func (Users) ConfirmEmail(ctx context.Context, id bson.ObjectID) error {
	_, err := updateOne(ctx, models.CollUsers, docIDFilter(id), bson.M{"emailConfirmed": true})
	return err
}

// AddBalance applies a signed delta to the balance. The legacy code only ever
// added, but a negative delta is allowed for refunds.
func (Users) AddBalance(ctx context.Context, id bson.ObjectID, delta int64) error {
	_, err := updateOneRaw(ctx, models.CollUsers, docIDFilter(id), incUpdate(bson.M{"balance": delta}))
	return err
}

// ApplyBalanceOnce atomically changes the balance and records an operation ID
// in the same user document. The ID remains until the caller has durably
// recorded completion, allowing retries after a process or network failure.
func (Users) ApplyBalanceOnce(ctx context.Context, id bson.ObjectID, operationID string, delta int64) (bool, error) {
	if operationID == "" || delta == math.MinInt64 {
		return false, errors.New("store: invalid balance operation")
	}
	if delta == 0 {
		return false, nil
	}
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	conditions := bson.M{
		"balanceOperations": bson.M{"$nin": bson.A{operationID, "cancel:" + operationID}},
		"$expr":             hasBalanceReceiptCapacity()["$expr"],
	}
	if delta < 0 {
		conditions["balance"] = bson.M{"$gte": uint64(-delta)}
	}
	filter := bson.M{"$and": bson.A{docIDFilter(id), conditions}}
	res, err := Collection(models.CollUsers).UpdateOne(ctx, filter, bson.M{
		"$inc":      bson.M{"balance": delta},
		"$addToSet": bson.M{"balanceOperations": operationID},
		"$set":      bson.M{"updatedAt": time.Now()},
	})
	if err != nil {
		return false, err
	}
	if res.MatchedCount == 1 {
		return true, nil
	}
	var state struct {
		Balance    uint     `bson:"balance"`
		Operations []string `bson:"balanceOperations"`
	}
	if err := Collection(models.CollUsers).FindOne(ctx, docIDFilter(id), options.FindOne().SetProjection(bson.M{"balance": 1, "balanceOperations": 1})).Decode(&state); err != nil {
		return false, err
	}
	for _, prior := range state.Operations {
		if prior == operationID {
			return false, nil
		}
		if prior == "cancel:"+operationID {
			return false, ErrBalanceOperationCanceled
		}
	}
	if len(state.Operations) >= maxBalanceOperationReceipts {
		return false, ErrBalanceOperationCapacity
	}
	if delta < 0 && uint64(state.Balance) < uint64(-delta) {
		return false, ErrInsufficientBalance
	}
	return false, errors.New("store: balance operation was not applied")
}

// CancelBalanceOperation permanently fences an unpaid operation in the same
// user document. A stale worker cannot charge it after a later balance credit.
func (Users) CancelBalanceOperation(ctx context.Context, id bson.ObjectID, operationID string, amount uint64) (canceled, applied bool, err error) {
	if operationID == "" || amount == 0 || amount > math.MaxInt64 {
		return false, false, errors.New("store: invalid balance cancellation")
	}
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollUsers).UpdateOne(ctx, bson.M{"$and": bson.A{
		docIDFilter(id),
		bson.M{"balance": bson.M{"$lt": amount}, "balanceOperations": bson.M{"$nin": bson.A{operationID, "cancel:" + operationID}}, "$expr": hasBalanceReceiptCapacity()["$expr"]},
	}}, bson.M{
		"$addToSet": bson.M{"balanceOperations": "cancel:" + operationID},
		"$set":      bson.M{"updatedAt": time.Now()},
	})
	if err != nil {
		return false, false, err
	}
	if res.MatchedCount == 1 {
		return true, false, nil
	}
	var state struct {
		Operations []string `bson:"balanceOperations"`
	}
	if err := Collection(models.CollUsers).FindOne(ctx, docIDFilter(id), options.FindOne().SetProjection(bson.M{"balanceOperations": 1})).Decode(&state); err != nil {
		return false, false, err
	}
	for _, marker := range state.Operations {
		switch marker {
		case operationID:
			return false, true, nil
		case "cancel:" + operationID:
			return true, false, nil
		}
	}
	if len(state.Operations) >= maxBalanceOperationReceipts {
		return false, false, ErrBalanceOperationCapacity
	}
	return false, false, nil
}

// DebitBalance atomically charges a user only when the balance covers amount.
func (Users) DebitBalance(ctx context.Context, id bson.ObjectID, amount uint64) error {
	if amount == 0 {
		return nil
	}
	if amount > math.MaxInt64 {
		return errors.New("store: balance charge exceeds supported range")
	}
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(models.CollUsers).UpdateOne(ctx,
		bson.M{"$and": bson.A{docIDFilter(id), bson.M{"balance": bson.M{"$gte": amount}}}},
		bson.M{"$inc": bson.M{"balance": -int64(amount)}, "$set": bson.M{"updatedAt": time.Now()}},
	)
	if err != nil {
		return err
	}
	if res.MatchedCount == 1 {
		return nil
	}
	return ErrInsufficientBalance
}

// MarkPteCreated records that the Pterodactyl account mirror was created.
func (Users) MarkPteCreated(ctx context.Context, id bson.ObjectID, created bool) error {
	_, err := updateOne(ctx, models.CollUsers, docIDFilter(id), bson.M{"pteUserCreated": created})
	return err
}

// AddUpTime accumulates the online duration tracked by the cron job.
func (Users) AddUpTime(ctx context.Context, id bson.ObjectID, d time.Duration) error {
	_, err := updateOneRaw(ctx, models.CollUsers, docIDFilter(id), incUpdate(bson.M{"totalUpTime": int64(d)}))
	return err
}

// SetUUID stores the generated per-user UUID.
func (Users) SetUUID(ctx context.Context, id bson.ObjectID, uuid string) error {
	_, err := updateOne(ctx, models.CollUsers, docIDFilter(id), bson.M{"uuid": uuid})
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
