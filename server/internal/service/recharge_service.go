package service

import (
	"context"
	"encoding/base64"
	"errors"
	"math"
	"strconv"
	"strings"
	"time"

	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/redis"
	"github.com/minoic/peo/server/internal/service/message"
	"github.com/minoic/peo/server/internal/service/random"
	"github.com/minoic/peo/server/internal/store"
	"github.com/skip2/go-qrcode"
	"github.com/smartwalle/alipay/v3"
	"go.mongodb.org/mongo-driver/v2/bson"
)

// Recharge cooldowns and limits.
const (
	// keyCooldown throttles balance top-ups by code, matching the legacy three
	// second window.
	keyCooldown = 3 * time.Second
)

// Recharge status values recorded on a RechargeLog. The legacy column held a
// rendered Bootstrap badge; the stored value is now data, and the client renders
// the badge.
const (
	// RechargePending is a top-up that was started but not yet settled. It
	// replaces the legacy "unpaid" badge on an Alipay trade.
	RechargePending = "pending"
	// RechargeSuccess is a settled top-up, whether by code or by Alipay.
	RechargeSuccess = "success"
	// RechargeFailed is a top-up that was accepted and then failed halfway
	// through, for example because the balance could not be written.
	RechargeFailed = "failed"
	// RechargeInvalid is a top-up rejected before anything was attempted: an
	// unknown or expired code. The legacy history distinguished this from
	// `failed` and the distinction is worth keeping, because "the code was
	// wrong" and "the site broke" call for different support answers.
	RechargeInvalid = "invalid"
)

// RechargeService covers balance top-ups, by code and by Alipay.
type RechargeService struct{}

// Recharge is the default RechargeService.
var Recharge = RechargeService{}

// AlipayEnabled reports whether face-to-face Alipay is configured. The client
// hides the QR tab when it is not.
func (RechargeService) AlipayEnabled() bool { return config.AliClient() != nil }

func balanceDelta(amount uint) (int64, error) {
	if uint64(amount) > math.MaxInt64 {
		return 0, errors.New("amount exceeds signed balance range")
	}
	return int64(amount), nil
}

func parseAlipayAmount(raw string) (uint, error) {
	parts := strings.Split(raw, ".")
	if len(parts) > 2 || parts[0] == "" {
		return 0, errors.New("invalid amount")
	}
	whole, err := strconv.ParseUint(parts[0], 10, 64)
	if err != nil || whole > uint64(math.MaxUint)/100 {
		return 0, errors.New("invalid amount")
	}
	cents := uint64(0)
	if len(parts) == 2 {
		fraction := parts[1]
		if len(fraction) == 1 {
			fraction += "0"
		}
		if len(fraction) != 2 {
			return 0, errors.New("invalid amount")
		}
		cents, err = strconv.ParseUint(fraction, 10, 8)
		if err != nil {
			return 0, errors.New("invalid amount")
		}
	}
	if cents != 0 || uint64(uint(whole)) != whole {
		return 0, errors.New("Alipay amount must match whole-unit account balance")
	}
	return uint(whole), nil
}

// Logs returns the top-up history of a user, newest first.
func (RechargeService) Logs(ctx context.Context, userID bson.ObjectID) ([]models.RechargeLog, error) {
	return store.RechargeLog.ByUser(ctx, userID)
}

