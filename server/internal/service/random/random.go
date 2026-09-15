// Package random produces the short codes used as product keys, recharge
// codes, password-reset captchas and registration confirmation tokens.
//
// The legacy implementation (internal/cryptoo) seeded math/rand from the wall
// clock, which makes every generated code predictable once the approximate
// generation time is known. Those strings are bearer tokens, so this port reads
// from crypto/rand instead.
//
// crypto/rand can fail (exhausted file descriptors, unavailable entropy); a
// hard failure must never take the web process down, so the helpers fall back
// to a time-seeded math/rand source and log the degradation.
package random

import (
	"crypto/rand"
	"encoding/hex"
	"math/big"
	mathrand "math/rand"
	"sync"
	"time"

	"github.com/minoic/glgf"
)

const (
	digits  = "0123456789"
	letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	both    = letters + digits
)

// fallbackMu guards fallback, the degraded source used when crypto/rand fails.
var (
	fallbackMu     sync.Mutex
	fallback       = mathrand.New(mathrand.NewSource(time.Now().UnixNano()))
	fallbackWarned bool
)

// warnFallback logs (once) that generation has degraded to a non-cryptographic
// source.
func warnFallback(err error) {
	fallbackMu.Lock()
	first := !fallbackWarned
	fallbackWarned = true
	fallbackMu.Unlock()
	if first {
		glgf.Error("random: crypto/rand unavailable, falling back to math/rand: ", err)
	}
}

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
		warnFallback(err)
		fallbackMu.Lock()
		defer fallbackMu.Unlock()
		return fallback.Intn(n)
	}
	return int(v.Int64())
}

// fromAlphabet builds an n character string by picking uniformly from alphabet.
// Because out is allocated with length n, the result is exactly n characters and
// can only be empty when n <= 0.
func fromAlphabet(n int, alphabet string) string {
	if n <= 0 {
		return ""
	}
	out := make([]byte, n)
	for i := range out {
		out[i] = alphabet[Intn(len(alphabet))]
	}
	return string(out)
}

// String returns n characters drawn from [a-zA-Z0-9]. It is the general purpose
// generator behind activation and confirmation codes.
func String(n int) string { return fromAlphabet(n, both) }

// Code is the activation and recharge code generator. The length is long enough
// that guessing a live code is not a realistic attack, which matters because
// redeeming one provisions a server.
func Code() string { return fromAlphabet(32, both) }

// UUID returns a random 128 bit identifier rendered as hex. It replaces the
// gofrs/uuid dependency with the standard library.
func UUID() string {
	b := make([]byte, 16)
	if _, err := rand.Read(b); err != nil {
		warnFallback(err)
		fallbackMu.Lock()
		defer fallbackMu.Unlock()
		for i := range b {
			b[i] = byte(fallback.Intn(256))
		}
	}
	return hex.EncodeToString(b)
}

// Letters returns n characters drawn from [a-zA-Z] (the legacy RandKey).
func Letters(n int) string { return fromAlphabet(n, letters) }

// Digits returns n characters drawn from [0-9] (the legacy RandNumKey).
func Digits(n int) string { return fromAlphabet(n, digits) }
