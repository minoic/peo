package controllers

import (
	"github.com/astaxie/beego"
)

type WareSellerController struct {
	beego.Controller
}

func (this *WareSellerController) Get() {
	this.TplName = "WareSeller.html"
	this.Data["wareTitle"] = "Title"
	this.Data["wareDetail"] = "Detail"
}