// ByKey redeems a balance top-up code.
//
// The code is atomically assigned to this user and the balance update carries
// that code's stable operation ID. The claimed code remains recoverable if the
// process stops between crediting the balance and deleting the code.
func (RechargeService) ByKey(ctx context.Context, userID bson.ObjectID, keyString string) error {
	u, err := store.User.ByID(ctx, userID)
	if err != nil {
		return apierr.Wrap(apierr.CodeNotFound, "user not found", err)
	}
	// The cool-down is keyed on the username, matching legacy
	// (user_recharge_controller.go:63); the session user is resolved first for
	// the same reason legacy did it first.
	limitKey := "RECHARGE_DELAY" + u.Name
	if redis.Limited(ctx, limitKey) {
		return apierr.Fail(apierr.CodeRateLimited, "3 seconds cool down")
	}
	redis.Limit(ctx, limitKey, keyCooldown)

	key, err := store.RKey.ByString(ctx, keyString)
	if err != nil {
		Recharge.log(ctx, userID, "FAILED_ByKEY_"+keyString, "cdkey", 0, RechargeInvalid)
		return apierr.Wrap(apierr.CodeInvalidKey, "invalid KEY", err)
	}
	if key.Exp.Before(time.Now()) {
		Recharge.log(ctx, userID, "FAILED_ByKEY_EXPIRED_"+keyString, "cdkey", 0, RechargeInvalid)
		return apierr.Fail(apierr.CodeInvalidKey, "invalid KEY")
	}
	claimed, err := store.RKey.Claim(ctx, key.ID, "recharge-key:"+key.ID.Hex(), u.ID, time.Now())
	if err != nil {
		return apierr.Wrap(apierr.CodeInvalidKey, "invalid KEY", err)
	}
	delta, err := balanceDelta(key.Balance)
	if err != nil {
		return apierr.Wrap(apierr.CodeValidationFailed, "recharge amount exceeds supported balance", err)
	}
	_, err = store.User.ApplyBalanceOnce(ctx, u.ID, "recharge-key:"+claimed.ID.Hex(), delta)
	if err != nil {
		Recharge.log(ctx, userID, "FAILED_ByKEY_"+keyString, "cdkey", 0, RechargeFailed)
		return apierr.Wrap(apierr.CodeInternal, "database error", err)
	}
	if err := store.RKey.Delete(ctx, key.ID); err != nil {
		glgf.Error("recharge: cannot delete claimed recharge code " + key.ID.Hex() + ": " + err.Error())
		return apierr.Wrap(apierr.CodeInternal, "database error", err)
	}
	Recharge.log(ctx, userID,
		"ByKEY_"+key.KeyString,
		"cdkey", key.Balance, RechargeSuccess)
	glgf.Info("recharge: " + u.Name + " redeemed " + key.KeyString + " for " + strconv.FormatUint(uint64(key.Balance), 10))
	return nil
}

// PreCreate starts an Alipay face-to-face payment and returns the QR code as a
// base64 encoded PNG plus the trade number the client may quote when asking
// whether the top-up has landed.
func (RechargeService) PreCreate(ctx context.Context, userID bson.ObjectID, amount uint) (qrBase64, tradeNo string, err error) {
	settings := config.Snapshot()
	client := settings.AliClient()
	if client == nil {
		return "", "", apierr.Fail(apierr.CodeForbidden, "Alipay top-up is not enabled")
	}
	if amount == 0 {
		return "", "", apierr.Fail(apierr.CodeValidationFailed, "the top-up amount must be greater than 0")
	}
	host := settings.String("WebHostName")
	if host == "" {
		return "", "", apierr.Fail(apierr.CodeInternal, "WebHostName is not configured")
	}
	tradeNo, err = random.Digits(16)
	if err != nil {
		return "", "", apierr.Wrap(apierr.CodeInternal, "cannot create payment reference", err)
	}
	p := alipay.TradePreCreate{}
	p.NotifyURL = host + "/api/v1/alipay/notify"
	p.Subject = settings.String("WebApplicationName") + " balance top-up"
	p.OutTradeNo = tradeNo
	p.TotalAmount = strconv.FormatUint(uint64(amount), 10)

	log := &models.RechargeLog{
		UserID:       userID,
		Code:         "ByZFB_" + tradeNo + "_Waiting",
		Method:       "Alipay",
		Balance:      amount,
		OutTradeNo:   tradeNo,
		PaymentAppID: settings.String("AliPayAppID"),
		Time:         time.Now().Format("2006-01-02 15:04:05"),
		Status:       RechargePending,
	}
	if err := store.RechargeLog.Create(ctx, log); err != nil {
		return "", "", apierr.Wrap(apierr.CodeInternal, "cannot record the top-up", err)
	}
	resp, err := client.TradePreCreate(p)
	if err != nil {
		_ = store.RechargeLog.MarkPaid(ctx, log.ID, RechargeFailed)
		return "", "", apierr.Wrap(apierr.CodePterodactylError, "cannot create the Alipay order", err)
	}
	if resp.QRCode == "" {
		_ = store.RechargeLog.MarkPaid(ctx, log.ID, RechargeFailed)
		return "", "", apierr.Fail(apierr.CodeInternal, "Alipay did not return a QR code")
	}
	img, err := qrcode.Encode(resp.QRCode, qrcode.High, 256)
	if err != nil {
		return "", "", apierr.Wrap(apierr.CodeInternal, "cannot render the QR code", err)
	}
	return base64.StdEncoding.EncodeToString(img), tradeNo, nil
}

