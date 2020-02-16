package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/models/ServerStatus"
	"github.com/astaxie/beego"
	"github.com/hako/durafmt"
	"time"
)

type UserConsoleController struct {
	beego.Controller
}

func (this *UserConsoleController) Prepare() {
	if !MinoSession.SessionIslogged(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
}

func (this *UserConsoleController) Get() {
	this.TplName = "UserConsole.html"
	this.Data["i"] = 1
	this.Data["u"] = 3
	sess := this.StartSession()
	user, _ := MinoSession.SessionGetUser(sess)
	this.Data["userName"] = user.Name
	DB := MinoDatabase.GetDatabase()
	var (
		entities        []MinoDatabase.WareEntity
		orders          []MinoDatabase.Order
		infoTotalUpTime time.Duration
		infoTotalOnline int
		pongs           []ServerStatus.Pong
	)
	DB.Where("user_id = ?", user.ID).Find(&entities)
	DB.Where("user_id = ?", user.ID).Find(&orders)
	this.Data["infoOrderCount"] = len(orders)
	this.Data["infoServerCount"] = len(entities)
	for _, e := range entities {
		infoTotalUpTime += time.Now().Sub(e.CreatedAt)
		pong, _ := ServerStatus.Ping(e.HostName)
		pongs = append(pongs, *pong)
		infoTotalOnline += pong.Players.Online
	}
	this.Data["infoTotalUpTime"] = durafmt.Parse(infoTotalUpTime).LimitFirstN(3).String()
	this.Data["infoTotalOnline"] = infoTotalOnline
}
