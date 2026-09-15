package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/minoic/peo/server/internal/api/dto"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/models"
	"github.com/minoic/peo/server/internal/service"
)

// ServerHandler serves the customer console: listing, live status, renewal,
// reinstalling and the deletion request flow.
type ServerHandler struct{}

// NewServerHandler builds the handler.
func NewServerHandler() *ServerHandler { return &ServerHandler{} }

// List returns the server records of the caller.
//
// GET /api/v1/servers
func (h *ServerHandler) List(c *gin.Context) {
	servers, err := service.Servers.List(c.Request.Context(), middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	if servers == nil {
		servers = []models.WareEntity{}
	}
	ok(c, dto.ServerListResponse{Servers: servers})
}

// Status returns the live state of every server, including the cached Minecraft
// probe. The console polls this endpoint instead of the legacy page refresh.
//
// GET /api/v1/servers/status
func (h *ServerHandler) Status(c *gin.Context) {
	statuses, err := service.Servers.Status(c.Request.Context(), middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	if statuses == nil {
		statuses = []service.Status{}
	}
	ok(c, dto.StatusListResponse{Servers: statuses})
}

// ByID returns one server record.
//
// GET /api/v1/servers/:id
func (h *ServerHandler) ByID(c *gin.Context) {
	entityID, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	e, err := service.Servers.ByID(c.Request.Context(), entityID, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, dto.ServerDetailResponse{Server: e})
}

// Renew extends a server using an activation code. The legacy route carried the
// code in the path; it is a body field here so it does not reach access logs.
//
// POST /api/v1/servers/:id/renew
func (h *ServerHandler) Renew(c *gin.Context) {
	entityID, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.RenewRequest
	if !bind(c, &req) {
		return
	}
	err := service.Servers.Renew(c.Request.Context(), entityID, middleware.UserID(c), middleware.IsAdmin(c), req.Key)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("server renewed"))
}

// RenewByBalance extends a server by one month, paid from the balance.
//
// POST /api/v1/servers/:id/renew-by-balance
func (h *ServerHandler) RenewByBalance(c *gin.Context) {
	entityID, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	err := service.Servers.RenewWithBalance(c.Request.Context(), entityID, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("server renewed"))
}

// Reinstall swaps the egg of the server and re-runs its installer.
//
// POST /api/v1/servers/:id/reinstall
func (h *ServerHandler) Reinstall(c *gin.Context) {
	entityID, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	var req dto.ReinstallRequest
	if !bind(c, &req) {
		return
	}
	err := service.Servers.Reinstall(c.Request.Context(), entityID, middleware.UserID(c), middleware.IsAdmin(c), req.EggID)
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("reinstall started"))
}

// RequestDelete asks for the server to be destroyed. An administrator has to
// confirm it, which is what makes the legacy two step deletion safe.
//
// POST /api/v1/servers/:id/delete
func (h *ServerHandler) RequestDelete(c *gin.Context) {
	entityID, valid := idParam(c, "id", "server")
	if !valid {
		return
	}
	err := service.Servers.RequestDelete(c.Request.Context(), entityID, middleware.UserID(c), middleware.IsAdmin(c))
	if err != nil {
		fail(c, err)
		return
	}
	ok(c, msg("deletion requested"))
}
