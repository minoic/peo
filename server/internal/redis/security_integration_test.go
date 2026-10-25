package redis_test

import (
	"context"
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/auth"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/redis"
)

func TestRedisRevocationBlocksProtectedAndOptionalIdentity(t *testing.T) {
	addr := os.Getenv("PEO_TEST_REDIS_ADDR")
	if addr == "" {
		t.Skip("set PEO_TEST_REDIS_ADDR to run Redis revocation integration test")
	}
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	if err := config.LoadSettings(map[string]any{
		"JWTSecret": "redis-test-private-key-with-enough-entropy",
		"RedisHost": addr,
		"RedisDB":   0,
	}); err != nil {
		t.Fatal(err)
	}
	redis.Reset()
	t.Cleanup(redis.Reset)

	token, err := auth.GenerateToken("redis_test", "012345678901234567890123", false, false)
	if err != nil {
		t.Fatal(err)
	}
	claims, err := auth.ParseToken(token)
	if err != nil {
		t.Fatal(err)
	}
	key := auth.TokenBlacklistKey(claims.ID)
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	if err := redis.Set(ctx, key, "1", time.Minute); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { redis.Del(context.Background(), key) })
	revoked, err := redis.Revoked(ctx, key)
	if err != nil || !revoked {
		t.Fatalf("Revoked() = (%v, %v), want true", revoked, err)
	}

	gin.SetMode(gin.TestMode)
	protected := gin.New()
	protected.Use(middleware.Auth())
	protected.GET("/", func(c *gin.Context) { c.Status(http.StatusNoContent) })
	protectedReq := httptest.NewRequest(http.MethodGet, "/", nil)
	protectedReq.Header.Set("Authorization", "Bearer "+token)
	protectedRes := httptest.NewRecorder()
	protected.ServeHTTP(protectedRes, protectedReq)
	if protectedRes.Code != http.StatusUnauthorized {
		t.Fatalf("protected revoked token status=%d, want 401", protectedRes.Code)
	}

	optional := gin.New()
	optional.Use(middleware.OptionalAuth())
	optional.GET("/", func(c *gin.Context) {
		if middleware.LoggedIn(c) {
			c.String(http.StatusOK, "authenticated")
			return
		}
		c.String(http.StatusOK, fmt.Sprintf("anonymous:%t", !middleware.LoggedIn(c)))
	})
	optionalReq := httptest.NewRequest(http.MethodGet, "/", nil)
	optionalReq.Header.Set("Authorization", "Bearer "+token)
	optionalRes := httptest.NewRecorder()
	optional.ServeHTTP(optionalRes, optionalReq)
	if optionalRes.Body.String() != "anonymous:true" {
		t.Fatalf("OptionalAuth response=%q, want anonymous", optionalRes.Body.String())
	}
}
