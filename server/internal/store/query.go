package store

import (
	"context"
	"errors"
	"time"

	"go.mongodb.org/mongo-driver/v2/bson"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

// The helpers below are the only place in the codebase that talks to the
// driver directly; repositories wrap them with collection specific methods and
// keep the units of work (timestamps, ids, context deadlines) in one place.

var errNilDocument = errors.New("store: cannot insert a nil document")

type legacyDocNormalizer interface {
	NormalizeLegacyDoc()
}

func normalizeLegacyDoc(doc any) {
	if normalizer, ok := doc.(legacyDocNormalizer); ok {
		normalizer.NormalizeLegacyDoc()
	}
}

// docIDFilter matches both the flattened _id field used by current documents
// and the nested doc._id field used by records written by the old BSON shape.
func docIDFilter(id bson.ObjectID) bson.M {
	return bson.M{"$or": bson.A{
		bson.M{"_id": id},
		bson.M{"doc._id": id},
	}}
}

// stampable is satisfied by every model through its embedded models.Doc.
type stampable interface{ StampNow(created bool) }

// identifiable is satisfied by every model through its embedded models.Doc.
type identifiable interface{ EnsureID() bson.ObjectID }

func withTimeout(ctx context.Context) (context.Context, context.CancelFunc) {
	if _, ok := ctx.Deadline(); ok {
		return ctx, func() {}
	}
	return context.WithTimeout(ctx, DefaultTimeout)
}

// prepare stamps ids and timestamps, returning the model as an any so the
// driver stores field names from the bson tags (passing a pointer is fine).
func prepare(doc any) (any, error) {
	if doc == nil {
		return nil, errNilDocument
	}
	if s, ok := doc.(stampable); ok {
		s.StampNow(true)
	}
	if i, ok := doc.(identifiable); ok {
		i.EnsureID()
	}
	return doc, nil
}

func insertOne(ctx context.Context, coll string, doc any) (bson.ObjectID, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	d, err := prepare(doc)
	if err != nil {
		return bson.NilObjectID, err
	}
	if _, err := Collection(coll).InsertOne(ctx, d); err != nil {
		return bson.NilObjectID, err
	}
	if i, ok := doc.(identifiable); ok {
		return i.EnsureID(), nil
	}
	return bson.NilObjectID, nil
}

func insertMany(ctx context.Context, coll string, docs []any) error {
	if len(docs) == 0 {
		return nil
	}
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	for i := range docs {
		d, err := prepare(docs[i])
		if err != nil {
			return err
		}
		docs[i] = d
	}
	_, err := Collection(coll).InsertMany(ctx, docs)
	return err
}

func findMany[T any](ctx context.Context, coll string, filter any,
	opts ...options.Lister[options.FindOptions]) ([]T, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	cur, err := Collection(coll).Find(ctx, filter, opts...)
	if err != nil {
		return nil, err
	}
	defer func() { _ = cur.Close(context.Background()) }()
	out := make([]T, 0)
	if err := cur.All(ctx, &out); err != nil {
		return nil, err
	}
	for i := range out {
		normalizeLegacyDoc(&out[i])
	}
	return out, nil
}

func findOne[T any](ctx context.Context, coll string, filter any,
	opts ...options.Lister[options.FindOneOptions]) (*T, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	var out T
	if err := Collection(coll).FindOne(ctx, filter, opts...).Decode(&out); err != nil {
		return nil, err
	}
	normalizeLegacyDoc(&out)
	return &out, nil
}

// exists reports whether a document matches the filter. Projecting _id only
// avoids transferring whole documents for a boolean answer.
func exists(ctx context.Context, coll string, filter any) (bool, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	err := Collection(coll).
		FindOne(ctx, filter, options.FindOne().SetProjection(bson.M{"_id": 1})).
		Err()
	if errors.Is(err, mongo.ErrNoDocuments) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return true, nil
}

// setUpdate normalises a bson.M of fields into an $set update with updatedAt
// applied. Field maps (rather than model values) keep the intent auditable and
// prevent accidental whole-document overwrites.
func setUpdate(fields bson.M) bson.M {
	out := bson.M{}
	for k, v := range fields {
		out[k] = v
	}
	if _, ok := out["updatedAt"]; !ok {
		out["updatedAt"] = time.Now()
	}
	return bson.M{"$set": out}
}

func updateOne(ctx context.Context, coll string, filter any, fields bson.M) (int64, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(coll).UpdateOne(ctx, filter, setUpdate(fields))
	if err != nil {
		return 0, err
	}
	return res.MatchedCount, nil
}

func updateMany(ctx context.Context, coll string, filter any, fields bson.M) (int64, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(coll).UpdateMany(ctx, filter, setUpdate(fields))
	if err != nil {
		return 0, err
	}
	return res.MatchedCount, nil
}

// updateOneRaw is the escape hatch for operators other than $set ($inc, $push).
func updateOneRaw(ctx context.Context, coll string, filter any, update any) (int64, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(coll).UpdateOne(ctx, filter, update)
	if err != nil {
		return 0, err
	}
	return res.MatchedCount, nil
}

// incUpdate builds an $inc update, used for balances and like counters.
func incUpdate(fields bson.M) bson.M {
	return bson.M{"$inc": fields, "$set": bson.M{"updatedAt": time.Now()}}
}

func deleteOne(ctx context.Context, coll string, filter any) (int64, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(coll).DeleteOne(ctx, filter)
	if err != nil {
		return 0, err
	}
	return res.DeletedCount, nil
}

func deleteMany(ctx context.Context, coll string, filter any) (int64, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	res, err := Collection(coll).DeleteMany(ctx, filter)
	if err != nil {
		return 0, err
	}
	return res.DeletedCount, nil
}

func count(ctx context.Context, coll string, filter any) (int64, error) {
	ctx, cancel := withTimeout(ctx)
	defer cancel()
	return Collection(coll).CountDocuments(ctx, filter)
}

func sortAsc(field string) options.Lister[options.FindOptions] {
	return options.Find().SetSort(bson.D{{Key: field, Value: 1}})
}

func sortDesc(field string) options.Lister[options.FindOptions] {
	return options.Find().SetSort(bson.D{{Key: field, Value: -1}})
}

func limitDocs(n int64) options.Lister[options.FindOptions] {
	return options.Find().SetLimit(n)
}

// IsNotFound is the rewrite of GORM's RecordNotFound().
func IsNotFound(err error) bool { return errors.Is(err, mongo.ErrNoDocuments) }
