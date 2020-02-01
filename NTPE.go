package main

import (
	"NTPE/controllers"
	"NTPE/models/AutoManager"
	"github.com/astaxie/beego"
)

func main() {
	beego.Router("/", &controllers.IndexController{})
	beego.Router("/reg", &controllers.RegController{})
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/pe-admin-settings", &controllers.PEAdminSettingsController{})
	beego.Router("/new-ware", &controllers.NewWareController{})
	beego.Router("/confirm/:key", &controllers.ConfirmController{})
	beego.Router("/delay", &controllers.DelayController{})
	beego.Router("/ware", &controllers.WareSellerController{})
	beego.Router("/user-settings", &controllers.UserSettingsController{})
	beego.ErrorController(&controllers.ErrorController{})
	AutoManager.LoopManager()
	beego.Run()
}

//todo: add alipay/wxpay or more payment method
