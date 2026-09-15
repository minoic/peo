// Package service holds the business rules that used to live inside the Beego
// controllers.
//
// Handlers are kept thin: they decode the request, call one service method and
// encode the envelope. Every decision -- pricing, ordering, provisioning,
// renewal, deletion -- lives here so it can be exercised without an HTTP server
// and reused by the cron jobs.
package service

import (
	"context"
	"errors"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/auth"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/service/email"
	"github.com/minoic/peo/server/internal/service/pterodactyl"
	"github.com/minoic/peo/server/internal/service/random"
	"github.com/minoic/peo/server/internal/store"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// TrialDuration is the hard coded three day trial. Products with this duration
// cost a single unit whatever their monthly price is, exactly as before.
const TrialDuration = 3 * 24 * time.Hour

// Windows for the registration throttle that replaced the captcha.
const (
	registerIPWindow   = time.Hour
	registerNameWindow = 10 * time.Minute
)

// The captcha that used to guard registration, e-mail changes and password
// resets is gone, but the mailed code itself is not: it is still a six digit
// numeric code stored in Redis under the address it was sent to, exactly as
// legacy did. Only the image challenge in front of it was dropped.
const (
	captchaDigits = 6
	captchaTTL    = 30 * time.Minute
)

// mailCodeKey and mailPendingKey are the legacy Redis key families for the
// change-address flow. Legacy stored only the code (user_settings_controller.go
// :144). The address had to be bound to the code somehow because the confirm
// step used to identify the caller by session; the port's confirm call carries
// only the code, so the address is parked next to it under a companion key.
func mailCodeKey(mail string) string    { return "CHANGE_EMAIL" + mail }
func mailPendingKey(mail string) string { return "CHANGE_EMAIL_PENDING:" + mail }

// resetCodeKey is the legacy key holding the password reset code. Legacy used
// "FORGET" + address (forget_password_controller.go:79) for both the reset code
// and its resend throttle, so a resend could not happen inside the code's life;
// the port keeps that behaviour with one key holding the code.
func resetCodeKey(mail string) string { return "FORGET:" + mail }

// AuthService covers registration, login and credential changes.
type AuthService struct{}

// Auth is the default AuthService.
var Auth = AuthService{}

// Session is what a successful login or registration hands back.
type Session struct {
	AccessToken string       `json:"accessToken"`
	ExpiresAt   time.Time    `json:"expiresAt"`
	User        *models.User `json:"user"`
}

// Register creates an account. The first account ever created becomes an
// administrator, matching the legacy bootstrap behaviour. A Pterodactyl mirror
// account is created with the same name and password; a failure there is
// recorded but does not abort the registration.
//
// Captcha was removed with the Beego rewrite; the endpoint is protected by the
// same Redis rate limiter instead. clientKey identifies the caller (the handler
// passes the request IP) and nameKey the requested user name, so a single
// address cannot mass-register and a single name cannot be hammered.
func (AuthService) Register(ctx context.Context, name, mail, password, clientKey string) (*Session, error) {
	if err := auth.ValidateUsername(name); err != nil {
		return nil, apierr.Wrap(apierr.CodeValidationFailed, err.Error(), err)
	}
	if err := auth.ValidateEmail(mail); err != nil {
		return nil, apierr.Wrap(apierr.CodeValidationFailed, err.Error(), err)
	}
	if len(password) < 6 {
		return nil, apierr.Fail(apierr.CodeValidationFailed, "password must be at least 6 characters")
	}
	if clientKey != "" && redis.Limited(ctx, "REGISTER_IP:"+clientKey) {
		return nil, apierr.Fail(apierr.CodeRateLimited, "too many registrations, try again later")
	}
	if redis.Limited(ctx, "REGISTER:"+name) {
		return nil, apierr.Fail(apierr.CodeRateLimited, "too many registrations, try again later")
	}
	if taken, err := store.User.NameTaken(ctx, name); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot check user name", err)
	} else if taken {
		return nil, apierr.Fail(apierr.CodeConflict, "user name is already taken")
	}
	if taken, err := store.User.EmailTaken(ctx, mail); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot check e-mail", err)
	} else if taken {
		return nil, apierr.Fail(apierr.CodeConflict, "e-mail is already registered")
	}
	// The window is only opened once the input passed validation, so a user who
	// mistypes their password is not locked out.
	if clientKey != "" {
		redis.Limit(ctx, "REGISTER_IP:"+clientKey, registerIPWindow)
	}
	redis.Limit(ctx, "REGISTER:"+name, registerNameWindow)

	total, err := store.User.Count(ctx)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot count users", err)
	}
	u := &models.User{
		Name:     name,
		Email:    mail,
		Password: auth.HashPassword(password),
		IsAdmin:  total == 0,
		UUID:     random.UUID(),
	}
	if err := store.User.Create(ctx, u); err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot create user", err)
	}

	// The panel mirror is best effort: an unreachable panel must not stop a
	// user from signing up, they can retry from the settings page.
	cli := pterodactyl.ClientFromConf()
	created := false
	// The panel identifies a customer by their username, exactly as legacy did
	// (reg_controller.go:106): ExternalId, Username and Password are all the
	// name, and the first registrant of an empty database is a panel root
	// admin. Both facts are part of the panel contract the spec keeps frozen.
	if err := cli.CreateUser(ctx, pterodactyl.PostPteUser{
		ExternalId: u.Name,
		Username:   u.Name,
		Email:      u.Email,
		Password:   u.Name,
		Language:   "zh",
		RootAdmin:  u.IsAdmin,
		FirstName:  u.Name,
		LastName:   "_",
	}); err != nil {
		glgf.Error("cannot create pterodactyl user for " + u.Name + ": " + err.Error())
	} else {
		created = true
	}
	if err := store.User.MarkPteCreated(ctx, u.ID, created); err != nil {
		glgf.Error("cannot persist PteUserCreated for " + u.Name + ": " + err.Error())
	}
	if created {
		if err := store.PtePassword.Upsert(ctx, u.ID, u.Name); err != nil {
			glgf.Error("cannot cache panel password for " + u.Name + ": " + err.Error())
		}
	}
	return issue(u, false)
}

