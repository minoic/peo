package controllers

import (
	"NTPE/models"
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "Index.html"
	models.Test()
}
