package random

import (
	"errors"
	"strings"
	"testing"
)

type failedReader struct{}

func (failedReader) Read([]byte) (int, error) { return 0, errors.New("entropy unavailable") }

func TestSecurityTokensFailWhenEntropyIsUnavailable(t *testing.T) {
	previous := secureReader
	secureReader = failedReader{}
	t.Cleanup(func() { secureReader = previous })

	for name, generate := range map[string]func() (string, error){
		"string":  func() (string, error) { return String(24) },
		"digits":  func() (string, error) { return Digits(6) },
		"letters": func() (string, error) { return Letters(20) },
		"code":    Code,
		"uuid":    UUID,
	} {
		t.Run(name, func(t *testing.T) {
			if value, err := generate(); err == nil || value != "" || !strings.Contains(err.Error(), "entropy unavailable") {
				t.Fatalf("got (%q, %v), want entropy error and no token", value, err)
			}
		})
	}
}
