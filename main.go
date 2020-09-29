package main

import (
	"github.com/MinoIC/MinoIC-PE/controllers"
	"github.com/MinoIC/MinoIC-PE/cron"
	"github.com/astaxie/beego"
)

const Version = "v0.1.0"

func main() {
	beego.BConfig.WebConfig.Session.SessionDisableHTTPOnly = true
	beego.Router("/", &controllers.WareSellerController{})
	beego.Router("/gallery-show", &controllers.GalleryShowController{})
	beego.Router("/alipay", &controllers.CallbackController{})
	beego.Router("/reg", &controllers.RegController{})
	beego.Router("/reg/confirm/:key", &controllers.RegController{}, "get:MailConfirm")
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/admin-console", &controllers.AdminConsoleController{})
	beego.Router("/admin-console/delete-confirm/:entityID", &controllers.AdminConsoleController{}, "get:DeleteConfirm")
	beego.Router("/admin-console/new-key", &controllers.AdminConsoleController{}, "get:NewKey")
	beego.Router("/admin-console/get-keys", &controllers.AdminConsoleController{}, "get:GetKeys")
	beego.Router("/admin-console/close-work-order", &controllers.AdminConsoleController{}, "post:CloseWorkOrder")
	beego.Router("/admin-console/gallery-items/pass", &controllers.AdminConsoleController{}, "post:GalleryPass")
	beego.Router("/admin-console/gallery-items/delete", &controllers.AdminConsoleController{}, "post:GalleryDelete")
	beego.Router("/new-ware", &controllers.NewWareController{})
	beego.Router("/new-order", &controllers.OrderCreateController{})
	beego.Router("/new-pack", &controllers.NewPackController{})
	beego.Router("/order/:orderID", &controllers.OrderInfoController{})
	beego.Router("/order/:orderID/pay-by-balance", &controllers.OrderInfoController{}, "get:PayByBalance")
	beego.Router("/delay", &controllers.DelayController{})
	beego.Router("/user-settings", &controllers.UserSettingsController{})
	beego.Router("/user-settings/change-password", &controllers.UserSettingsController{}, "post:UpdateUserPassword")
	beego.Router("/user-settings/change-email", &controllers.UserSettingsController{}, "post:UpdateUserEmail")
	beego.Router("/user-settings/gallery-post", &controllers.UserSettingsController{}, "post:GalleryPost")
	beego.Router("/user-settings/change-email/:email", &controllers.UserSettingsController{}, "get:SendCaptcha")
	beego.Router("/user-settings/create-pterodactyl-user", &controllers.UserSettingsController{}, "get:CreatePterodactylUser")
	beego.Router("/user-messages", &controllers.UserMessagesController{})
	beego.Router("/user-console", &controllers.UserConsoleController{})
	beego.Router("/user-console/renew/:entityID/:key", &controllers.UserConsoleController{}, "get:Renew")
	beego.Router("/user-console/renew2/:entity", &controllers.UserConsoleController{}, "get:Renew2")
	beego.Router("/user-console/reinstall/:entityID/:packID", &controllers.UserConsoleController{}, "get:Reinstall")
	beego.Router("/user-recharge", &controllers.UserRechargeController{})
	beego.Router("/user-recharge/recharge-by-key", &controllers.UserRechargeController{}, "get:RechargeByKey")
	beego.Router("/user-recharge/create-zfb", &controllers.UserRechargeController{}, "get:CreateZFB")
	beego.Router("/user-work-order", &controllers.UserWorkOrderController{})
	beego.Router("/user-work-order/post", &controllers.UserWorkOrderController{}, "post:NewWorkOrder")
	beego.Router("/user-terms", &controllers.UserTermsController{})
	beego.Router("/forget-password", &controllers.ForgetPasswordController{})
	beego.Router("/forget-password-mail/:email", &controllers.ForgetPasswordController{}, "get:SendMail")
	beego.ErrorController(&controllers.ErrorController{})
	cron.LoopTasksManager()
	beego.Run()
}

// todo: add code comments
