package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoMessage"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"git.ntmc.tech/root/MinoIC-PE/models/ServerStatus"
	"github.com/astaxie/beego"
	"github.com/hako/durafmt"
	"github.com/jinzhu/gorm"
	"html/template"
	"strconv"
	"sync"
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
	ServerHostName     string
	ServerIdentifier   string
	ConsoleHostName    string
	ServerFMLType      string
	ServerVersion      string
	ServerIndex        string
	ServerRenewURL     template.URL
	ServerReinstallURL template.URL
	ServerModList      []struct {
		ModText string
	}
	ServerModCount int
	ServerPacks    []MinoDatabase.Pack
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
	this.Data["i"] = 1
	this.Data["u"] = 3
}

func (this *UserConsoleController) Get() {
	this.TplName = "UserConsole.html"
	sess := this.StartSession()
	user, _ := MinoSession.SessionGetUser(sess)
	this.Data["userName"] = user.Name
	DB := MinoDatabase.GetDatabase()
	var (
		entities        []MinoDatabase.WareEntity
		orders          []MinoDatabase.Order
		infoTotalUpTime time.Duration
		infoTotalOnline int
		wg              sync.WaitGroup
		servers         []serverInfo
	)
	DB.Where("user_id = ?", user.ID).Find(&entities)
	DB.Where("user_id = ?", user.ID).Find(&orders)
	this.Data["infoOrderCount"] = len(orders)
	this.Data["infoServerCount"] = len(entities)
	var pongsSync struct {
		pongs []ServerStatus.Pong
	}
	pongsSync.pongs = make([]ServerStatus.Pong, len(entities))
	for i, e := range entities {
		infoTotalUpTime += time.Now().Sub(e.CreatedAt)
		wg.Add(1)
		go func(host string, index int) {
			pongTemp, _ := ServerStatus.Ping(host)
			//beego.Info(pongTemp,host)
			/* different index dont need Lock*/
			pongsSync.pongs[index] = pongTemp
			//beego.Info(len(pongsSync.pongs))
			wg.Done()
		}(e.HostName, i)
		//beego.Debug(pong.Players.Online,pong.Players.Max)
	}
	wg.Wait()
	//beego.Debug(pongs)
	this.Data["infoTotalUpTime"] = durafmt.Parse(infoTotalUpTime).LimitFirstN(2).String()
	for i, p := range pongsSync.pongs {
		pteServer := PterodactylAPI.GetServer(PterodactylAPI.ConfGetParams(), entities[i].ServerExternalID)
		infoTotalOnline += p.Players.Online
		if p.Version.Protocol == 0 {
			/* server is offline*/
			servers = append(servers, serverInfo{
				ServerIsOnline:     false,
				ServerIconData:     "",
				ServerName:         pteServer.Name,
				ServerEXP:          entities[i].ValidDate.Format("2006-01-02 15:04:05"),
				ServerDescription:  "服务器已离线",
				ServerPlayerOnline: 0,
				ServerPlayerMax:    0,
				ServerHostName:     entities[i].HostName,
				ServerIdentifier:   pteServer.Identifier,
				ServerIndex:        strconv.Itoa(i),
				ServerRenewURL:     template.URL(MinoConfigure.WebHostName + "/user-console/renew/" + strconv.Itoa(int(entities[i].ID))),
				ServerReinstallURL: template.URL(MinoConfigure.WebHostName + "/user-console/reinstall/" + strconv.Itoa(int(entities[i].ID))),
				ConsoleHostName:    PterodactylAPI.PterodactylGethostname(PterodactylAPI.ConfGetParams()),
			})
		} else {
			/* server is online*/
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
				ServerName:         pteServer.Name,
				ServerEXP:          entities[i].ValidDate.Format("2006-01-02"),
				ServerDescription:  des,
				ServerPlayerOnline: p.Players.Online,
				ServerPlayerMax:    p.Players.Max,
				ServerHostName:     entities[i].HostName,
				ServerIdentifier:   pteServer.Identifier,
				ConsoleHostName:    PterodactylAPI.PterodactylGethostname(PterodactylAPI.ConfGetParams()),
				ServerFMLType:      p.ModInfo.ModType,
				ServerVersion:      p.Version.Name,
				ServerIndex:        strconv.Itoa(i),
				ServerRenewURL:     template.URL(MinoConfigure.WebHostName + "/user-console/renew/" + strconv.Itoa(int(entities[i].ID))),
				ServerReinstallURL: template.URL(MinoConfigure.WebHostName + "/user-console/reinstall/" + strconv.Itoa(int(entities[i].ID))),
			})
			if servers[i].ServerFMLType != "" {
				for _, f := range p.ModInfo.ModList {
					servers[i].ServerModList = append(servers[i].ServerModList, struct{ ModText string }{ModText: f.ModID + " " + f.ModVersion})
				}
				servers[i].ServerModCount = len(servers[i].ServerModList)
			}
		}
		/* no matter server is online or offline*/
		DB.Where("nest_id = ? AND egg_id = ?", pteServer.NestId, pteServer.EggId).Find(&servers[i].ServerPacks)
		if len(servers[i].ServerPacks) == 0 {
			servers[i].ServerPacks = append(servers[i].ServerPacks, MinoDatabase.Pack{
				Model:           gorm.Model{},
				PackName:        "没有可以安装的包",
				NestID:          0,
				EggID:           0,
				PackID:          -1,
				PackDescription: "",
			})
		}
	}
	//beego.Info(servers)
	this.Data["servers"] = servers
	this.Data["infoTotalOnline"] = infoTotalOnline

}

