package auth

import (
	"testing"

	"github.com/minoic/peo/server/internal/config"
)

func TestJWTRejectsMissingAndPublicLegacyKeys(t *testing.T) {
	if err := config.Init(); err != nil {
		t.Fatal(err)
	}
	for _, secret := range []string{"", "short-secret", legacyJWTKey, "  " + legacyJWTKey + "  "} {
		if err := config.LoadSettings(map[string]any{"JWTSecret": secret}); err != nil {
			t.Fatal(err)
		}
		if _, err := GenerateToken("user", "012345678901234567890123", false, false); err == nil {
			t.Fatalf("GenerateToken accepted unsafe secret %q", secret)
		}
		if _, err := ParseToken("not-a-token"); err == nil {
			t.Fatalf("ParseToken accepted unsafe secret %q", secret)
		}
	}
}

func TestJWTUsesConfiguredPrivateKey(t *testing.T) {
	if err := config.LoadSettings(map[string]any{"JWTSecret": "private-test-secret-with-enough-entropy"}); err != nil {
		t.Fatal(err)
	}
	token, err := GenerateToken("user", "012345678901234567890123", false, false)
	if err != nil {
		t.Fatal(err)
	}
	if claims, err := ParseToken(token); err != nil || claims.Username != "user" {
		t.Fatalf("ParseToken() = (%+v, %v)", claims, err)
	}
}
