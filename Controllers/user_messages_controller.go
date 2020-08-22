package Controllers

import (
	"github.com/MinoIC/MinoIC-PE/MinoMessage"
	"github.com/MinoIC/MinoIC-PE/MinoSession"
	"github.com/astaxie/beego"
)

type UserMessagesController struct {
	beego.Controller
}

func (this *UserMessagesController) Prepare() {
	this.TplName = "UserMessages.html"
	if !MinoSession.SessionIslogged(this.StartSession()) {
		this.Abort("401")
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
	// beego.Info(messages)
	MinoMessage.ReadAll(user.ID)
	this.Data["unReadNum"] = 0
}
