package dto

import (
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// CreateOrderRequest names the specification the customer wants to buy. The
// allocation is picked on the payment screen, so it is not part of creation.
type CreateOrderRequest struct {
	SpecID string `json:"specId" binding:"required"`
}

// OrderResponse is a plain order document.
type OrderResponse struct {
	Order *models.Order `json:"order"`
}

// OrderListResponse is the customer's order history.
type OrderListResponse struct {
	Orders []models.Order `json:"orders"`
}

// PayOrderRequest carries the allocation, the desired host name and, for the
// key flow, the product key.
type PayOrderRequest struct {
	// AllocationID is the Pterodactyl allocation the server should bind to.
	AllocationID int `json:"allocationId"`
	// HostName is the label the customer chose for the server.
	HostName string `json:"hostName" binding:"required"`
	// Key is optional; when empty the balance flow is used.
	Key string `json:"key"`
}

// ServerListResponse is the customer console list.
type ServerListResponse struct {
	Servers []models.WareEntity `json:"servers"`
}

// ServerDetailResponse is one managed server record.
type ServerDetailResponse struct {
	Server *models.WareEntity `json:"server"`
}

// StatusListResponse is the polled live status list.
type StatusListResponse struct {
	Servers []service.Status `json:"servers"`
}

// RenewRequest renews with a product key.
type RenewRequest struct {
	// Key is the product key; the legacy URL carried it as a path segment.
	Key string `json:"key" binding:"required"`
}

// ReinstallRequest picks the egg to reinstall with.
type ReinstallRequest struct {
	EggID int `json:"eggId" binding:"required"`
}

// Allocation is one free port on the node the ordered product is pinned to.
type Allocation struct {
	ID int `json:"id"`
	// Address is the `alias:port` label the customer picks from.
	Address string `json:"address"`
}

// AllocationListResponse lists the free allocations of the product's node, for
// the payment screen's address picker.
type AllocationListResponse struct {
	Allocations []Allocation `json:"allocations"`
}
