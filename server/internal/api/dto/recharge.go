package dto

import (
	"github.com/minoic/peo/server/internal/models"
)

// RechargeByKeyRequest redeems a balance code.
type RechargeByKeyRequest struct {
	Key string `json:"key" binding:"required"`
}

// PreCreateRequest starts an Alipay face-to-face payment for an amount.
type PreCreateRequest struct {
	Amount uint `json:"amount" binding:"required"`
}

// PreCreateResponse hands the client the QR code and the trade number it polls.
type PreCreateResponse struct {
	QRCodeBase64 string `json:"qrCodeBase64"`
	OutTradeNo   string `json:"outTradeNo"`
}

// RechargeStatusResponse reports the state of one Alipay order.
type RechargeStatusResponse struct {
	Status string `json:"status"`
}

// RechargeLogResponse is the recharge history.
type RechargeLogResponse struct {
	Logs []models.RechargeLog `json:"logs"`
}
