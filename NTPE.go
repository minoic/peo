package main

import (
	"NTPE/controllers"
	"github.com/astaxie/beego"
)

const (
	AppVer = "0.1.1.0227"
)

func main() {
	beego.Info(beego.BConfig.AppName, AppVer)
	beego.Router("/", &controllers.IndexController{})
	beego.Router("/reg", &controllers.RegController{})
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/pe-admin-settings.conf", &controllers.PEAdminSettingsController{})
	beego.Router("/new-ware", &controllers.NewWareController{})
	beego.Router("/confirm/:key", &controllers.ConfirmController{})
	beego.Router("/delay/:URL/:detail", &controllers.DelayController{})
	beego.Run()
}

//todo: add 404 page
//todo: add delay page
//todo: add WareSale page
//todo: add alipay/wxpay or more payment method
