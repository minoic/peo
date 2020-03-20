package Controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/MinoSession"
	"github.com/astaxie/beego"
)

type UserMessagesController struct {
	beego.Controller
}

func (this *UserMessagesController) Prepare() {
	this.TplName = "UserMessages.html"
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	this.Data["u"] = 2
}

func (this *UserMessagesController) Get() {
	user, err := MinoSession.SessionGetUser(this.StartSession())
	if err != nil {
		beego.Error(err)
	}
	messages := MinoMessage.GetMessages(user.ID)
	this.Data["messages"] = messages
	//beego.Info(messages)
	MinoMessage.ReadAll(user.ID)
	this.Data["unReadNum"] = 0
}
