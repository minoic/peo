package main

import (
	"NTOJ/controllers"
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
	beego.Run()

}
