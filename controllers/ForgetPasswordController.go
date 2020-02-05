package controllers

import "github.com/astaxie/beego"

type ForgetPasswordController struct {
	beego.Controller
}

func (this *ForgetPasswordController) Get() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
}

//todo: complete this logic
func (this *ForgetPasswordController) Post() {

}
