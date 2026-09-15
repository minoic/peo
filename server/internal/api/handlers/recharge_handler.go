package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// RechargeHandler serves balance top-ups: activation codes, the Alipay
// face-to-face flow and the Alipay callback.
type RechargeHandler struct{}

// NewRechargeHandler builds the handler.
func NewRechargeHandler() *RechargeHandler { return &RechargeHandler{} }

// Logs returns the top-up history of the caller.
//
// GET /api/v1/recharge/logs
func (h *RechargeHandler) Logs(c *gin.Context) {
	logs, err := service.Recharge.Logs(c.Request.Context(), middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	if logs == nil {
		logs = []models.RechargeLog{}
	}
	ok(c, dto.RechargeLogResponse{Logs: logs})
}

// ByKey redeems a balance activation code.
//
// POST /api/v1/recharge/key
func (h *RechargeHandler) ByKey(c *gin.Context) {
	var req dto.RechargeByKeyRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Recharge.ByKey(c.Request.Context(), middleware.UserID(c), req.Key); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("the balance has been topped up"))
}

// PreCreate starts an Alipay face-to-face payment and returns the QR code.
//
// POST /api/v1/recharge/alipay
func (h *RechargeHandler) PreCreate(c *gin.Context) {
	var req dto.PreCreateRequest
	if !bind(c, &req) {
		return
	}
	qr, tradeNo, err := service.Recharge.PreCreate(c.Request.Context(), middleware.UserID(c), req.Amount)
	if err != nil {
		fail(c, err)
		return
	}
	created(c, dto.PreCreateResponse{QRCodeBase64: qr, OutTradeNo: tradeNo})
}

// Status reports whether a top-up has been credited, which the client polls
// while the QR code is on screen.
//
// GET /api/v1/recharge/alipay/:outTradeNo
func (h *RechargeHandler) Status(c *gin.Context) {
	status, err := service.Recharge.Status(c.Request.Context(), middleware.UserID(c), c.Param("outTradeNo"))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.RechargeStatusResponse{Status: status})
}

// AlipayNotify receives the asynchronous payment callback from Alipay.
//
// This is the one endpoint that does not speak the JSON envelope: the caller is
// Alipay, which expects the literal bodies "success" or "fail". The body is
// form-encoded, and the SDK rejects a notification whose signature does not
// verify, which is the only authentication this route can have.
//
// POST /api/v1/alipay/notify
func (h *RechargeHandler) AlipayNotify(c *gin.Context) {
	client := config.AliClient()
	if client == nil {
		c.String(200, "fail")
		return
	}
	if err := c.Request.ParseForm(); err != nil {
		glgf.Error("alipay: cannot parse the notification form: ", err)
		c.String(200, "fail")
		return
	}
	notify, err := client.DecodeNotification(c.Request.PostForm)
	if err != nil {
		glgf.Error("alipay: the notification signature does not verify: ", err)
		c.String(200, "fail")
		return
	}
	result := service.Recharge.HandleAlipayNotification(c.Request.Context(), notify)
	c.String(200, result)
}