// Login verifies credentials and returns a session. The login field accepts
// either the user name or the e-mail address.
func (AuthService) Login(ctx context.Context, login, password string, remember bool) (*Session, error) {
	if login == "" || password == "" {
		return nil, apierr.Fail(apierr.CodeValidationFailed, "login and password are required")
	}
	if redis.Limited(ctx, "LOGIN:"+login) {
		return nil, apierr.Fail(apierr.CodeRateLimited, "too many attempts, try again later")
	}
	u, err := store.User.ByNameOrEmail(ctx, login)
	if err != nil {
		if store.IsNotFound(err) {
			// The rate limit is applied to failures only, so a successful
			// login never counts against the user.
			redis.Limit(ctx, "LOGIN:"+login, time.Minute)
			return nil, apierr.Fail(apierr.CodeUnauthorized, "wrong user name or password")
		}
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot look user up", err)
	}
	if !auth.CheckPassword(u.Password, password) {
		redis.Limit(ctx, "LOGIN:"+login, time.Minute)
		return nil, apierr.Fail(apierr.CodeUnauthorized, "wrong user name or password")
	}
	return issue(u, remember)
}

// Logout revokes the presented token until its natural expiry. Without this a
// stolen token stays valid for its whole lifetime.
func (AuthService) Logout(ctx context.Context, token string) error {
	claims, err := auth.ParseToken(token)
	if err != nil {
		return nil
	}
	ttl := time.Until(claims.Expires)
	if ttl <= 0 {
		return nil
	}
	if err := redis.Set(ctx, auth.TokenBlacklistKey(claims.ID), "1", ttl); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot revoke token", err)
	}
	return nil
}

// Me returns the account behind the current token.
func (AuthService) Me(ctx context.Context, userID bson.ObjectID) (*models.User, error) {
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	return u, nil
}

// ChangePassword rotates the credential after verifying the old one.
func (AuthService) ChangePassword(ctx context.Context, userID bson.ObjectID, oldPassword, newPassword string) error {
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	if !auth.CheckPassword(u.Password, oldPassword) {
		return apierr.Fail(apierr.CodeValidationFailed, "current password is wrong")
	}
	if len(newPassword) < 6 {
		return apierr.Fail(apierr.CodeValidationFailed, "new password must be at least 6 characters")
	}
	if err := store.User.SetPassword(ctx, userID, auth.HashPassword(newPassword)); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot save password", err)
	}
	return nil
}

