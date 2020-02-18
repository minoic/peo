package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
)

type AdminConsoleController struct {
	beego.Controller
}

func (this *AdminConsoleController) Prepare() {
	this.TplName = "AdminConsole.html"
	this.Data["u"] = 4
	handleNavbar(&this.Controller)
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转到登录",
			Title:  "您还没有登录",
		}, &this.Controller)
	} else if !MinoSession.SessionIsAdmin(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName,
			Detail: "正在跳转到主页",
			Title:  "您不是管理员",
		}, &this.Controller)
	}

}

func (this *AdminConsoleController) Get() {}

func (this *AdminConsoleController) Post() {

}

//todo: use settings.conf instead of database
