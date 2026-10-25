package middleware

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/auth"
	"github.com/minoic/peo/server/internal/config"
)

func TestCORSExposesContentDisposition(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.Use(CORS("https://app.example.test"))
	router.GET("/download", func(c *gin.Context) {
		c.Header("Content-Disposition", `attachment; filename="world.zip"`)
		c.Status(http.StatusOK)
	})

	req := httptest.NewRequest(http.MethodGet, "/download", nil)
	req.Header.Set("Origin", "https://app.example.test")
	res := httptest.NewRecorder()
	router.ServeHTTP(res, req)

	if got := res.Header().Get("Access-Control-Expose-Headers"); got != "Content-Disposition" {
		t.Fatalf("Access-Control-Expose-Headers = %q, want Content-Disposition", got)
	}
}

func TestRevocationLookupFailureFailsClosed(t *testing.T) {
	if err := config.LoadSettings(map[string]any{
		"JWTSecret": "middleware-test-secret-with-enough-entropy",
		"RedisHost": "127.0.0.1:1",
	}); err != nil {
		t.Fatal(err)
	}
	token, err := auth.GenerateToken("user", "012345678901234567890123", false, false)
	if err != nil {
		t.Fatal(err)
	}

	gin.SetMode(gin.TestMode)
	protected := gin.New()
	protected.Use(Auth())
	protected.GET("/", func(c *gin.Context) { c.Status(http.StatusNoContent) })
	req := httptest.NewRequest(http.MethodGet, "/", nil)
	ctx, cancel := context.WithTimeout(req.Context(), time.Second)
	defer cancel()
	req = req.WithContext(ctx)
	req.Header.Set("Authorization", "Bearer "+token)
	res := httptest.NewRecorder()
	protected.ServeHTTP(res, req)
	if res.Code != http.StatusInternalServerError {
		t.Fatalf("protected request status = %d, want 500 on Redis failure", res.Code)
	}

	optional := gin.New()
	optional.Use(OptionalAuth())
	optional.GET("/", func(c *gin.Context) {
		if LoggedIn(c) {
			c.Status(http.StatusForbidden)
			return
		}
		c.Status(http.StatusNoContent)
	})
	optionalReq := httptest.NewRequest(http.MethodGet, "/", nil)
	optionalCtx, optionalCancel := context.WithTimeout(optionalReq.Context(), time.Second)
	defer optionalCancel()
	optionalReq = optionalReq.WithContext(optionalCtx)
	optionalReq.Header.Set("Authorization", "Bearer "+token)
	optionalRes := httptest.NewRecorder()
	optional.ServeHTTP(optionalRes, optionalReq)
	if optionalRes.Code != http.StatusNoContent {
		t.Fatalf("optional request status = %d, want anonymous success", optionalRes.Code)
	}
}
