package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
	"time"
)

type UserMessagesController struct {
	beego.Controller
}

func (this *UserMessagesController) Get() {
	this.TplName = "UserMessages.html"
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	var messages []MinoDatabase.Message
	DB := MinoDatabase.GetDatabase()
	user, err := MinoSession.SessionGetUser(this.StartSession())
	if err != nil {
		beego.Error(err)
	}
	DB.Where("receiver_id = ?", user.ID).Find(&messages)
	if len(messages) == 0 {
		//beego.Debug("none message found")
		messages = append(messages, MinoDatabase.Message{
			Model:      gorm.Model{},
			SenderName: "nobody",
			Text:       "您还没有消息",
			TimePassed: time.Second.String(),
			SendTime:   time.Time{},
		})
	} else {
		//beego.Debug("message found")
		for _, m := range messages {
			m.TimePassed = time.Now().Sub(m.SendTime).String()
		}
	}
	this.Data["messages"] = messages
	beego.Info(messages)
}
