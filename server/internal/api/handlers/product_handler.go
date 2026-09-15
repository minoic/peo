package handlers

import (
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// ProductHandler serves the catalogue. Every route here is public: the shop,
// the order wizard and the reinstall picker all need it before or after signing
// in, and none of it is secret.
type ProductHandler struct{}

// NewProductHandler builds the handler.
func NewProductHandler() *ProductHandler { return &ProductHandler{} }

// Detail returns one product with its price, its nest and its eggs.
//
// GET /api/v1/products/:specId
func (h *ProductHandler) Detail(c *gin.Context) {
	specID, valid := idParam(c, "specId", "product")
	if !valid {
		return
	}
	detail, err := service.Products.Detail(c.Request.Context(), specID)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.ProductDetailResponse{
		Product:  detail.Product,
		Pricing:  detail.Pricing,
		NestName: detail.NestName,
		EggName:  detail.EggName,
		Eggs:     detail.Eggs,
	})
}

// Eggs lists the server templates of a nest, for the reinstall picker.
//
// GET /api/v1/nests/:nestId/eggs
func (h *ProductHandler) Eggs(c *gin.Context) {
	nestID, err := strconv.Atoi(c.Param("nestId"))
	if err != nil {
		badParam(c, "nest")
		return
	}
	eggs, err := service.Products.Eggs(c.Request.Context(), nestID)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.EggListResponse{Eggs: eggs})
}

// Allocations lists the free ports of the node the ordered product is pinned to.
// This replaces the legacy order page, which embedded the address picker in the
// checkout HTML; the split REST client fetches it as its own resource.
//
// GET /api/v1/orders/:id/allocations
func (h *ProductHandler) Allocations(c *gin.Context) {
	orderID, valid := idParam(c, "id", "order")
	if !valid {
		return
	}
	allocs, err := service.Order.Allocations(c.Request.Context(), orderID)
	if err != nil {
		fail(c, err)
		return
	}
	out := make([]dto.Allocation, 0, len(allocs))
	for i := range allocs {
		out = append(out, dto.Allocation{ID: allocs[i].ID, Address: allocs[i].Address})
	}
	ok(c, dto.AllocationListResponse{Allocations: out})
}

// AdminList returns the raw product documents the admin editor binds to.
// Unlike the storefront projection this is not cached, so a save is visible
// immediately.
//
// GET /api/v1/admin/products/raw
func (h *ProductHandler) AdminList(c *gin.Context) {
	specs, err := service.Products.List(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	if specs == nil {
		specs = []models.WareSpec{}
	}
	ok(c, dto.ProductListResponse{Products: specs})
}
