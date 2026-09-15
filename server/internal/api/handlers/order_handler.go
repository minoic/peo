package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/apierr"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// OrderHandler serves the purchase flow: create, inspect, list and pay.
type OrderHandler struct{}

// NewOrderHandler builds the handler.
func NewOrderHandler() *OrderHandler { return &OrderHandler{} }

// Create opens a pending order for a product. The legacy flow was a GET on
// `/new-order?specID=` that redirected to the order page; a REST client creates
// the order and then navigates to it.
//
// POST /api/v1/orders
func (h *OrderHandler) Create(c *gin.Context) {
	var req dto.CreateOrderRequest
	if !bind(c, &req) {
		return
	}
	specID, err := models.ObjectIDFromHex(req.SpecID)
	if err != nil {
		badParam(c, "product id")
		return
	}
	o, err := service.Order.Create(c.Request.Context(), specID, middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	created(c, dto.OrderResponse{Order: o})
}

// ByID returns one order.
//
// GET /api/v1/orders/:id
func (h *OrderHandler) ByID(c *gin.Context) {
	orderID, valid := idParam(c, "id", "order")
	if !valid {
		return
	}
	o, err := service.Order.ByID(c.Request.Context(), orderID, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.OrderResponse{Order: o})
}

// List returns the caller's order history.
//
// GET /api/v1/orders
func (h *OrderHandler) List(c *gin.Context) {
	orders, err := service.Order.ListByUser(c.Request.Context(), middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	if orders == nil {
		orders = []models.Order{}
	}
	ok(c, dto.OrderListResponse{Orders: orders})
}

// Pay redeems a product key for the order. The product key stays in the body
// rather than the URL so it does not end up in access logs.
//
// POST /api/v1/orders/:id/pay
func (h *OrderHandler) Pay(c *gin.Context) {
	orderID, valid := idParam(c, "id", "order")
	if !valid {
		return
	}
	var req dto.PayOrderRequest
	if !bind(c, &req) {
		return
	}
	if req.AllocationID <= 0 {
		badParam(c, "server address")
		return
	}
	if req.Key == "" {
		apierr.Abort(c, apierr.Fail(apierr.CodeInvalidKey, "activation code is required"))
		return
	}
	err := service.Order.PayWithKey(c.Request.Context(), orderID, middleware.UserID(c), req.Key, req.AllocationID, req.HostName)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("order paid, the server is being created"))
}

// PayByBalance pays the order from the account balance.
//
// POST /api/v1/orders/:id/pay-by-balance
func (h *OrderHandler) PayByBalance(c *gin.Context) {
	orderID, valid := idParam(c, "id", "order")
	if !valid {
		return
	}
	var req dto.PayOrderRequest
	if !bind(c, &req) {
		return
	}
	if req.AllocationID <= 0 {
		badParam(c, "server address")
		return
	}
	err := service.Order.PayWithBalance(c.Request.Context(), orderID, middleware.UserID(c), req.AllocationID, req.HostName)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("order paid, the server is being created"))
}
