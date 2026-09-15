// Package handlers contains the Gin handlers. They are deliberately thin: bind
// the request into a DTO, call exactly one service method, encode the envelope.
// No business rule lives here, and no handler touches `store` or the Mongo
// driver -- that is layer rule 1 of the target architecture.
package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/models"
)

// bind decodes the JSON body into v. A malformed body is a client error, never a
// 500, so it is reported as `validation_failed`.
func bind(c *gin.Context, v interface{}) bool {
	if err := c.ShouldBindJSON(v); err != nil {
		apierr.Abort(c, apierr.Wrap(apierr.CodeValidationFailed, "invalid request body", err))
		return false
	}
	return true
}

// idParam parses a 24 character hex ObjectID from a path parameter. Every id in
// the API is an ObjectID hex string, so the legacy `strconv.Atoi` conversions are
// gone. `what` names the parameter in the error message.
//
// The returned type is `models.ObjectID`, which is an alias for the driver's
// type: the handler layer never names the driver, which keeps layer rule 1
// mechanically checkable.
func idParam(c *gin.Context, name, what string) (models.ObjectID, bool) {
	raw := c.Param(name)
	id, err := models.ObjectIDFromHex(raw)
	if err != nil {
		apierr.Abort(c, apierr.Fail(apierr.CodeNotFound, "invalid "+what))
		return models.NilObjectID, false
	}
	return id, true
}

// badParam reports a path or query parameter that is not a usable value. It is a
// client error, not a 500.
func badParam(c *gin.Context, what string) {
	apierr.Abort(c, apierr.Fail(apierr.CodeValidationFailed, "invalid "+what))
}

// fail writes a coded error produced by the service layer. `AsError` already
// normalises an unexpected error into `internal_error`, and returns nil when the
// service succeeded, which keeps the call sites to one line.
func fail(c *gin.Context, err error) {
	if err == nil {
		return
	}
	apierr.Abort(c, apierr.AsError(err))
}

// ok is a shorthand for the common success path.
func ok(c *gin.Context, data interface{}) {
	apierr.OK(c, data)
}

// created is a shorthand for a 201 success.
func created(c *gin.Context, data interface{}) {
	apierr.Created(c, data)
}

// msg is the bare confirmation payload used by the actions that have nothing
// else to report.
func msg(text string) dto.MessageResponse { return dto.MessageResponse{Message: text} }