func (this *UserConsoleController) Renew() {
	keyString := this.Ctx.Input.Param(":key")
	entityIDString := this.Ctx.Input.Param(":entityID")
	entityID, err := strconv.Atoi(entityIDString)
	if bm.IsExist("RENEW" + entityIDString) {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("同一个服务器 10 秒内只能续费一次"))
		return
	}
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法获取服务器编号"))
		return
	}
	DB := MinoDatabase.GetDatabase()
	var (
		entity MinoDatabase.WareEntity
		key    MinoDatabase.WareKey
		spec   MinoDatabase.WareSpec
	)
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("找不到指定服务器"))
		return
	}
	if DB.Where("key = ?", keyString).First(&key).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无效的 KEY"))
		return
	}
	if DB.Where("id = ?", key.SpecID).First(&spec).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法获取对应商品"))
		return
	}
	if key.SpecID != entity.SpecID {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("该 KEY 不能用来续费本服务器"))
		return
	}
	/* correct renew post */
	if err = bm.Put("RENEW"+entityIDString, "", 10*time.Second); err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("缓存设置失败！"))
		return
	}
	if DB.Delete(&key).Error != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库处理失败！"))
		return
	}
	if DB.Model(&entity).Update("valid_date", entity.ValidDate.Add(spec.ValidDuration)).Update("delete_status", 0).Error != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("修改服务有效期失败！"))
		DB.Create(&key)
		return
	}
	pteServer := PterodactylAPI.GetServer(PterodactylAPI.ConfGetParams(), entity.ServerExternalID)
	if pteServer == (PterodactylAPI.PterodactylServer{}) {
		MinoMessage.Send("ADMIN", entity.UserID, "您的服务器已续费，但翼龙面板备注修改失败，您可以联系管理员修改！")
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	if err := PterodactylAPI.PterodactylUpdateServerDetail(PterodactylAPI.ConfGetParams(), entity.ServerExternalID, PterodactylAPI.PostUpdateDetails{
		UserID:      pteServer.UserId,
		ServerName:  pteServer.Name,
		Description: "到期时间：" + entity.ValidDate.Format("2006-01-02"),
		ExternalID:  pteServer.ExternalId,
	}); err != nil {
		MinoMessage.Send("ADMIN", entity.UserID, "您的服务器已续费，但翼龙面板备注修改失败，您可以联系管理员修改！")
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserConsoleController) Reinstall() {
	user, err := MinoSession.SessionGetUser(this.StartSession())
	if err != nil {
		//beego.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	if bm.IsExist("REINSTALL" + user.Name) {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您每分钟只能重装一次服务器"))
		return
	}
	entityID := this.Ctx.Input.Param(":entityID")
	packIDstring := this.Ctx.Input.Param(":packID")
	packID, err := strconv.Atoi(packIDstring)
	if err != nil {
		//beego.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("输入了无效的PackID"))
		return
	}
	if packID == -1 {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法安装这个包"))
		return
	}
	DB := MinoDatabase.GetDatabase()
	var entity MinoDatabase.WareEntity
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("找不到指定服务器"))
		return
	}
	if entity.UserID != user.ID && !user.IsAdmin {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您没有权限操作他人服务器"))
		return
	}
	if err = PterodactylAPI.PterodactylUpdateServerStartup(PterodactylAPI.ConfGetParams(), entity.ServerExternalID, packID); err != nil {
		beego.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("重装服务器失败！"))
		return
	}
	_ = bm.Put("REINSTALL"+user.Name, "", time.Minute)
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}