// ChangeEmail mails a confirmation code to the new address. The address is only
// written once that code comes back, which is the legacy two-step flow
// (user_settings_controller.go:133 SendCaptcha, :108 UpdateUserEmail).
func (AuthService) ChangeEmail(ctx context.Context, userID bson.ObjectID, newEmail string) error {
	if err := auth.ValidateEmail(newEmail); err != nil {
		return apierr.Wrap(apierr.CodeValidationFailed, err.Error(), err)
	}
	if taken, err := store.User.EmailTaken(ctx, newEmail); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot check e-mail", err)
	} else if taken {
		return apierr.Fail(apierr.CodeConflict, "e-mail is already registered")
	}
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	if u.Email == newEmail {
		return apierr.Fail(apierr.CodeValidationFailed, "that is already your e-mail address")
	}
	// One code per pending address while it is alive, matching the "FORGET" and
	// "CHANGE_EMAIL" keys which could not be rewritten before they expired.
	if redis.Limited(ctx, mailCodeKey(newEmail)) {
		return apierr.Fail(apierr.CodeRateLimited, "confirmation e-mail already sent, try again later")
	}
	code := random.Digits(captchaDigits)
	if err := redis.Set(ctx, mailCodeKey(newEmail), code, captchaTTL); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot store confirmation code", err)
	}
	if err := redis.Set(ctx, mailPendingKey(newEmail), userID.Hex(), captchaTTL); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot store pending address", err)
	}
	if err := email.SendCaptcha(newEmail, code); err != nil {
		// Neither key may outlive a send that never happened, or the address is
		// throttled against a code nobody received.
		redis.Release(ctx, mailCodeKey(newEmail))
		redis.Release(ctx, mailPendingKey(newEmail))
		return apierr.Wrap(apierr.CodeInternal, "cannot send confirmation e-mail", err)
	}
	return nil
}

// ConfirmEmailChange validates the mailed code and applies the new address.
func (AuthService) ConfirmEmailChange(ctx context.Context, userID bson.ObjectID, newEmail, code string) error {
	if newEmail == "" {
		return apierr.Fail(apierr.CodeValidationFailed, "the new e-mail address is required")
	}
	want, ok := redis.Get(ctx, mailCodeKey(newEmail))
	if !ok {
		return apierr.Fail(apierr.CodeValidationFailed, "the confirmation code has expired")
	}
	if want != code {
		return apierr.Fail(apierr.CodeValidationFailed, "confirmation code is wrong")
	}
	owner, ok := redis.Get(ctx, mailPendingKey(newEmail))
	if !ok {
		return apierr.Fail(apierr.CodeValidationFailed, "the confirmation code has expired")
	}
	// The code is addressed to the address, not to the caller, so a code
	// obtained by another account must not be usable here.
	if owner != userID.Hex() {
		return apierr.Fail(apierr.CodeForbidden, "this code belongs to another account")
	}
	if err := store.User.SetEmail(ctx, userID, newEmail, true); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot save e-mail", err)
	}
	redis.Del(ctx, mailCodeKey(newEmail), mailPendingKey(newEmail))
	return nil
}

// EnsurePterodactylUser creates the panel mirror account on demand.
func (AuthService) EnsurePterodactylUser(ctx context.Context, userID bson.ObjectID) error {
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	if u.PteUserCreated {
		return nil
	}
	cli := pterodactyl.ClientFromConf()
	// An account may already exist with this name (for instance from a manual
	// import); treat that as success and refresh the cached password instead.
	if _, err := cli.GetUser(ctx, u.Name); err != nil {
		if err := cli.CreateUser(ctx, pterodactyl.PostPteUser{
			ExternalId: u.Name,
			Username:   u.Name,
			Email:      u.Email,
			Password:   u.Name,
			Language:   "zh",
			RootAdmin:  u.IsAdmin,
			FirstName:  u.Name,
			LastName:   "_",
		}); err != nil {
			return apierr.Wrap(apierr.CodePterodactylError, "cannot create panel account", err)
		}
	}
	if err := store.PtePassword.Upsert(ctx, u.ID, u.Name); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot cache panel password", err)
	}
	if err := store.User.MarkPteCreated(ctx, u.ID, true); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot persist panel account state", err)
	}
	return nil
}

