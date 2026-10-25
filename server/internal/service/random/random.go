// Package random produces the short codes used as product keys, recharge
// codes, password-reset captchas and registration confirmation tokens.
//
// Security tokens fail closed when the operating system random source is
// unavailable. They must never fall back to a predictable generator.
package random

import (
	"crypto/rand"
	"encoding/hex"
	"io"
	"math/big"
	mathrand "math/rand"
	"sync"
	"time"
)

const (
	digits  = "0123456789"
	letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	both    = letters + digits
)

// fallbackMu guards the non-security fallback used only by Intn.
var (
	fallbackMu   sync.Mutex
	fallback               = mathrand.New(mathrand.NewSource(time.Now().UnixNano()))
	secureReader io.Reader = rand.Reader
)

// Intn returns a value uniformly distributed over [0, n).
//
// A non-positive n yields 0 rather than panicking, because callers pass values
// derived from configuration.
func Intn(n int) int {
	if n <= 0 {
		return 0
	}
	v, err := rand.Int(rand.Reader, big.NewInt(int64(n)))
	if err != nil {
		fallbackMu.Lock()
		defer fallbackMu.Unlock()
		return fallback.Intn(n)
	}
	return int(v.Int64())
}

// fromAlphabet builds an n character string by picking uniformly from alphabet.
// Because out is allocated with length n, the result is exactly n characters and
// can only be empty when n <= 0.
func fromAlphabet(n int, alphabet string) (string, error) {
	if n <= 0 {
		return "", nil
	}
	limit := big.NewInt(int64(len(alphabet)))
	out := make([]byte, n)
	for i := range out {
		v, err := rand.Int(secureReader, limit)
		if err != nil {
			return "", err
		}
		out[i] = alphabet[v.Int64()]
	}
	return string(out), nil
}

// String returns n characters drawn from [a-zA-Z0-9]. It is the general purpose
// generator behind activation and confirmation codes.
func String(n int) (string, error) { return fromAlphabet(n, both) }

// Code is the activation and recharge code generator. The length is long enough
// that guessing a live code is not a realistic attack, which matters because
// redeeming one provisions a server.
func Code() (string, error) { return fromAlphabet(32, both) }

// UUID returns a random 128 bit identifier rendered as hex. It replaces the
// gofrs/uuid dependency with the standard library.
func UUID() (string, error) {
	b := make([]byte, 16)
	if _, err := io.ReadFull(secureReader, b); err != nil {
		return "", err
	}
	return hex.EncodeToString(b), nil
}

// Letters returns n characters drawn from [a-zA-Z] (the legacy RandKey).
func Letters(n int) (string, error) { return fromAlphabet(n, letters) }

// Digits returns n characters drawn from [0-9] (the legacy RandNumKey).
func Digits(n int) (string, error) { return fromAlphabet(n, digits) }
