package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/models/ServerStatus"
	"github.com/astaxie/beego"
	"github.com/hako/durafmt"
	"html/template"
	"time"
)

type UserConsoleController struct {
	beego.Controller
}

type serverInfo struct {
	ServerIsOnline     bool
	ServerIconData     template.URL
	ServerName         string
	ServerEXP          string
	ServerDescription  string
	ServerPlayerOnline int
	ServerPlayerMax    int
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
		servers         []serverInfo
	)
	DB.Where("user_id = ?", user.ID).Find(&entities)
	DB.Where("user_id = ?", user.ID).Find(&orders)
	this.Data["infoOrderCount"] = len(orders)
	this.Data["infoServerCount"] = len(entities)
	for _, e := range entities {
		infoTotalUpTime += time.Now().Sub(e.CreatedAt)
		pong, _ := ServerStatus.Ping(e.HostName)
		//beego.Debug(pong.Players.Online,pong.Players.Max)
		pongs = append(pongs, pong)
		infoTotalOnline += pong.Players.Online
	}
	//beego.Debug(pongs)
	this.Data["infoTotalUpTime"] = durafmt.Parse(infoTotalUpTime).LimitFirstN(3).String()
	this.Data["infoTotalOnline"] = infoTotalOnline
	for i, p := range pongs {
		if p.Version.Protocol == 0 {
			servers = append(servers, serverInfo{
				ServerIsOnline:     false,
				ServerIconData:     "",
				ServerName:         entities[i].ServerExternalID,
				ServerEXP:          entities[i].ValidDate.Format("2006-01-02 15:04:05"),
				ServerDescription:  "服务器已离线",
				ServerPlayerOnline: 0,
				ServerPlayerMax:    0,
			})
		} else {
			var des string
			if p.Description.Text != "" {
				des = p.Description.Text
			} else if p.Description.Translate != "" {
				des = p.Description.Translate
			} else {
				des = "暂时无法解析这种 MOTD 😭"
			}
			icon := template.URL(p.FavIcon)
			servers = append(servers, serverInfo{
				ServerIsOnline:     true,
				ServerIconData:     icon,
				ServerName:         entities[i].ServerExternalID,
				ServerEXP:          entities[i].ValidDate.Format("2006-01-02 15:04:05"),
				ServerDescription:  des,
				ServerPlayerOnline: p.Players.Online,
				ServerPlayerMax:    p.Players.Max,
			})
		}
	}
	//beego.Info(servers)
	this.Data["servers"] = servers
}