// ForgetPassword starts the reset flow. The response is intentionally identical
// whether or not the address exists, so the endpoint cannot be used to probe
// which addresses are registered.
func (AuthService) ForgetPassword(ctx context.Context, mail string) error {
	// An unknown address is answered exactly like a known one so the endpoint
	// cannot be used to enumerate accounts.
	if _, err := store.User.ByEmail(ctx, mail); err != nil {
		glgf.Info("forget password requested for unknown address " + mail)
		return nil
	}
	// One reset code per address while it is alive. The code expires only by
	// TTL, so no email can be sent while the caller still knows the old one
	// (legacy forget_password_controller.go:79).
	if redis.Limited(ctx, resetCodeKey(mail)) {
		return nil
	}
	code := random.Digits(captchaDigits)
	if err := redis.Set(ctx, resetCodeKey(mail), code, captchaTTL); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot store reset code", err)
	}
	if err := email.SendCaptcha(mail, code); err != nil {
		// The code is only useful if it arrived. Legacy set the key before the
		// send as well, but swallowed the send error, so a broken SMTP relay
		// locked the address out of the reset flow for the whole key lifetime.
		redis.Release(ctx, resetCodeKey(mail))
		return apierr.Wrap(apierr.CodeInternal, "cannot send reset e-mail", err)
	}
	return nil
}

// ResetPassword finishes the flow started by ForgetPassword. The address is
// supplied by the anonymous caller, which cannot know its user id, so the user
// is resolved here; an unknown address is reported with the same message as a
// wrong code so the endpoint cannot be used to enumerate accounts.
func (AuthService) ResetPassword(ctx context.Context, mail, code, newPassword string) error {
	u, err := store.User.ByEmail(ctx, mail)
	if err != nil {
		return apierr.Fail(apierr.CodeValidationFailed, "reset code is wrong or expired")
	}
	return AuthService{}.ResetPasswordFor(ctx, u.ID, mail, code, newPassword)
}

// ResetPasswordFor is ResetPassword keyed by an already resolved user. The
// address is still needed because the code lives under it.
func (AuthService) ResetPasswordFor(ctx context.Context, userID bson.ObjectID, mail, code, newPassword string) error {
	want, ok := redis.Get(ctx, resetCodeKey(mail))
	if !ok || want != code {
		return apierr.Fail(apierr.CodeValidationFailed, "reset code is wrong or expired")
	}
	if len(newPassword) < 6 {
		return apierr.Fail(apierr.CodeValidationFailed, "password must be at least 6 characters")
	}
	if err := store.User.SetPassword(ctx, userID, auth.HashPassword(newPassword)); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot save password", err)
	}
	redis.Del(ctx, resetCodeKey(mail))
	return nil
}

// ConfirmRegistration consumes a registration confirmation key.
func (AuthService) ConfirmRegistration(ctx context.Context, key string) error {
	info, err := email.ConfirmKey(ctx, key)
	if err != nil {
		if errors.Is(err, email.ErrExpiredKey) {
			if delErr := store.RegConfirm.Delete(ctx, info.ID); delErr != nil {
				glgf.Error("cannot delete expired confirmation key: " + delErr.Error())
			}
			return apierr.Fail(apierr.CodeValidationFailed, "confirmation link has expired")
		}
		return apierr.Wrap(apierr.CodeNotFound, "confirmation link is invalid", err)
	}
	if err := store.User.ConfirmEmail(ctx, info.UserID); err != nil {
		return apierr.Wrap(apierr.CodeInternal, "cannot confirm e-mail", err)
	}
	if err := store.RegConfirm.Delete(ctx, info.ID); err != nil {
		glgf.Error("cannot delete used confirmation key: " + err.Error())
	}
	return nil
}

// issue builds a session for a freshly authenticated user.
func issue(u *models.User, remember bool) (*Session, error) {
	token, err := auth.GenerateToken(u.Name, u.ID.Hex(), u.IsAdmin, remember)
	if err != nil {
		return nil, apierr.Wrap(apierr.CodeInternal, "cannot issue token", err)
	}
	ttl := auth.ShortTokenTTL
	if remember {
		ttl = auth.LongTokenTTL
	}
	return &Session{AccessToken: token, ExpiresAt: time.Now().Add(ttl), User: u}, nil
}

// PterodactylSession hands a logged-in user over to the panel without asking
// for the password again, by planting the panel session cookie on the shared
// parent domain.
func (AuthService) PterodactylSession(ctx context.Context, userID bson.ObjectID) (string, string, error) {
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return "", "", apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	pw := u.Name
	if cached, err := store.PtePassword.ByUser(ctx, u.ID); err == nil && cached.Password != "" {
		pw = cached.Password
	}
	session, err := pterodactyl.ClientFromConf().Login(ctx, u.Email, pw)
	if err != nil {
		return "", "", apierr.Wrap(apierr.CodePterodactylError, "cannot sign in to the panel", err)
	}
	domain := config.SiteSubdomain()
	host := config.String("PterodactylHostname")
	if host == "" {
		return "", "", apierr.Fail(apierr.CodeInternal, "PterodactylHostname is not configured")
	}
	return session, domain, nil
}
