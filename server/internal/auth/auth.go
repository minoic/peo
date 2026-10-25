// Package auth holds password hashing and JWT issuing/validation.
//
// The move to a REST API replaced Beego's cookie session with a bearer token.
// The token payload is deliberately small: the user name, the user id and the
// admin flag, so that a request can be authorised without a database round
// trip. Everything else is loaded from MongoDB when the handler needs it.
package auth

import (
	"crypto/md5"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"strings"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/config"
	"github.com/robbert229/jwt"
)

const legacyJWTKey = "xiCI^gi0!HE1kKZO6*W6k&SPS3$6jufiu*0T7$t!jUktm@#o"

// Token lifetimes. "remember me" logs the user in for two months, otherwise a
// single day, matching the legacy behaviour.
const (
	ShortTokenTTL = 24 * time.Hour
	LongTokenTTL  = 60 * 24 * time.Hour
)

// Claims is the decoded token payload.
type Claims struct {
	Username string
	Subject  string
	IsAdmin  bool
	Expires  time.Time
	// ID is the token's own identifier, the `jti` claim. Logout records it in
	// Redis so the presented token can be blacklisted until it would have
	// expired on its own.
	ID string
}

// algo returns the signing algorithm, rebuilt on every call so that changing
// JWTSecret in the admin UI takes effect without a restart. The driver's Encode
// and Validate methods have pointer receivers, so a variable is needed rather
// than returning the call result directly.
func algo() (*jwt.Algorithm, error) {
	key := config.String("JWTSecret")
	key = strings.TrimSpace(key)
	if len(key) < 32 || key == legacyJWTKey {
		return nil, errors.New("JWTSecret is not initialized with a private key")
	}
	a := jwt.HmacSha512(key)
	return &a, nil
}

// GenerateToken issues a signed token for a user. remember selects the long
// lifetime. The token carries a fresh random `jti` claim so that a single token
// can be revoked without invalidating the other sessions of the same user.
func GenerateToken(username string, subject string, isAdmin bool, remember bool) (string, error) {
	id, err := randomTokenID()
	if err != nil {
		glgf.Error("cannot generate token id for " + username + ": " + err.Error())
		return "", err
	}
	claims := jwt.NewClaim()
	claims.Set("username", username)
	claims.Set("sub", subject)
	claims.Set("admin", isAdmin)
	claims.Set("jti", id)
	ttl := ShortTokenTTL
	if remember {
		ttl = LongTokenTTL
	}
	claims.SetTime("exp", time.Now().Add(ttl))
	signer, err := algo()
	if err != nil {
		return "", err
	}
	token, err := signer.Encode(claims)
	if err != nil {
		glgf.Error("cannot generate token for " + username + ": " + err.Error())
		return "", err
	}
	return token, nil
}

// randomTokenID returns the 32 hex character identifier used for `jti`.
func randomTokenID() (string, error) {
	buf := make([]byte, 16)
	if _, err := rand.Read(buf); err != nil {
		return "", err
	}
	return hex.EncodeToString(buf), nil
}

// ParseToken validates the signature and expiry and returns the claims.
func ParseToken(token string) (*Claims, error) {
	a, err := algo()
	if err != nil {
		return nil, err
	}
	if err := a.Validate(token); err != nil {
		return nil, err
	}
	raw, err := a.Decode(token)
	if err != nil {
		return nil, err
	}
	out := &Claims{}
	if v, _ := raw.Get("username"); v != nil {
		out.Username, _ = v.(string)
	}
	if v, _ := raw.Get("sub"); v != nil {
		out.Subject, _ = v.(string)
	}
	if v, _ := raw.Get("admin"); v != nil {
		out.IsAdmin, _ = v.(bool)
	}
	if v, _ := raw.Get("jti"); v != nil {
		out.ID, _ = v.(string)
	}
	exp, err := raw.GetTime("exp")
	if err != nil {
		return nil, errors.New("token has no expiry")
	}
	out.Expires = exp
	if out.Username == "" || !time.Now().Before(exp) {
		return nil, errors.New("token expired or malformed")
	}
	return out, nil
}

// ValidateToken is the shape the legacy code used. It is retained because the
// SSO handover still checks a token against a specific user name.
func ValidateToken(token string, username string) bool {
	c, err := ParseToken(token)
	return err == nil && c.Username == username
}

// TokenBlacklistKey is the Redis key a revoked token id is recorded under. It
// lives here so that the middleware which checks the blacklist and the service
// which writes to it can never drift apart.
func TokenBlacklistKey(tokenID string) string {
	return "JWTBLACKLIST:" + tokenID
}

// HashPassword reproduces the legacy scheme: md5(password + DatabaseSalt), hex
// encoded. The scheme is unchanged so existing credentials and the documented
// behaviour stay intact; it is centralised here so it can be upgraded in one
// place later.
func HashPassword(password string) string {
	sum := md5.Sum([]byte(password + config.String("DatabaseSalt")))
	return hex.EncodeToString(sum[:])
}

// CheckPassword compares a candidate password against a stored hash in constant
// time with respect to the hash contents.
func CheckPassword(hash string, password string) bool {
	if hash == "" {
		return false
	}
	return subtleCompare(hash, HashPassword(password))
}

// subtleCompare is a length-safe constant time string comparison.
func subtleCompare(a, b string) bool {
	if len(a) != len(b) {
		return false
	}
	var diff byte
	for i := 0; i < len(a); i++ {
		diff |= a[i] ^ b[i]
	}
	return diff == 0
}

// ValidateUsername enforces the registration rule: ASCII letters, digits and
// underscores only, 3 to 32 characters.
func ValidateUsername(name string) error {
	if len(name) < 3 || len(name) > 32 {
		return errors.New("user name must be between 3 and 32 characters")
	}
	for _, r := range name {
		switch {
		case r >= 'a' && r <= 'z', r >= 'A' && r <= 'Z', r >= '0' && r <= '9', r == '_':
		default:
			return errors.New("user name may only contain letters, digits and underscores")
		}
	}
	return nil
}

// ValidateEmail performs the minimal sanity check the legacy code needed; it is
// not a full RFC 5322 parser on purpose.
func ValidateEmail(email string) error {
	email = strings.TrimSpace(email)
	at := strings.Index(email, "@")
	if at <= 0 || at == len(email)-1 || !strings.Contains(email[at+1:], ".") {
		return errors.New("invalid e-mail address")
	}
	return nil
}
