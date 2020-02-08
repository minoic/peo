package main

import (
	"git.ntmc.tech/root/MinoIC-PE/controllers"
	"git.ntmc.tech/root/MinoIC-PE/models/AutoManager"
	"github.com/astaxie/beego"
)

func main() {
	beego.Router("/index", &controllers.IndexController{})
	beego.Router("/reg", &controllers.RegController{})
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/pe-admin-settings", &controllers.PEAdminSettingsController{})
	beego.Router("/new-ware", &controllers.NewWareController{})
	beego.Router("/chart", &controllers.WareChartController{})
	beego.Router("/confirm/:key", &controllers.ConfirmController{})
	beego.Router("/delay", &controllers.DelayController{})
	beego.Router("/", &controllers.WareSellerController{})
	beego.Router("/user-settings", &controllers.UserSettingsController{})
	beego.Router("/user-console", &controllers.UserConsoleController{})
	beego.Router("/user-terms", &controllers.UserTermsController{})
	beego.Router("/forget-password", &controllers.ForgetPasswordController{})
	beego.Router("/forget-password-mail/:email", &controllers.ForgetPasswordMailController{})
	beego.ErrorController(&controllers.ErrorController{})
	AutoManager.LoopManager()
	beego.Run()
}

//todo: add alipay/wxpay or more payment method
//todo: add code comments
