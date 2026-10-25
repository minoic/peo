package dto

import (
	"github.com/minoic/peo/server/internal/service"
)

// AdminDashboardResponse is the administration landing page aggregate.
type AdminDashboardResponse struct {
	Dashboard *service.Dashboard `json:"dashboard"`
}

// AdminUserListResponse lists every account.
type AdminUserListResponse struct {
	Users []service.AdminUser `json:"users"`
}

// AdminOrderListResponse lists every order.
type AdminOrderListResponse struct {
	Orders []service.AdminOrder `json:"orders"`
}

// AdminProductListResponse lists every specification.
type AdminProductListResponse struct {
	Products []service.AdminProduct `json:"products"`
}

// AdminProductFormResponse describes the fields the product editor renders.
type AdminProductFormResponse struct {
	Fields []service.FormField `json:"fields"`
}

type PanelTag struct {
	ID           int    `json:"id"`
	Name         string `json:"name"`
	Slug         string `json:"slug"`
	LegacyNestID *int   `json:"legacyNestId,omitempty"`
}
type PanelTagListResponse struct {
	Items []PanelTag `json:"items"`
}

// AdminWorkOrderListResponse lists open tickets.
type AdminWorkOrderListResponse struct {
	Orders []service.WorkOrderItem `json:"orders"`
}

// AdminDeleteConfirmListResponse lists servers awaiting deletion approval.
type AdminDeleteConfirmListResponse struct {
	Confirms []service.DeleteConfirmItem `json:"confirms"`
}

// UpdateProductRequest is the product editor payload.
type UpdateProductRequest struct {
	Product service.ProductInput `json:"product" binding:"required"`
}

// CreateProductResponse reports the specification ids created by one submission.
// A single submission produces one document per enabled billing cycle, so this
// is a list.
type CreateProductResponse struct {
	SpecIDs []string `json:"specIds"`
}

// DeleteConfirmRequest approves or rejects a pending server deletion.
type DeleteConfirmRequest struct {
	// Approve true removes the server; false cancels the deletion.
	Approve bool `json:"approve"`
}

// KeyTargetListResponse lists everything a key can be generated for.
type KeyTargetListResponse struct {
	Targets []service.KeyTarget `json:"targets"`
}

// GenerateKeysRequest mints product or balance keys.
type GenerateKeysRequest struct {
	// Target is "all", "balance:all", "spec:<hex>" or "balance:<amount>".
	Target string `json:"target" binding:"required"`
	Amount int    `json:"amount"`
	// ValidityDays overrides the product lifetime, in days.
	ValidityDays int `json:"validityDays"`
}

// GenerateKeysResponse returns the freshly minted key strings.
type GenerateKeysResponse struct {
	Keys []string `json:"keys"`
}

// CloseWorkOrderRequest closes a ticket with an optional public reply.
type CloseWorkOrderRequest struct {
	CloseInfo string `json:"closeInfo"`
}

// AdminSettingsResponse is the schema plus current values of the settings form.
type AdminSettingsResponse struct {
	Fields []service.SettingField `json:"fields"`
}

// SaveSettingsRequest writes a subset of settings back to the TOML file.
type SaveSettingsRequest struct {
	Values map[string]string `json:"values"`
}

// HealthResponse reports component reachability for the admin status page.
type HealthResponse struct {
	Health *service.Health `json:"health"`
}

// GalleryReviewRequest approves a gallery submission.
type GalleryReviewRequest struct {
	ItemID string `json:"itemId" binding:"required"`
}
