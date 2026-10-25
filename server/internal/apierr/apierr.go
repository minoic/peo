// Package apierr is the transport error vocabulary shared by every layer.
//
// It exists as a package of its own because of one structural constraint: the
// router lives in `internal/api` and imports `internal/middleware`, so the
// middleware cannot import `internal/api` back. Both need to produce the same
// failure envelope, and `internal/service` needs to build the same errors
// without depending on Gin's request handling. Keeping the codes, the typed
// error and the one envelope writer here gives all three a single definition
// and keeps the dependency graph acyclic:
//
//	service    -> apierr
//	middleware -> apierr
//	api        -> apierr, middleware, service
//
// The wire format is unchanged and is the contract the Flutter client codes
// against:
//
//	{"ok":true,  "data": <payload>}
//	{"ok":false, "error":{"code":"invalid_key","message":"..."}}
package apierr

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Code is the machine readable identifier the Flutter client switches on to
// decide what to show the user. The set is deliberately small and stable.
type Code string

// Error codes. Keeping them as constants means a typo is a compile error on the
// server and a documented value on the client.
const (
	CodeUnauthorized          Code = "unauthorized"
	CodeForbidden             Code = "forbidden"
	CodeNotFound              Code = "not_found"
	CodeValidationFailed      Code = "validation_failed"
	CodeConflict              Code = "conflict"
	CodeRateLimited           Code = "rate_limited"
	CodeInsufficientBalance   Code = "insufficient_balance"
	CodeInvalidKey            Code = "invalid_key"
	CodeAlreadyPaid           Code = "already_paid"
	CodePterodactylError      Code = "pte_error"
	CodeExtensionUnavailable  Code = "panel_extension_unavailable"
	CodePanelPermissionDenied Code = "panel_permission_denied"
	CodePanelUnavailable      Code = "panel_unavailable"
	CodeInternal              Code = "internal_error"
)

// Error carries a code and message through the call stack so a service can
// `return err` instead of the caller re-deriving what went wrong. It satisfies
// the `error` interface without importing Gin, which is what lets the service
// layer stay transport agnostic: only the envelope writers below touch Gin.
type Error struct {
	Code    Code
	Message string
	Status  int
	Err     error
}

// Error implements the error interface.
func (e *Error) Error() string {
	if e.Err != nil {
		return string(e.Code) + ": " + e.Message + ": " + e.Err.Error()
	}
	return string(e.Code) + ": " + e.Message
}

// Unwrap exposes the wrapped cause to errors.Is/As.
func (e *Error) Unwrap() error { return e.Err }

// HTTPStatus is the status code the envelope is delivered with.
func (e *Error) HTTPStatus() int {
	if e.Status != 0 {
		return e.Status
	}
	return statusForCode(e.Code)
}

func statusForCode(c Code) int {
	switch c {
	case CodeUnauthorized:
		return http.StatusUnauthorized
	case CodeForbidden:
		return http.StatusForbidden
	case CodeNotFound:
		return http.StatusNotFound
	case CodeValidationFailed:
		return http.StatusBadRequest
	case CodeConflict, CodeAlreadyPaid:
		return http.StatusConflict
	case CodeRateLimited:
		return http.StatusTooManyRequests
	case CodeInsufficientBalance, CodeInvalidKey:
		return http.StatusBadRequest
	case CodePterodactylError:
		return http.StatusBadGateway
	case CodeExtensionUnavailable:
		return http.StatusBadGateway
	case CodePanelPermissionDenied:
		return http.StatusBadGateway
	case CodePanelUnavailable:
		return http.StatusBadGateway
	default:
		return http.StatusInternalServerError
	}
}

// Fail builds a coded error with a user facing message.
func Fail(code Code, message string) *Error {
	return &Error{Code: code, Message: message}
}

// Wrap attaches a cause to a coded error; the cause is logged, never returned.
func Wrap(code Code, message string, cause error) *Error {
	return &Error{Code: code, Message: message, Err: cause}
}

// AsError converts any error into a coded error, defaulting to internal_error.
// A nil error yields nil so callers can write `return AsError(err)`.
func AsError(err error) *Error {
	if err == nil {
		return nil
	}
	var e *Error
	if errors.As(err, &e) {
		return e
	}
	return Wrap(CodeInternal, "internal server error", err)
}

// envelope is the single success/failure body type.
type envelope struct {
	OK    bool        `json:"ok"`
	Data  interface{} `json:"data,omitempty"`
	Error *payload    `json:"error,omitempty"`
}

// payload is the failure detail.
type payload struct {
	Code    Code   `json:"code"`
	Message string `json:"message"`
}

// OK writes a success envelope.
func OK(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, envelope{OK: true, Data: data})
}

// Created writes a success envelope with 201.
func Created(c *gin.Context, data interface{}) {
	c.JSON(http.StatusCreated, envelope{OK: true, Data: data})
}

// Empty writes a success envelope with a null payload.
func Empty(c *gin.Context) {
	c.JSON(http.StatusOK, envelope{OK: true})
}

// Abort writes a failure envelope and stops the handler chain.
func Abort(c *gin.Context, e *Error) {
	if e == nil {
		e = Fail(CodeInternal, "internal server error")
	}
	// The cause is for the log; the client only sees the safe message.
	if e.Err != nil {
		c.Error(e.Err) //nolint:errcheck // collected by the logger middleware
	}
	c.AbortWithStatusJSON(e.HTTPStatus(), envelope{
		OK:    false,
		Error: &payload{Code: e.Code, Message: e.Message},
	})
}
