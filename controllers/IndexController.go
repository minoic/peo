package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoMessage"
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "Index.html"
	handleNavbar(&this.Controller)
	this.Data["webHostName"] = MinoConfigure.ConfGetHostName()
	this.Data["webApplicationName"] = MinoConfigure.ConfGetWebName()
	MinoMessage.Send("haha", 1, "hahaha")
}
