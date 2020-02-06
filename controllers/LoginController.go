package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
)

type LoginController struct {
	beego.Controller
}

func (this *LoginController) Get() {
	this.TplName = "Login.html"
	handleNavbar(&this.Controller)
}

func (this *LoginController) Post() {
	this.TplName = "Login.html"
	handleNavbar(&this.Controller)
	DB := MinoDatabase.GetDatabase()
	defer DB.Close()
	loginEOU := this.GetString("loginEOU")
	loginPass := this.GetString("loginPass")
	loginRemember, _ := this.GetBool("loginRemember", false)
	var user MinoDatabase.User
	if !DB.Where("Email = ?", loginEOU).Or("Name = ?", loginEOU).First(&user).RecordNotFound() {
		if loginPass == user.Password {
			this.Data["loginReturnData"] = "logged in!"
			this.SetSession("LST", MinoSession.GeneToken(user.Name, loginRemember))
			this.SetSession("ID", user.ID)
			this.SetSession("UN", user.Name)
			DelayRedirect(DelayInfo{
				URL:    MinoConfigure.ConfGetHostName(),
				Detail: "正在跳转到主页",
				Title:  "您已成功登录！",
			}, &this.Controller)
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = "密码错误！"
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "用户不存在！"
	}
}
