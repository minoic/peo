package store

import (
	"context"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/models"
	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

// EnsureIndexes creates every index the application relies on. It is
// idempotent: MongoDB ignores CreateOne when an identical index already exists.
func EnsureIndexes(ctx context.Context) error {
	type spec struct {
		coll   string
		models []mongo.IndexModel
	}

	uniq := func(name string, keys ...string) mongo.IndexModel {
		doc := bson.D{}
		for _, k := range keys {
			doc = append(doc, bson.E{Key: k, Value: 1})
		}
		return mongo.IndexModel{Keys: doc, Options: options.Index().SetName(name).SetUnique(true)}
	}
	plain := func(name string, keys ...string) mongo.IndexModel {
		doc := bson.D{}
		for _, k := range keys {
			doc = append(doc, bson.E{Key: k, Value: 1})
		}
		return mongo.IndexModel{Keys: doc, Options: options.Index().SetName(name)}
	}

	specs := []spec{
		{models.CollUsers, []mongo.IndexModel{
			uniq("uniq_name", "name"),
			uniq("uniq_email", "email"),
			// Spec §5 requires uuid to be unique, as the legacy `gorm:"unique"`
			// tag did. Registration always mints one, so it need not be sparse.
			uniq("uniq_uuid", "uuid"),
			{Keys: bson.D{{Key: "bootstrapKey", Value: 1}}, Options: options.Index().SetName("uniq_bootstrap_key").SetUnique(true).SetSparse(true)},
		}},
		{models.CollWareSpecs, []mongo.IndexModel{
			plain("idx_ware_name", "wareName"),
		}},
		{models.CollWareEntities, []mongo.IndexModel{
			plain("idx_user", "userId"),
			plain("idx_delete_status", "deleteStatus"),
			// The cron sweeper scans for expired servers ordered by expiry.
			plain("idx_valid_date", "validDate"),
			uniq("uniq_server_ext_id", "serverExternalId"),
			{Keys: bson.D{{Key: "orderId", Value: 1}}, Options: options.Index().SetName("uniq_order_id").SetUnique(true).SetSparse(true)},
		}},
		{models.CollWareKeys, []mongo.IndexModel{
			uniq("uniq_key_string", "keyString"),
			plain("idx_spec", "specId"),
			plain("idx_exp", "exp"),
		}},
		{models.CollOrders, []mongo.IndexModel{
			plain("idx_user", "userId"),
			plain("idx_confirmed", "confirmed"),
			plain("idx_order_expiry", "closed", "paid", "createdAt"),
		}},
		{models.CollMessages, []mongo.IndexModel{
			plain("idx_receiver", "receiverId"),
			plain("idx_receiver_read", "receiverId", "haveRead"),
		}},
		{models.CollGalleryItems, []mongo.IndexModel{
			plain("idx_review_passed", "reviewPassed"),
			plain("idx_user", "userId"),
		}},
		{models.CollWorkOrders, []mongo.IndexModel{
			plain("idx_closed", "closed"),
			plain("idx_user", "userId"),
		}},
		{models.CollRechargeKeys, []mongo.IndexModel{
			uniq("uniq_key_string", "keyString"),
			plain("idx_exp", "exp"),
		}},
		{models.CollRechargeLogs, []mongo.IndexModel{
			plain("idx_user", "userId"),
			// Sparse so the many legacy rows without a trade number do not clash.
			{Keys: bson.D{{Key: "outTradeNo", Value: 1}}, Options: options.Index().SetName("uniq_out_trade_no").SetUnique(true).SetSparse(true)},
		}},
		{models.CollRegConfirmKeys, []mongo.IndexModel{
			uniq("uniq_key_string", "keyString"),
		}},
		{models.CollDeleteConfirms, []mongo.IndexModel{
			plain("idx_ware", "wareId"),
		}},
		{models.CollPterodactylPassword, []mongo.IndexModel{
			uniq("uniq_user", "userId"),
		}},
	}

	legacyDocIDIndex := mongo.IndexModel{
		Keys:    bson.D{{Key: "doc._id", Value: 1}},
		Options: options.Index().SetName("idx_legacy_doc_id").SetSparse(true),
	}
	for _, s := range specs {
		indexes := append(append([]mongo.IndexModel(nil), s.models...), legacyDocIDIndex)
		if _, err := Collection(s.coll).Indexes().CreateMany(ctx, indexes); err != nil {
			return err
		}
	}
	glgf.Info("mongo: indexes ensured")
	return nil
}
