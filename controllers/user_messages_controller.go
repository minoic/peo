package controllers

import (
	"github.com/MinoIC/MinoIC-PE/message"
	"github.com/MinoIC/MinoIC-PE/session"
	"github.com/MinoIC/glgf"
	"github.com/astaxie/beego"
)

type UserMessagesController struct {
	beego.Controller
}

func (this *UserMessagesController) Prepare() {
	this.TplName = "UserMessages.html"
	if !session.SessionIslogged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	this.Data["u"] = 2
}

func (this *UserMessagesController) Get() {
	user, err := session.SessionGetUser(this.StartSession())
	if err != nil {
		glgf.Error(err)
	}
	messages := message.GetMessages(user.ID)
	this.Data["messages"] = messages
	// glgf.Info(messages)
	message.ReadAll(user.ID)
	this.Data["unReadNum"] = 0
}
