package controllers

import (
	"NTPE/models/Email"
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "Index.html"
	Email.TestMail()
}
