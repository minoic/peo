package api

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/controllers"
)

func InitRouter() {
	web.BConfig.WebConfig.Session.SessionDisableHTTPOnly = true
	web.BConfig.Listen.EnableAdmin = true
	web.BConfig.Listen.AdminAddr = "0.0.0.0"
	web.BConfig.Listen.AdminPort = 8088
	web.BConfig.WebConfig.Session.SessionProvider = "redis"
	web.BConfig.WebConfig.Session.SessionProviderConfig = configure.Viper().GetString("RedisHost")
	web.Router("/", &controllers.WareSellerController{})
	web.Router("/gallery-show", &controllers.GalleryShowController{})
	web.Router("/alipay", &controllers.CallbackController{})
	web.Router("/reg", &controllers.RegController{})
	web.Router("/reg/confirm/:key", &controllers.RegController{}, "get:MailConfirm")
	web.Router("/login", &controllers.LoginController{})
	web.Router("/admin-console", &controllers.AdminConsoleController{})
	web.Router("/admin-console/delete-confirm/:entityID", &controllers.AdminConsoleController{}, "get:DeleteConfirm")
	web.Router("/admin-console/new-key", &controllers.AdminConsoleController{}, "get:NewKey")
	web.Router("/admin-console/get-keys", &controllers.AdminConsoleController{}, "get:GetKeys")
	web.Router("/admin-console/close-work-order", &controllers.AdminConsoleController{}, "post:CloseWorkOrder")
	web.Router("/admin-console/gallery-items/pass", &controllers.AdminConsoleController{}, "post:GalleryPass")
	web.Router("/admin-console/gallery-items/delete", &controllers.AdminConsoleController{}, "post:GalleryDelete")
	web.Router("/admin-settings", &controllers.AdminSettingsController{})
	web.Router("/new-ware", &controllers.NewWareController{})
	web.Router("/new-order", &controllers.OrderCreateController{})
	web.Router("/order/:orderID", &controllers.OrderInfoController{})
	web.Router("/order/:orderID/pay-by-balance", &controllers.OrderInfoController{}, "get:PayByBalance")
	web.Router("/delay", &controllers.DelayController{})
	web.Router("/user-settings", &controllers.UserSettingsController{})
	web.Router("/user-settings/change-password", &controllers.UserSettingsController{}, "post:UpdateUserPassword")
	web.Router("/user-settings/change-email", &controllers.UserSettingsController{}, "post:UpdateUserEmail")
	web.Router("/user-settings/gallery-post", &controllers.UserSettingsController{}, "post:GalleryPost")
	web.Router("/user-settings/change-email/:email", &controllers.UserSettingsController{}, "get:SendCaptcha")
	web.Router("/user-settings/create-pterodactyl-user", &controllers.UserSettingsController{}, "get:CreatePterodactylUser")
	web.Router("/user-messages", &controllers.UserMessagesController{})
	web.Router("/user-console", &controllers.UserConsoleController{})
	web.Router("/user-console/renew/:entityID/:key", &controllers.UserConsoleController{}, "get:Renew")
	web.Router("/user-console/renew2/:entity", &controllers.UserConsoleController{}, "get:Renew2")
	web.Router("/user-console/reinstall/:entityID/:eggID", &controllers.UserConsoleController{}, "get:Reinstall")
	web.Router("/user-recharge", &controllers.UserRechargeController{})
	web.Router("/user-recharge/recharge-by-key", &controllers.UserRechargeController{}, "get:RechargeByKey")
	web.Router("/user-recharge/create-zfb", &controllers.UserRechargeController{}, "get:CreateZFB")
	web.Router("/user-work-order", &controllers.UserWorkOrderController{})
	web.Router("/user-work-order/post", &controllers.UserWorkOrderController{}, "post:NewWorkOrder")
	web.Router("/user-terms", &controllers.UserTermsController{})
	web.Router("/forget-password", &controllers.ForgetPasswordController{})
	web.Router("/forget-password-mail/:email", &controllers.ForgetPasswordController{}, "get:SendMail")
	web.ErrorController(&controllers.ErrorController{})
}
