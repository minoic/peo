package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoKey"
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "Loading.html"
	handleNavbar(&this.Controller)
	MinoKey.GeneKeys(10, 1, 30, 10)
}
