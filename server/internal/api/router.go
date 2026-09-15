package api

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/server/internal/api/handlers"
	"github.com/minoic/peo/server/internal/config"
	"github.com/minoic/peo/server/internal/middleware"
	"github.com/minoic/peo/server/internal/service"
)

// Router builds the Gin engine for the API and the SPA shell.
func Router() *gin.Engine {
	r := gin.New()
	r.Use(middleware.Recovery())
	r.Use(middleware.Logger())
	r.Use(middleware.CORS(config.String("CORSOrigins")))

	if gin.Mode() == gin.DebugMode {
		glgf.Info("gin router initialized in debug mode")
	}

	r.GET("/healthz", func(c *gin.Context) {
		ctx := c.Request.Context()
		health := service.Admin.Health(ctx)
		status := map[string]interface{}{
			"ok": true,
		}
		for name, component := range map[string]service.ComponentStatus{
			"mongo":       health.Mongo,
			"redis":       health.Redis,
			"pterodactyl": health.Pterodactyl,
		} {
			status[name] = component.OK
			if !component.OK {
				status[name+"_error"] = component.Message
				status["ok"] = false
			}
		}
		if status["ok"] == false {
			c.JSON(http.StatusServiceUnavailable, status)
			return
		}
		c.JSON(http.StatusOK, status)
	})

	auth := handlers.NewAuthHandler()
	site := handlers.NewSiteHandler()
	product := handlers.NewProductHandler()
	order := handlers.NewOrderHandler()
	server := handlers.NewServerHandler()
	gallery := handlers.NewGalleryHandler()
	message := handlers.NewMessageHandler()
	workOrder := handlers.NewWorkOrderHandler()
	recharge := handlers.NewRechargeHandler()
	user := handlers.NewUserHandler()
	admin := handlers.NewAdminHandler()

	api := r.Group("/api/v1")
	public := api.Group("/")
	public.Use(middleware.OptionalAuth())
	public.GET("/site/config", site.Config)
	public.GET("/site/storefront", site.Storefront)
	public.GET("/products/:specId", product.Detail)
	public.GET("/nests/:nestId/eggs", product.Eggs)
	public.POST("/auth/login", auth.Login)
	public.POST("/auth/register", auth.Register)
	public.GET("/auth/confirm-email/:key", auth.ConfirmEmail)
	public.POST("/auth/forget-password", auth.ForgetPassword)
	public.POST("/auth/reset-password", auth.ResetPassword)
	public.POST("/alipay/notify", recharge.AlipayNotify)

	authOnly := api.Group("/")
	authOnly.Use(middleware.Auth())
	authOnly.POST("/auth/logout", auth.Logout)
	authOnly.GET("/auth/me", auth.Me)
	authOnly.POST("/user/pterodactyl-session", auth.PterodactylSession)
	authOnly.PUT("/user/password", user.Password)
	authOnly.PUT("/user/email", user.Email)
	authOnly.POST("/user/email/confirm", user.ConfirmEmail)
	authOnly.POST("/user/pterodactyl-user", user.PterodactylUser)
	authOnly.POST("/orders", order.Create)
	authOnly.GET("/orders", order.List)
	authOnly.GET("/orders/:id", order.ByID)
	authOnly.GET("/orders/:id/allocations", product.Allocations)
	authOnly.POST("/orders/:id/pay", order.Pay)
	authOnly.POST("/orders/:id/pay-by-balance", order.PayByBalance)
	authOnly.GET("/servers", server.List)
	authOnly.GET("/servers/status", server.Status)
	authOnly.GET("/servers/:id", server.ByID)
	authOnly.POST("/servers/:id/renew", server.Renew)
	authOnly.POST("/servers/:id/renew-by-balance", server.RenewByBalance)
	authOnly.POST("/servers/:id/reinstall", server.Reinstall)
	authOnly.POST("/servers/:id/delete", server.RequestDelete)
	authOnly.GET("/gallery", gallery.List)
	authOnly.GET("/gallery/mine", gallery.MyItems)
	authOnly.POST("/gallery", gallery.Submit)
	authOnly.POST("/gallery/:id/like", gallery.Like)
	authOnly.DELETE("/gallery/:id", gallery.Delete)
	authOnly.GET("/messages", message.List)
	authOnly.GET("/messages/unread", message.Unread)
	authOnly.POST("/messages/:id/read", message.Read)
	authOnly.POST("/messages/read-all", message.ReadAll)
	authOnly.DELETE("/messages/:id", message.Delete)
	authOnly.GET("/work-orders", workOrder.List)
	authOnly.POST("/work-orders", workOrder.Create)
	authOnly.GET("/recharge/logs", recharge.Logs)
	authOnly.POST("/recharge/key", recharge.ByKey)
	authOnly.POST("/recharge/alipay", recharge.PreCreate)
	authOnly.GET("/recharge/alipay/:outTradeNo", recharge.Status)

	adminOnly := api.Group("/")
	adminOnly.Use(middleware.Auth(), middleware.Admin())
	adminOnly.GET("/admin/dashboard", admin.Dashboard)
	adminOnly.GET("/admin/users", admin.Users)
	adminOnly.GET("/admin/orders", admin.Orders)
	adminOnly.GET("/admin/products", admin.Products)
	adminOnly.GET("/admin/products/raw", product.AdminList)
	adminOnly.GET("/admin/products/form", admin.ProductForm)
	adminOnly.POST("/admin/products", admin.CreateProduct)
	adminOnly.PUT("/admin/products/:specId", admin.UpdateProduct)
	adminOnly.DELETE("/admin/products/:specId", admin.DeleteProduct)
	adminOnly.GET("/admin/key-targets", admin.KeyTargets)
	adminOnly.POST("/admin/keys", admin.GenerateKeys)
	adminOnly.GET("/admin/keys/export", admin.ExportKeys)
	adminOnly.GET("/admin/delete-confirms", admin.DeleteConfirms)
	adminOnly.POST("/admin/delete-confirms/:entityId", admin.ResolveDeleteConfirm)
	adminOnly.GET("/admin/work-orders", admin.WorkOrders)
	adminOnly.POST("/admin/work-orders/:id/close", admin.CloseWorkOrder)
	adminOnly.POST("/admin/gallery/:id/:action", admin.ReviewGallery)
	adminOnly.GET("/admin/settings", admin.Settings)
	adminOnly.PUT("/admin/settings", admin.SaveSettings)
	adminOnly.GET("/admin/health", admin.Health)

	webRoot := config.String("WebRoot")
	if strings.TrimSpace(webRoot) == "" {
		webRoot = "web"
	}
	r.NoRoute(spaFallback(newBundle(webRoot)))
	return r
}
