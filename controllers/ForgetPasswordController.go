package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/astaxie/beego"
)

type ForgetPasswordController struct {
	beego.Controller
}

func (this *ForgetPasswordController) Get() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
}

func (this *ForgetPasswordController) Post() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
	userEmail := this.GetString("email")
	password := this.GetString("password")
	passwordConfirm := this.GetString("passwordConfirm")
	cpt := this.GetString("cpt")
	DB := MinoDatabase.GetDatabase()
	var user MinoDatabase.User
	if !DB.Where("email = ?", userEmail).First(&user).RecordNotFound() {
		if cpt == bm.Get("FORGET"+userEmail) {
			if password == passwordConfirm {
				DB.Model(&user).Update("Password", password)
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.ConfGetHostName() + "/login",
					Detail: "正在跳转到登录页面",
					Title:  "修改成功 😀",
				}, &this.Controller)
			} else {
				this.Data["hasError"] = true
				this.Data["hasErrorText"] = "两次输入的密码不一致"
			}
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = "邮件验证码输入错误"
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "该邮箱未被注册，无法找回密码！"
	}
}
