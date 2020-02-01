package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models"
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "Index.html"
	this.Data["webHostName"] = models.ConfGetHostName()
	this.Data["webApplicationName"] = models.ConfGetWebName()
}
