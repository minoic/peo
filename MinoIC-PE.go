package main

import (
	"git.ntmc.tech/root/MinoIC-PE/controllers"
	"git.ntmc.tech/root/MinoIC-PE/models/AutoManager"
	"github.com/astaxie/beego"
)

func main() {
	beego.BConfig.WebConfig.Session.SessionProvider = "file"
	beego.BConfig.WebConfig.Session.SessionProviderConfig = "./tmp"
	beego.BConfig.WebConfig.Session.SessionDisableHTTPOnly = true
	beego.BConfig.WebConfig.Session.SessionOn = true
	beego.Router("/", &controllers.WareSellerController{})
	beego.Router("/index", &controllers.IndexController{})
	beego.Router("/reg", &controllers.RegController{})
	beego.Router("/reg/confirm/:key", &controllers.RegController{}, "post:MailConfirm")
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/pe-admin-settings", &controllers.PEAdminSettingsController{})
	beego.Router("/new-ware", &controllers.NewWareController{})
	beego.Router("/new-order", &controllers.OrderCreateController{})
	beego.Router("/order/:orderID", &controllers.OrderInfoController{})
	beego.Router("/delay", &controllers.DelayController{})
	beego.Router("/user-settings", &controllers.UserSettingsController{})
	beego.Router("/user-settings/change-password", &controllers.UserSettingsController{}, "post:UpdateUserPassword")
	beego.Router("/user-settings/change-email", &controllers.UserSettingsController{}, "post:UpdateUserEmail")
	beego.Router("/user-messages", &controllers.UserMessagesController{})
	beego.Router("/user-console", &controllers.UserConsoleController{})
	beego.Router("/user-terms", &controllers.UserTermsController{})
	beego.Router("/forget-password", &controllers.ForgetPasswordController{})
	beego.Router("/forget-password-mail/:email", &controllers.ForgetPasswordController{}, "post:SendMail")
	beego.ErrorController(&controllers.ErrorController{})
	AutoManager.LoopManager()
	beego.Run()
}

//todo: add alipay/wxpay or more payment method
//todo: add code comments
