package handlers

import (
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/service"
)

// AdminHandler serves the back office. Every route under /admin is mounted
// behind middleware.Admin(), so no handler repeats the privilege check.
type AdminHandler struct{}

// NewAdminHandler builds the handler.
func NewAdminHandler() *AdminHandler { return &AdminHandler{} }

// Dashboard returns the counters and the three moderation lists.
//
// GET /api/v1/admin/dashboard
func (h *AdminHandler) Dashboard(c *gin.Context) {
	d, err := service.Admin.Dashboard(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.AdminDashboardResponse{Dashboard: d})
}

// Users lists every account.
//
// GET /api/v1/admin/users
func (h *AdminHandler) Users(c *gin.Context) {
	users, err := service.Admin.Users(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if users == nil {
		users = []service.AdminUser{}
	}
	ok(c, dto.AdminUserListResponse{Users: users})
}

// Orders lists every order.
//
// GET /api/v1/admin/orders
func (h *AdminHandler) Orders(c *gin.Context) {
	orders, err := service.Admin.Orders(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if orders == nil {
		orders = []service.AdminOrder{}
	}
	ok(c, dto.AdminOrderListResponse{Orders: orders})
}

// Products lists every product definition.
//
// GET /api/v1/admin/products
func (h *AdminHandler) Products(c *gin.Context) {
	products, err := service.Admin.ProductList(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if products == nil {
		products = []service.AdminProduct{}
	}
	ok(c, dto.AdminProductListResponse{Products: products})
}

// ProductForm returns the descriptor of the product editor. The legacy code
// rendered this form server side; the client now renders the same schema.
//
// GET /api/v1/admin/products/form
func (h *AdminHandler) ProductForm(c *gin.Context) {
	ok(c, dto.AdminProductFormResponse{Fields: service.Admin.ProductForm()})
}

// CreateProduct writes one product per enabled billing cycle.
//
// POST /api/v1/admin/products
func (h *AdminHandler) CreateProduct(c *gin.Context) {
	var req dto.UpdateProductRequest
	if !bind(c, &req) {
		return
	}
	ids, err := service.Admin.CreateProduct(c.Request.Context(), req.Product)
	if err != nil {
		fail(c, err)
		return
	}
	created(c, dto.CreateProductResponse{SpecIDs: ids})
}

// UpdateProduct rewrites one product definition.
//
// PUT /api/v1/admin/products/:specId
func (h *AdminHandler) UpdateProduct(c *gin.Context) {
	specID, valid := idParam(c, "specId", "product")
	if !valid {
		return
	}
	var req dto.UpdateProductRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Admin.UpdateProduct(c.Request.Context(), specID, req.Product); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("product saved"))
}

// DeleteProduct removes one product definition.
//
// DELETE /api/v1/admin/products/:specId
func (h *AdminHandler) DeleteProduct(c *gin.Context) {
	specID, valid := idParam(c, "specId", "product")
	if !valid {
		return
	}
	if err := service.Admin.DeleteProduct(c.Request.Context(), specID); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("product deleted"))
}

// KeyTargets lists everything an activation code can be generated for.
//
// GET /api/v1/admin/key-targets
func (h *AdminHandler) KeyTargets(c *gin.Context) {
	targets, err := service.Admin.KeyTargets(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if targets == nil {
		targets = []service.KeyTarget{}
	}
	ok(c, dto.KeyTargetListResponse{Targets: targets})
}

// GenerateKeys mints activation codes. The codes are not returned: the legacy
// flow read them from a separate page, so the client reloads the export.
//
// POST /api/v1/admin/keys
func (h *AdminHandler) GenerateKeys(c *gin.Context) {
	var req dto.GenerateKeysRequest
	if !bind(c, &req) {
		return
	}
	err := service.Admin.GenerateKeys(c.Request.Context(), req.Target, req.Amount, req.ValidityDays)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("activation codes created"))
}

// ExportKeys streams every activation code as a zip archive. The response is a
// file, not a JSON envelope, because that is what the operator downloads.
//
// GET /api/v1/admin/keys/export
func (h *AdminHandler) ExportKeys(c *gin.Context) {
	archive, err := service.Admin.ExportKeys(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	c.Header("Content-Disposition", `attachment; filename="peo-keys.zip"`)
	c.Data(200, "application/zip", archive)
}

// DeleteConfirms lists the servers waiting for a deletion decision.
//
// GET /api/v1/admin/delete-confirms
func (h *AdminHandler) DeleteConfirms(c *gin.Context) {
	confirms, err := service.Admin.DeleteConfirms(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if confirms == nil {
		confirms = []service.DeleteConfirmItem{}
	}
	ok(c, dto.AdminDeleteConfirmListResponse{Confirms: confirms})
}

// ResolveDeleteConfirm approves or rejects a pending server deletion. The legacy
// endpoint only approved; cancelling is the same decision with the opposite
// answer, so one route carries both.
//
// POST /api/v1/admin/delete-confirms/:entityId
func (h *AdminHandler) ResolveDeleteConfirm(c *gin.Context) {
	entityID, valid := idParam(c, "entityId", "server")
	if !valid {
		return
	}
	var req dto.DeleteConfirmRequest
	if !bind(c, &req) {
		return
	}
	ctx := c.Request.Context()
	if req.Approve {
		if err := service.Admin.ConfirmDelete(ctx, entityID); err != nil {
			fail(c, err)
			return
		}
		ok(c, msg("server deleted"))
		return
	}
	if err := service.Admin.RejectDelete(ctx, entityID); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("deletion cancelled"))
}

// WorkOrders lists the open support tickets.
//
// GET /api/v1/admin/work-orders
func (h *AdminHandler) WorkOrders(c *gin.Context) {
	orders, err := service.Admin.OpenWorkOrders(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if orders == nil {
		orders = []service.WorkOrderItem{}
	}
	ok(c, dto.AdminWorkOrderListResponse{Orders: orders})
}

// CloseWorkOrder resolves a ticket, optionally quoting a reply.
//
// POST /api/v1/admin/work-orders/:id/close
func (h *AdminHandler) CloseWorkOrder(c *gin.Context) {
	orderID, valid := idParam(c, "id", "work order")
	if !valid {
		return
	}
	var req dto.CloseWorkOrderRequest
	if !bind(c, &req) {
		return
	}
	err := service.Admin.CloseWorkOrder(c.Request.Context(), orderID, strings.TrimSpace(req.CloseInfo))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("work order closed"))
}

// ReviewGallery publishes or rejects an album submission.
//
// POST /api/v1/admin/gallery/:id/pass and /delete
func (h *AdminHandler) ReviewGallery(c *gin.Context) {
	itemID, valid := idParam(c, "id", "album item")
	if !valid {
		return
	}
	ctx := c.Request.Context()
	if c.Param("action") == "pass" {
		if err := service.Admin.PassGalleryItem(ctx, itemID); err != nil {
			fail(c, err)
			return
		}
		ok(c, msg("album item published"))
		return
	}
	if err := service.Admin.DeleteGalleryItem(ctx, itemID); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("album item deleted"))
}

// Settings returns the settings schema with the current values filled in.
//
// GET /api/v1/admin/settings
func (h *AdminHandler) Settings(c *gin.Context) {
	fields, err := service.Admin.Settings(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if fields == nil {
		fields = []service.SettingField{}
	}
	ok(c, dto.AdminSettingsResponse{Fields: fields})
}

// SaveSettings writes the submitted settings back to the TOML file and
// reconnects the datastores.
//
// PUT /api/v1/admin/settings
func (h *AdminHandler) SaveSettings(c *gin.Context) {
	var req dto.SaveSettingsRequest
	if !bind(c, &req) {
		return
	}
	if err := service.Admin.SaveSettings(c.Request.Context(), req.Values); err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("settings saved"))
}

// Health probes every external dependency.
//
// GET /api/v1/admin/health
func (h *AdminHandler) Health(c *gin.Context) {
	ok(c, dto.HealthResponse{Health: service.Admin.Health(c.Request.Context())})
}
