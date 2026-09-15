package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/service"
)

// SiteHandler serves the public bootstrap payloads: the shell configuration and
// the shop landing page. These are the only two endpoints the Flutter app calls
// before the user has signed in.
type SiteHandler struct{}

// NewSiteHandler builds the handler.
func NewSiteHandler() *SiteHandler { return &SiteHandler{} }

// Config returns the site identity and the feature switches the shell needs.
// Ported from the legacy `handleNavbar` helper plus the settings page, which
// rendered these values into every template. The route is mounted with
// OptionalAuth so one request serves both an anonymous visitor and a
// signed-in one; the caller fields stay zero for the former.
//
// GET /api/v1/site/config
func (h *SiteHandler) Config(c *gin.Context) {
	resp := dto.SiteConfigResponse{
		ApplicationName: config.String("WebApplicationName"),
		Description:     config.String("WebDescription"),
		HostName:        config.String("WebHostName"),
		AdminAddress:    config.String("WebAdminAddress"),
		AlbumEnabled:    config.Bool("AlbumEnabled"),
		RechargeMode:    config.Bool("RechargeMode"),
		AlipayEnabled:   service.Recharge.AlipayEnabled(),
		TotalDiscount:   config.Bool("TotalDiscount"),
		SocialLink:      config.String("SocialLink"),
		SocialTitle:     config.String("SocialLinkTitle"),
		EmailNotice:     config.Bool("SMTPEnabled"),
	}
	if middleware.LoggedIn(c) {
		resp.LoggedIn = true
		resp.IsAdmin = middleware.IsAdmin(c)
		// A failed count is not worth failing the bootstrap for: the badge shows
		// zero and the next poll corrects it.
		if n, err := service.Messages.Unread(c.Request.Context(), middleware.UserID(c)); err == nil {
			resp.Unread = n
		}
	}
	ok(c, resp)
}

// Storefront returns the product buckets the shop page renders.
//
// GET /api/v1/site/storefront
func (h *SiteHandler) Storefront(c *gin.Context) {
	front, err := service.Products.Storefront(c.Request.Context())
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.StorefrontResponse{
		Monthly:     front.Monthly,
		Quarterly:   front.Quarterly,
		Yearly:      front.Yearly,
		EmailNotice: front.EmailNotice,
	})
}
