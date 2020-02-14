package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
)

type UserSettingsController struct {
	beego.Controller
}

func (this *UserSettingsController) Prepare() {
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
}

func (this *UserSettingsController) Get() {
	this.TplName = "UserSettings.html"
	this.Data["i"] = 2
}
