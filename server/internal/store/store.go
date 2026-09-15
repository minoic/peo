// Package store owns the MongoDB connection and provides typed repositories
// for every collection.
//
// The connection is created lazily by Init and can be torn down with Reset;
// this mirrors the legacy database package so that saving new settings at
// runtime transparently rebuilds the connection.
package store

import (
	"context"
	"errors"
	"sync"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/config"
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
	"go.mongodb.org/mongo-driver/v2/mongo/readpref"
)

// ErrNotFound is returned by every single-document lookup that matched nothing.
// It is an alias of the driver error so callers can keep using errors.Is with
// either value.
var ErrNotFound = mongo.ErrNoDocuments

// DefaultTimeout bounds every database round trip so a hung MongoDB cannot
// block an HTTP handler indefinitely.
const DefaultTimeout = 10 * time.Second

var (
	mu     sync.RWMutex
	client *mongo.Client
	db     *mongo.Database
)

// Init connects to MongoDB, verifies the deployment is reachable and makes sure
// all indexes exist. It is safe to call repeatedly; an existing healthy
// connection is reused.
func Init() error {
	mu.RLock()
	ok := client != nil && db != nil
	mu.RUnlock()
	if ok {
		return nil
	}

	ctx, cancel := context.WithTimeout(context.Background(), DefaultTimeout)
	defer cancel()

	opts := options.Client().ApplyURI(config.String("MongoURI"))
	if name := config.String("WebApplicationName"); name != "" {
		opts.SetAppName(name)
	}
	c, err := mongo.Connect(opts)
	if err != nil {
		return err
	}
	if err := c.Ping(ctx, readpref.Primary()); err != nil {
		_ = c.Disconnect(context.Background())
		return err
	}
	d := c.Database(config.String("MongoDatabaseName"))
	if d.Name() == "" {
		_ = c.Disconnect(context.Background())
		return errors.New("MongoDatabaseName is empty")
	}

	mu.Lock()
	client, db = c, d
	mu.Unlock()

	if err := EnsureIndexes(ctx); err != nil {
		glgf.Error("mongo: index bootstrap failed: ", err)
	}
	glgf.Success("mongodb connected: " + d.Name())
	return nil
}

// Reset drops the cached connection. The next call to Init reconnects using the
// current configuration. Used after an administrator saves new settings.
func Reset() {
	mu.Lock()
	c := client
	client, db = nil, nil
	mu.Unlock()
	if c != nil {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		_ = c.Disconnect(ctx)
	}
}

// Client returns the live client. It may be nil before a successful Init.
func Client() *mongo.Client {
	mu.RLock()
	defer mu.RUnlock()
	return client
}

// DB returns the live database handle. It may be nil before a successful Init.
func DB() *mongo.Database {
	mu.RLock()
	defer mu.RUnlock()
	return db
}

// Collection returns a handle to a named collection.
func Collection(name string) *mongo.Collection { return DB().Collection(name) }

// Ctx builds a context with the default query timeout applied.
func Ctx() (context.Context, context.CancelFunc) {
	return context.WithTimeout(context.Background(), DefaultTimeout)
}
