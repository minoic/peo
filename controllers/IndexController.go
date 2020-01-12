package controllers

import (
	"NTOJ/models"
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "index.html"
	models.GeneKeys(10, 1, 30, 32)
	sess := this.StartSession()
	if !models.Islogged(sess) {
		this.Redirect("/login", 302)
	}
}
