// Package middleware provides the Gin middlewares shared by every route:
// bearer-token authentication, the administrator gate, CORS for the separately
// hosted Flutter bundle, request logging and panic recovery.
package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/auth"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// Context keys. Handlers read them through UserID/Username/IsAdmin rather than
// touching gin's key/value bag directly, so a key rename is one edit.
const (
	ctxUserID   = "peo.userID"
	ctxUsername = "peo.username"
	ctxIsAdmin  = "peo.isAdmin"
	ctxToken    = "peo.token"
)

// Auth validates the bearer token and loads the account. It rejects with
// `unauthorized` when the header is missing, the signature is wrong, the token
// has expired, or the user no longer exists.
func Auth() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := bearer(c)
		if token == "" {
			apierr.Abort(c, apierr.Fail(apierr.CodeUnauthorized, "missing bearer token"))
			return
		}
		claims, err := auth.ParseToken(token)
		if err != nil {
			apierr.Abort(c, apierr.Fail(apierr.CodeUnauthorized, "invalid or expired token"))
			return
		}
		// A token issued before logout is blacklisted in Redis until it would
		// have expired anyway.
		if claims.ID != "" && redis.Limited(c.Request.Context(), auth.TokenBlacklistKey(claims.ID)) {
			apierr.Abort(c, apierr.Fail(apierr.CodeUnauthorized, "token has been revoked"))
			return
		}
		id, err := models.ObjectIDFromHex(claims.Subject)
		if err != nil {
			apierr.Abort(c, apierr.Fail(apierr.CodeUnauthorized, "invalid token subject"))
			return
		}
		// The account is re-read on every request: an administrator who is
		// demoted or a user who is deleted loses access immediately rather than
		// when the token happens to expire.
		u, err := store.User.ByID(c.Request.Context(), id)
		if err != nil {
			apierr.Abort(c, apierr.Fail(apierr.CodeUnauthorized, "account no longer exists"))
			return
		}
		setUser(c, u, token)
		c.Next()
	}
}

// OptionalAuth is the same as Auth but lets anonymous requests through. It is
// used by the storefront so the site configuration and product list are public
// while a logged-in visitor still sees their own data in the same endpoints.
func OptionalAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := bearer(c)
		if token == "" {
			c.Next()
			return
		}
		claims, err := auth.ParseToken(token)
		if err != nil {
			c.Next()
			return
		}
		id, err := models.ObjectIDFromHex(claims.Subject)
		if err != nil {
			c.Next()
			return
		}
		if u, err := store.User.ByID(c.Request.Context(), id); err == nil {
			setUser(c, u, token)
		}
		c.Next()
	}
}

// Admin must be installed after Auth; it rejects non-administrators with
// `forbidden`.
func Admin() gin.HandlerFunc {
	return func(c *gin.Context) {
		if !IsAdmin(c) {
			apierr.Abort(c, apierr.Fail(apierr.CodeForbidden, "administrator privileges required"))
			return
		}
		c.Next()
	}
}

// CORS answers preflight requests and echoes the allowed origin. Origins come
// from the CORSOrigins setting; "*" (the default) allows any origin.
func CORS(origins string) gin.HandlerFunc {
	allowAll := strings.TrimSpace(origins) == "" || strings.TrimSpace(origins) == "*"
	allowed := map[string]bool{}
	for _, o := range strings.Split(origins, ",") {
		if o = strings.TrimSpace(o); o != "" {
			allowed[o] = true
		}
	}
	return func(c *gin.Context) {
		origin := c.GetHeader("Origin")
		if origin != "" && (allowAll || allowed[origin]) {
			c.Header("Access-Control-Allow-Origin", origin)
			c.Header("Vary", "Origin")
			c.Header("Access-Control-Allow-Credentials", "true")
			c.Header("Access-Control-Allow-Headers", "Authorization,Content-Type,Accept")
			c.Header("Access-Control-Allow-Methods", "GET,POST,PUT,PATCH,DELETE,OPTIONS")
			c.Header("Access-Control-Max-Age", "600")
		}
		if c.Request.Method == http.MethodOptions {
			c.AbortWithStatus(http.StatusNoContent)
			return
		}
		c.Next()
	}
}

// Recovery converts a panic into an `internal_error` envelope so the client
// always receives JSON, and logs the stack.
func Recovery() gin.HandlerFunc {
	return gin.CustomRecovery(func(c *gin.Context, recovered interface{}) {
		glgf.Errorf("panic on %s %s: %v", c.Request.Method, c.Request.URL.Path, recovered)
		apierr.Abort(c, apierr.Fail(apierr.CodeInternal, "internal server error"))
	})
}

// Logger records method, path, status and the coded error, if any.
func Logger() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()
		for _, e := range c.Errors {
			glgf.Error(c.Request.Method + " " + c.Request.URL.Path + ": " + e.Error())
		}
	}
}

func bearer(c *gin.Context) string {
	h := c.GetHeader("Authorization")
	if h == "" {
		return ""
	}
	if len(h) > 7 && strings.EqualFold(h[:7], "bearer ") {
		return strings.TrimSpace(h[7:])
	}
	return strings.TrimSpace(h)
}

func setUser(c *gin.Context, u *models.User, token string) {
	c.Set(ctxUserID, u.ID)
	c.Set(ctxUsername, u.Name)
	c.Set(ctxIsAdmin, u.IsAdmin)
	c.Set(ctxToken, token)
}

// UserID returns the authenticated user id. It is only valid after Auth or
// OptionalAuth; CheckUserID reports whether it was set.
func UserID(c *gin.Context) bson.ObjectID {
	if v, ok := c.Get(ctxUserID); ok {
		if id, ok := v.(bson.ObjectID); ok {
			return id
		}
	}
	return bson.NilObjectID
}

// Username returns the authenticated user name.
func Username(c *gin.Context) string {
	if v, ok := c.Get(ctxUsername); ok {
		if s, ok := v.(string); ok {
			return s
		}
	}
	return ""
}

// IsAdmin reports whether the current request belongs to an administrator.
func IsAdmin(c *gin.Context) bool {
	if v, ok := c.Get(ctxIsAdmin); ok {
		if b, ok := v.(bool); ok {
			return b
		}
	}
	return false
}

// Token returns the raw bearer token, needed by logout to blacklist it.
func Token(c *gin.Context) string {
	if v, ok := c.Get(ctxToken); ok {
		if s, ok := v.(string); ok {
			return s
		}
	}
	return ""
}

// LoggedIn reports whether the request carried a valid token.
func LoggedIn(c *gin.Context) bool { return !UserID(c).IsZero() }

// RequireLogin writes an `unauthorized` response and reports false when the
// request is anonymous. Handlers that are mounted with OptionalAuth use it.
func RequireLogin(c *gin.Context) bool {
	if LoggedIn(c) {
		return true
	}
	apierr.Abort(c, apierr.Fail(apierr.CodeUnauthorized, "login required"))
	return false
}
