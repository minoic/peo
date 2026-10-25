// Package api holds the HTTP layer: the Gin router, the request/response DTOs
// and the handlers grouped by resource.
//
// Every response body is a single JSON object, so the client never has to guess
// the shape:
//
//	{"ok":true,  "data": <payload>}
//	{"ok":false, "error":{"code":"invalid_key","message":"..."}}
//
// The codes themselves and the envelope writer live in `internal/apierr`,
// because the router imports `internal/middleware` and the middleware must
// report failures with the very same envelope without importing this package
// back. This file re-exports them so handlers can keep writing `api.OK(c, x)`.
package api

import "github.com/minoic/peo/server/internal/apierr"

// ErrorCode is the machine readable identifier the Flutter client switches on.
type ErrorCode = apierr.Code

// Error is the typed failure carried through the call stack.
type Error = apierr.Error

// Error codes, re-exported for handler and DTO readability.
const (
	CodeUnauthorized          = apierr.CodeUnauthorized
	CodeForbidden             = apierr.CodeForbidden
	CodeNotFound              = apierr.CodeNotFound
	CodeValidationFailed      = apierr.CodeValidationFailed
	CodeConflict              = apierr.CodeConflict
	CodeRateLimited           = apierr.CodeRateLimited
	CodeInsufficientBalance   = apierr.CodeInsufficientBalance
	CodeInvalidKey            = apierr.CodeInvalidKey
	CodeAlreadyPaid           = apierr.CodeAlreadyPaid
	CodePterodactylError      = apierr.CodePterodactylError
	CodeExtensionUnavailable  = apierr.CodeExtensionUnavailable
	CodePanelPermissionDenied = apierr.CodePanelPermissionDenied
	CodePanelUnavailable      = apierr.CodePanelUnavailable
	CodeInternal              = apierr.CodeInternal
)

// Fail builds a coded error with a user facing message.
var Fail = apierr.Fail

// Wrap attaches a cause to a coded error.
var Wrap = apierr.Wrap

// AsError converts any error into a coded error.
var AsError = apierr.AsError

// OK writes a 200 success envelope.
var OK = apierr.OK

// Created writes a 201 success envelope.
var Created = apierr.Created

// Empty writes a 200 success envelope with a null payload.
var Empty = apierr.Empty

// Abort writes a failure envelope and stops the handler chain.
var Abort = apierr.Abort
