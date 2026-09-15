// Package cryptoo generates and expires the redeemable codes of the shop.
package cryptoo

import (
	"context"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service/random"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// KeyLength is the length of a generated activation code.
const KeyLength = 32

// GenerateWareKeys creates amount activation codes for a product, each valid
// for validityDays days. The codes are inserted in one batch, whereas the
// legacy implementation issued one INSERT per code.
func GenerateWareKeys(ctx context.Context, specID bson.ObjectID, amount, validityDays int) error {
	if amount <= 0 {
		return nil
	}
	exp := time.Now().AddDate(0, 0, validityDays)
	keys := make([]models.WareKey, 0, amount)
	for i := 0; i < amount; i++ {
		keys = append(keys, models.WareKey{
			SpecID:    specID,
			KeyString: random.Code(),
			Exp:       exp,
		})
	}
	return store.Key.CreateBatch(ctx, keys)
}

// GenerateRechargeKeys creates amount balance top-up codes of the same value,
// each valid for validityDays days.
func GenerateRechargeKeys(ctx context.Context, balance uint, amount, validityDays int) error {
	if amount <= 0 {
		return nil
	}
	exp := time.Now().AddDate(0, 0, validityDays)
	keys := make([]models.RechargeKey, 0, amount)
	for i := 0; i < amount; i++ {
		keys = append(keys, models.RechargeKey{
			KeyString: random.Code(),
			Balance:   balance,
			Exp:       exp,
		})
	}
	return store.RKey.CreateBatch(ctx, keys)
}

// DeleteOutdatedKeys removes expired activation and recharge codes.
//
// The legacy version of this function iterated the activation-code slice while
// deleting the recharge codes, so expired top-up codes were never removed and
// each expired activation code could be inspected twice. Both loops now use
// their own slice and the work happens in two range deletes.
func DeleteOutdatedKeys(ctx context.Context) {
	now := time.Now()
	if n, err := store.Key.DeleteExpired(ctx, now); err != nil {
		glgf.Error("cannot delete expired ware keys: ", err)
	} else if n > 0 {
		glgf.Info("deleted ", n, " expired ware keys")
	}
	if n, err := store.RKey.DeleteExpired(ctx, now); err != nil {
		glgf.Error("cannot delete expired recharge keys: ", err)
	} else if n > 0 {
		glgf.Info("deleted ", n, " expired recharge keys")
	}
}
