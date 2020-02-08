package controllers

import (
	"crypto/md5"
	"encoding/hex"
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
	if !MinoConfigure.ConfGetSMTPEnabled() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "服务器没有开启SMTP服务，无法使用找回密码功能，请联系网站管理员找回密码！"
	}
}

func (this *ForgetPasswordController) Post() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
	if !this.CheckXSRFCookie() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "XSRF 验证失败！"
		return
	}
	userEmail := this.GetString("email")
	password := this.GetString("password")
	passwordConfirm := this.GetString("passwordConfirm")
	cpt := this.GetString("cpt")
	DB := MinoDatabase.GetDatabase()
	var user MinoDatabase.User
	if !DB.Where("email = ?", userEmail).First(&user).RecordNotFound() {
		if cpt == bm.Get("FORGET"+userEmail) {
			if password == passwordConfirm {
				conf := MinoConfigure.GetConf()
				b := md5.Sum([]byte(password + conf.String("DatabaseSalt")))
				DB.Model(&user).Update("Password", hex.EncodeToString(b[:]))
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

func (this *ForgetPasswordController) CheckXSRFCookie() bool {
	if !this.EnableXSRF {
		return true
	}
	token := this.Ctx.Input.Query("_xsrf")
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Xsrftoken")
	}
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Csrftoken")
	}
	if token == "" {
		return false
	}
	if this.XSRFToken() != token {
		return false
	}
	return true
}