// Status reports whether an Alipay top-up has been credited. The client polls
// this after showing the QR code instead of guessing from a timer.
func (RechargeService) Status(ctx context.Context, userID bson.ObjectID, tradeNo string) (string, error) {
	log, err := store.RechargeLog.ByTradeNo(ctx, tradeNo)
	if err != nil {
		return "", apierr.Wrap(apierr.CodeNotFound, "top-up not found", err)
	}
	if log.UserID != userID {
		return "", apierr.Fail(apierr.CodeForbidden, "this top-up belongs to another account")
	}
	return log.Status, nil
}

// HandleAlipayNotification processes the asynchronous callback from Alipay.
//
// The callback is unauthenticated by nature, so it is authenticated the only way
// the protocol allows: Alipay signs the body and the SDK verifies that
// signature before this function is reached. A notification is then matched to a
// stored top-up by trade number. The legacy implementation re-matched the record
// by rewriting its code string inside a database update; here a durable
// processing claim and a user-side operation receipt make retries idempotent.
//
// The returned string is the literal body the Alipay protocol expects; it is not
// a JSON envelope because the caller here is Alipay, not the Flutter app.
func (RechargeService) HandleAlipayNotification(ctx context.Context, notify *alipay.Notification) string {
	if notify.TradeStatus != alipay.TradeStatusSuccess {
		glgf.Warn("recharge: alipay status ", string(notify.TradeStatus), " for ", notify.OutTradeNo)
		return "fail"
	}
	log, err := store.RechargeLog.ByTradeNo(ctx, notify.OutTradeNo)
	if err != nil {
		glgf.Error("recharge: unknown trade number " + notify.OutTradeNo + ": " + err.Error())
		return "fail"
	}
	amount, amountErr := parseAlipayAmount(notify.TotalAmount)
	expectedAppID := log.PaymentAppID
	if expectedAppID == "" {
		if log.Status != RechargeSuccess {
			glgf.Error("recharge: legacy Alipay trade requires reconciliation before settlement: " + notify.OutTradeNo)
			return "fail"
		}
		expectedAppID = config.Snapshot().String("AliPayAppID")
	}
	if amountErr != nil || amount != log.Balance || notify.AppId != expectedAppID || log.Method != "Alipay" || log.OutTradeNo == "" {
		glgf.Error("recharge: Alipay trade binding mismatch for " + notify.OutTradeNo)
		return "fail"
	}
	if log.Status == RechargeSuccess {
		return "success"
	}
	claimed, err := store.RechargeLog.ClaimSettlement(ctx, log.ID, time.Now())
	if err != nil || !claimed {
		if err != nil {
			glgf.Error("recharge: cannot claim settlement for " + notify.OutTradeNo + ": " + err.Error())
		}
		return "fail"
	}
	u, err := store.User.ByID(ctx, log.UserID)
	if err != nil {
		glgf.Error("recharge: cannot load user " + log.UserID.Hex() + ": " + err.Error())
		return "fail"
	}
	if err := settleAlipayLog(ctx, log, u); err != nil {
		glgf.Error("recharge: cannot settle " + log.OutTradeNo + ": " + err.Error())
		return "fail"
	}
	glgf.Info("recharge: " + u.Name + " topped up " + strconv.FormatUint(uint64(log.Balance), 10))
	message.SendToAdmins(ctx, message.Compose(
		"User ", u.Name, " (", u.Email, ") topped up ", strconv.FormatUint(uint64(log.Balance), 10), " CNY"))
	return "success"
}

func settleAlipayLog(ctx context.Context, log *models.RechargeLog, user *models.User) error {
	delta, err := balanceDelta(log.Balance)
	if err != nil {
		return err
	}
	if _, err := store.User.ApplyBalanceOnce(ctx, user.ID, "alipay:"+log.ID.Hex(), delta); err != nil {
		return err
	}
	if err := store.RechargeLog.SetCode(ctx, log.ID, "ByZFB_"+log.OutTradeNo+"_Finished"); err != nil {
		return err
	}
	return store.RechargeLog.MarkPaid(ctx, log.ID, RechargeSuccess)
}

// log records a top-up attempt for the history list.
func (RechargeService) log(ctx context.Context, userID bson.ObjectID, code, method string, balance uint, status string) {
	l := &models.RechargeLog{
		UserID:  userID,
		Code:    code,
		Method:  method,
		Balance: balance,
		Time:    time.Now().Format("2006-01-02 15:04:05"),
		Status:  status,
	}
	if err := store.RechargeLog.Create(ctx, l); err != nil {
		glgf.Error("recharge: cannot record log entry: " + err.Error())
	}
}
