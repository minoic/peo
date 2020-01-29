package main

import (
	"NTPE/controllers"
	"github.com/astaxie/beego"
)

func main() {
	beego.Router("/", &controllers.IndexController{})
	beego.Router("/reg", &controllers.RegController{})
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/pe-admin-settings.conf", &controllers.PEAdminSettingsController{})
	beego.Router("/new-ware", &controllers.NewWareController{})
	beego.Router("/confirm/:key", &controllers.ConfirmController{})
	beego.Router("/delay/:URL/:title/:detail", &controllers.DelayController{})
	beego.ErrorController(&controllers.ErrorController{})
	beego.Run()
}

//todo: add 404 page
//todo: add WareSale page
//todo: add alipay/wxpay or more payment method
