package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/service"
)

// AuthHandler serves authentication and credential endpoints.
type AuthHandler struct{}

// NewAuthHandler builds the handler.
func NewAuthHandler() *AuthHandler { return &AuthHandler{} }

// Login exchanges credentials for a bearer token.
//
// POST /api/v1/auth/login
func (h *AuthHandler) Login(c *gin.Context) {
	var req dto.LoginRequest
	if !bind(c, &req) {
		return
	}
	s, err := service.Auth.Login(c.Request.Context(), req.Login, req.Password, req.Remember)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, sessionResponse(s))
}

// Logout blacklists the presented token until it would have expired anyway.
//
// POST /api/v1/auth/logout
func (h *AuthHandler) Logout(c *gin.Context) {
	service.RevokeTerminalSessions(middleware.Token(c))
	if err := service.Auth.Logout(c.Request.Context(), middleware.Token(c)); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("signed out"))
}

// Register creates an account. Captcha was removed with the Beego rewrite, so
// the endpoint is protected by the Redis rate limiter keyed on the caller's
// address; the handler supplies it as the `clientKey`.
//
// POST /api/v1/auth/register
func (h *AuthHandler) Register(c *gin.Context) {
	var req dto.RegisterRequest
	if !bind(c, &req) {
		return
	}
	s, err := service.Auth.Register(c.Request.Context(), req.Name, req.Email, req.Password, c.ClientIP())
	if err != nil {
		fail(c, err)
		return
	}
	created(c, sessionResponse(s))
}

// Me returns the profile of the signed-in user.
//
// GET /api/v1/auth/me
func (h *AuthHandler) Me(c *gin.Context) {
	u, err := service.Auth.Me(c.Request.Context(), middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.UserResponse{User: u})
}

// ConfirmEmail consumes a registration confirmation link.
//
// GET /api/v1/auth/confirm-email/:key
func (h *AuthHandler) ConfirmEmail(c *gin.Context) {
	if err := service.Auth.ConfirmRegistration(c.Request.Context(), c.Param("key")); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("e-mail confirmed"))
}

// ForgetPassword mails a reset code. The endpoint always reports success so it
// cannot be used to probe which addresses are registered.
//
// POST /api/v1/auth/forget-password
func (h *AuthHandler) ForgetPassword(c *gin.Context) {
	var req dto.ForgetPasswordRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Auth.ForgetPassword(c.Request.Context(), req.Email); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("if the address is registered a reset code has been sent"))
}

// ResetPassword finishes the reset flow. The address is part of the request
// because the reset code is stored per user id, which the anonymous caller
// cannot know.
//
// POST /api/v1/auth/reset-password
func (h *AuthHandler) ResetPassword(c *gin.Context) {
	var req dto.ResetPasswordRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Auth.ResetPassword(c.Request.Context(), req.Email, req.Code, req.NewPassword); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("password updated"))
}

func sessionResponse(s *service.Session) dto.SessionResponse {
	if s == nil {
		return dto.SessionResponse{}
	}
	return dto.SessionResponse{AccessToken: s.AccessToken, ExpiresAt: s.ExpiresAt, User: s.User}
}
