package controllers

import "github.com/astaxie/beego"

type UserTermsController struct {
	beego.Controller
}

func (this *UserTermsController) Get() {
	this.TplName = "UserTerms.html"
	handleNavbar(&this.Controller)
}
