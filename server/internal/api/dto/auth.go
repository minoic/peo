package dto

import (
	"time"

	"github.com/minoic/peo/server/internal/models"
)

// LoginRequest carries the credentials of a sign-in attempt. `Login` is either
// the user name or the e-mail address, matching the legacy controller, which
// tried both.
type LoginRequest struct {
	Login    string `json:"login" binding:"required"`
	Password string `json:"password" binding:"required"`
	// Remember issues the long lived token (60 days instead of 24 hours).
	Remember bool `json:"remember"`
}

// RegisterRequest creates a new account.
type RegisterRequest struct {
	Name     string `json:"name" binding:"required"`
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// ForgetPasswordRequest starts the password reset flow.
type ForgetPasswordRequest struct {
	Email string `json:"email" binding:"required"`
}

// ResetPasswordRequest finishes the password reset flow with the code mailed in
// the previous step. The e-mail address is repeated because this endpoint is
// anonymous: there is no session to take the identity from.
type ResetPasswordRequest struct {
	Email       string `json:"email" binding:"required"`
	Code        string `json:"code" binding:"required"`
	NewPassword string `json:"newPassword" binding:"required"`
}

// ChangePasswordRequest rotates the password of the signed-in user.
type ChangePasswordRequest struct {
	OldPassword string `json:"oldPassword" binding:"required"`
	NewPassword string `json:"newPassword" binding:"required"`
}

// ChangeEmailRequest asks for a confirmation code to be mailed to the new
// address.
type ChangeEmailRequest struct {
	Email string `json:"email" binding:"required"`
}

// ConfirmEmailRequest completes an e-mail change. The address is repeated
// because the mailed code is stored under the address, not under the account.
type ConfirmEmailRequest struct {
	Email string `json:"email" binding:"required"`
	Code  string `json:"code" binding:"required"`
}

// SessionResponse is the login and registration success payload.
type SessionResponse struct {
	AccessToken string       `json:"accessToken"`
	ExpiresAt   time.Time    `json:"expiresAt"`
	User        *models.User `json:"user"`
}

// UserResponse is the profile payload of GET /auth/me.
type UserResponse struct {
	User *models.User `json:"user"`
}

// PterodactylSessionResponse carries the panel session cookie and the target
// URL the browser must be sent to for the passwordless hand-off.
type PterodactylSessionResponse struct {
	Cookie    string `json:"cookie"`
	LoginURL  string `json:"loginUrl"`
	Subdomain string `json:"subdomain"`
}
