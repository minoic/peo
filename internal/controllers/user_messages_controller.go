package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/session"
)

type UserMessagesController struct {
	web.Controller
	i18n.Locale
}

func (this *UserMessagesController) Prepare() {
	this.TplName = "UserMessages.html"
	if !session.Logged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	this.Data["u"] = 2
}

func (this *UserMessagesController) Get() {
	user, err := session.GetUser(this.StartSession())
	if err != nil {
		glgf.Error(err)
	}
	messages := message.GetMessages(user.ID)
	this.Data["messages"] = messages
	// glgf.Info(messages)
	message.ReadAll(user.ID)
	this.Data["unReadNum"] = 0
}
