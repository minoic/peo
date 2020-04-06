package Controllers

import (
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "Loading.html"
	handleNavbar(&this.Controller)
	this.Data["u"] = 0
	// beego.Debug(err)
}
