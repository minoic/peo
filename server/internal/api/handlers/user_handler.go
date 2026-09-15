package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/service"
)

// UserHandler serves the account settings page: password, e-mail and the
// Pterodactyl account bootstrap.
type UserHandler struct{}

// NewUserHandler builds the handler.
func NewUserHandler() *UserHandler { return &UserHandler{} }

// Password rotates the password of the signed-in user. The current password is
// required so a stolen token alone cannot lock the owner out.
//
// PUT /api/v1/user/password
func (h *UserHandler) Password(c *gin.Context) {
	var req dto.ChangePasswordRequest
	if !bind(c, &req) {
		return
	}
	err := service.Auth.ChangePassword(c.Request.Context(), middleware.UserID(c), req.OldPassword, req.NewPassword)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("password updated"))
}

// Email mails a confirmation code to the new address. The address is not
// changed until the code comes back, so a typo cannot lock the user out.
//
// PUT /api/v1/user/email
func (h *UserHandler) Email(c *gin.Context) {
	var req dto.ChangeEmailRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Auth.ChangeEmail(c.Request.Context(), middleware.UserID(c), req.Email); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("a confirmation code has been sent"))
}

// ConfirmEmail completes an e-mail change.
//
// POST /api/v1/user/email/confirm
func (h *UserHandler) ConfirmEmail(c *gin.Context) {
	var req dto.ConfirmEmailRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Auth.ConfirmEmailChange(c.Request.Context(), middleware.UserID(c), req.Email, req.Code); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("e-mail updated"))
}

// PterodactylUser creates the matching panel account when the registration step
// could not, which is what the legacy settings page offered as a "retry".
//
// POST /api/v1/user/pterodactyl-user
func (h *UserHandler) PterodactylUser(c *gin.Context) {
	if err := service.Auth.EnsurePterodactylUser(c.Request.Context(), middleware.UserID(c)); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("the panel account is ready"))
}
