package main

import (
	"github.com/MinoIC/MinoIC-PE/AutoManager"
	"github.com/MinoIC/MinoIC-PE/Controllers"
	"github.com/astaxie/beego"
)

func main() {
	beego.BConfig.WebConfig.Session.SessionDisableHTTPOnly = true
	beego.Router("/", &Controllers.WareSellerController{})
	beego.Router("/gallery-show", &Controllers.GalleryShowController{})
	beego.Router("/index", &Controllers.IndexController{})
	beego.Router("/reg", &Controllers.RegController{})
	beego.Router("/reg/confirm/:key", &Controllers.RegController{}, "get:MailConfirm")
	beego.Router("/login", &Controllers.LoginController{})
	beego.Router("/admin-console", &Controllers.AdminConsoleController{})
	beego.Router("/admin-console/delete-confirm/:entityID", &Controllers.AdminConsoleController{}, "get:DeleteConfirm")
	beego.Router("/admin-console/new-key", &Controllers.AdminConsoleController{}, "get:NewKey")
	beego.Router("/admin-console/get-keys", &Controllers.AdminConsoleController{}, "get:GetKeys")
	beego.Router("/admin-console/close-work-order", &Controllers.AdminConsoleController{}, "post:CloseWorkOrder")
	beego.Router("/admin-console/gallery-items/pass", &Controllers.AdminConsoleController{}, "post:GalleryPass")
	beego.Router("/admin-console/gallery-items/delete", &Controllers.AdminConsoleController{}, "post:GalleryDelete")
	beego.Router("/new-ware", &Controllers.NewWareController{})
	beego.Router("/new-order", &Controllers.OrderCreateController{})
	beego.Router("/new-pack", &Controllers.NewPackController{})
	beego.Router("/order/:orderID", &Controllers.OrderInfoController{})
	beego.Router("/order/:orderID/pay-by-balance", &Controllers.OrderInfoController{}, "get:PayByBalance")
	beego.Router("/delay", &Controllers.DelayController{})
	beego.Router("/user-settings", &Controllers.UserSettingsController{})
	beego.Router("/user-settings/change-password", &Controllers.UserSettingsController{}, "post:UpdateUserPassword")
	beego.Router("/user-settings/change-email", &Controllers.UserSettingsController{}, "post:UpdateUserEmail")
	beego.Router("/user-settings/gallery-post", &Controllers.UserSettingsController{}, "post:GalleryPost")
	beego.Router("/user-settings/change-email/:email", &Controllers.UserSettingsController{}, "get:SendCaptcha")
	beego.Router("/user-settings/create-pterodactyl-user", &Controllers.UserSettingsController{}, "get:CreatePterodactylUser")
	beego.Router("/user-messages", &Controllers.UserMessagesController{})
	beego.Router("/user-console", &Controllers.UserConsoleController{})
	beego.Router("/user-console/renew/:entityID/:key", &Controllers.UserConsoleController{}, "get:Renew")
	beego.Router("/user-console/renew2/:entity", &Controllers.UserConsoleController{}, "get:Renew2")
	beego.Router("/user-console/reinstall/:entityID/:packID", &Controllers.UserConsoleController{}, "get:Reinstall")
	beego.Router("/user-recharge", &Controllers.UserRechargeController{})
	beego.Router("/user-recharge/recharge-by-key", &Controllers.UserRechargeController{}, "get:RechargeByKey")
	beego.Router("/user-recharge/create-zfb", &Controllers.UserRechargeController{}, "get:CreateZFB")
	beego.Router("/user-work-order", &Controllers.UserWorkOrderController{})
	beego.Router("/user-work-order/post", &Controllers.UserWorkOrderController{}, "post:NewWorkOrder")
	beego.Router("/user-terms", &Controllers.UserTermsController{})
	beego.Router("/forget-password", &Controllers.ForgetPasswordController{})
	beego.Router("/forget-password-mail/:email", &Controllers.ForgetPasswordController{}, "get:SendMail")
	beego.ErrorController(&Controllers.ErrorController{})
	AutoManager.LoopTasksManager()
	beego.Run()
}

// todo: add alipay/wxpay or more payment method
// todo: add code comments
