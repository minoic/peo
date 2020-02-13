package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
)

type UserConsoleController struct {
	beego.Controller
}

func (this *UserConsoleController) Prepare() {
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
}

func (this *UserConsoleController) Get() {
	this.TplName = "Console.html"
}
