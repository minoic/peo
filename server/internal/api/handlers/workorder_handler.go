package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// WorkOrderHandler serves the customer side of the support tickets.
type WorkOrderHandler struct{}

// NewWorkOrderHandler builds the handler.
func NewWorkOrderHandler() *WorkOrderHandler { return &WorkOrderHandler{} }

// List returns the tickets opened by the caller.
//
// GET /api/v1/work-orders
func (h *WorkOrderHandler) List(c *gin.Context) {
	orders, err := service.WorkOrders.ListMine(c.Request.Context(), middleware.UserID(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.WorkOrderListResponse{Orders: workOrderItems(orders)})
}

// Create opens a ticket for the caller.
//
// POST /api/v1/work-orders
func (h *WorkOrderHandler) Create(c *gin.Context) {
	var req dto.CreateWorkOrderRequest
	if !bind(c, &req) {
		return
	}
	order, err := service.WorkOrders.Create(c.Request.Context(), middleware.UserID(c), req.Title, req.Text)
	if err != nil {
		fail(c, err)
		return
	}
	created(c, dto.WorkOrderResponse{Order: workOrderItem(order)})
}

// workOrderItems converts stored tickets into the shared wire shape.
func workOrderItems(orders []models.WorkOrder) []service.WorkOrderItem {
	return service.WorkOrderItems(orders)
}

// workOrderItem converts a single stored ticket.
func workOrderItem(o *models.WorkOrder) service.WorkOrderItem {
	if o == nil {
		return service.WorkOrderItem{}
	}
	return service.WorkOrderItems([]models.WorkOrder{*o})[0]
}
