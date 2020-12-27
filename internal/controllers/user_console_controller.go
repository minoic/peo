package controllers

import (
	"github.com/MinoIC/glgf"
	"github.com/MinoIC/peo/internal/configure"
	"github.com/MinoIC/peo/internal/database"
	"github.com/MinoIC/peo/internal/message"
	"github.com/MinoIC/peo/internal/pterodactyl"
	"github.com/MinoIC/peo/internal/session"
	"github.com/MinoIC/peo/internal/status"
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
	PteInfo            *pterodactyl.Server
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
	ServerRenew2URL    template.URL
	ServerReinstallURL template.URL
	ServerModList      []struct {
		ModText string
	}
	ServerModCount int
	ServerPacks    []database.Pack
}

func (this *UserConsoleController) Prepare() {
	if !session.SessionIslogged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.Data["i"] = 1
	this.Data["u"] = 3
}

var (
	entityMap sync.Map
	waiting   = serverInfo{
		ServerIsOnline:    false,
		ServerIconData:    "",
		ServerName:        "正在加载",
		ServerDescription: "后台正在等待第一次获取信息",
	}
)

func RefreshServerInfo() {
	DB := database.GetDatabase()
	cli := pterodactyl.ClientFromConf()
	var (
		pongsSync struct {
			pongs []status.Pong
		}
		wg       sync.WaitGroup
		entities []database.WareEntity
	)
	DB.Find(&entities)
	pongsSync.pongs = make([]status.Pong, len(entities))
	wg.Add(len(entities))
	for i, e := range entities {
		go func(host string, index int) {
			defer wg.Done()
			pongTemp, err := status.Ping(host)
			if err != nil {
				pongsSync.pongs[index] = status.Pong{}
			} else {
				pongsSync.pongs[index] = *pongTemp
			}
			// glgf.Info(pongTemp,host)
			/* different index dont need Lock*/
			// glgf.Info(len(pongsSync.pongs))
		}(e.HostName, i)
		// glgf.Debug(pong.Players.Online,pong.Players.Max)
	}
	wg.Wait()
	// glgf.Debug(pongs)
	for i, p := range pongsSync.pongs {
		pteServer, err := cli.GetServer(entities[i].ServerExternalID)
		if err != nil {
			temp, ok := entityMap.Load(entities[i].ID)
			if ok {
				pteServer = temp.(serverInfo).PteInfo
			}
		}
		if pteServer == nil {
			pteServer = &pterodactyl.Server{}
		}
		var info serverInfo
		info.PteInfo = pteServer
		if p.Version.Protocol == 0 {
			/* server is offline*/
			info = serverInfo{
				ServerIsOnline:     false,
				ServerName:         pteServer.Name,
				ServerEXP:          entities[i].ValidDate.Format("2006-01-02 15:04:05"),
				ServerDescription:  "服务器已离线",
				ServerHostName:     entities[i].HostName,
				ServerIdentifier:   pteServer.Identifier,
				ServerIndex:        strconv.Itoa(i),
				ServerRenewURL:     template.URL(configure.WebHostName + "/user-console/renew/" + strconv.Itoa(int(entities[i].ID))),
				ServerRenew2URL:    template.URL(configure.WebHostName + "/user-console/renew2/" + strconv.Itoa(int(entities[i].ID))),
				ServerReinstallURL: template.URL(configure.WebHostName + "/user-console/reinstall/" + strconv.Itoa(int(entities[i].ID))),
				ConsoleHostName:    cli.HostName(),
			}
		} else {
			/* server is online*/
			icon := template.URL(p.FavIcon)
			info = serverInfo{
				ServerIsOnline:     true,
				ServerIconData:     icon,
				ServerName:         pteServer.Name,
				ServerEXP:          entities[i].ValidDate.Format("2006-01-02"),
				ServerDescription:  p.Description.Des,
				ServerPlayerOnline: p.Players.Online,
				ServerPlayerMax:    p.Players.Max,
				ServerHostName:     entities[i].HostName,
				ServerIdentifier:   pteServer.Identifier,
				ConsoleHostName:    cli.HostName(),
				ServerFMLType:      p.ModInfo.ModType,
				ServerVersion:      p.Version.Name,
				ServerIndex:        strconv.Itoa(i),
				ServerRenewURL:     template.URL(configure.WebHostName + "/user-console/renew/" + strconv.Itoa(int(entities[i].ID))),
				ServerRenew2URL:    template.URL(configure.WebHostName + "/user-console/renew2/" + strconv.Itoa(int(entities[i].ID))),
				ServerReinstallURL: template.URL(configure.WebHostName + "/user-console/reinstall/" + strconv.Itoa(int(entities[i].ID))),
			}
			if info.ServerFMLType != "" {
				for _, f := range p.ModInfo.ModList {
					info.ServerModList = append(info.ServerModList, struct{ ModText string }{ModText: f.ModID + " " + f.ModVersion})
				}
				info.ServerModCount = len(info.ServerModList)
			}
		}
		/* no matter server is online or offline*/
		DB.Where("nest_id = ? AND egg_id = ?", pteServer.NestId, pteServer.EggId).Find(&info.ServerPacks)
		if len(info.ServerPacks) == 0 {
			info.ServerPacks = append(info.ServerPacks, database.Pack{
				Model:    gorm.Model{},
				PackName: "没有可以安装的包",
				PackID:   -1,
			})
		}
		entityMap.Store(entities[i].ID, info)
	}

}

func (this *UserConsoleController) Get() {
	this.TplName = "UserConsole.html"
	sess := this.StartSession()
	user, _ := session.SessionGetUser(sess)
	this.Data["userName"] = user.Name
	DB := database.GetDatabase()
	this.Data["infoTotalUpTime"] = durafmt.Parse(user.TotalUpTime).LimitFirstN(2).String()
	var (
		orders          []database.Order
		entities        []database.WareEntity
		infoTotalOnline int
	)
	if !user.IsAdmin {
		DB.Where("user_id = ?", user.ID).Find(&entities)
	} else {
		DB.Find(&entities)
	}
	DB.Where("user_id = ?", user.ID).Find(&orders)
	this.Data["infoOrderCount"] = len(orders)
	this.Data["infoServerCount"] = len(entities)
	// glgf.Info(servers)
	servers := make([]serverInfo, len(entities))
	for i := range entities {
		tmp, ok := entityMap.Load(entities[i].ID)
		if ok {
			servers[i] = tmp.(serverInfo)
			infoTotalOnline += servers[i].ServerPlayerOnline
		} else {
			servers[i] = waiting
		}
	}
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
	DB := database.GetDatabase()
	var (
		entity database.WareEntity
		key    database.WareKey
		spec   database.WareSpec
	)
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("找不到指定服务器"))
		return
	}
	if DB.Where("key_string = ?", keyString).First(&key).RecordNotFound() {
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
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("缓存设置失败！"))
		return
	}
	if DB.Delete(&key).Error != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库处理失败！"))
		return
	}
	if DB.Model(&entity).Update("valid_date", entity.ValidDate.Add(spec.ValidDuration)).Update("delete_status", 0).Error != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("修改服务有效期失败！"))
		DB.Create(&key)
		return
	}
	pteServer, err := pterodactyl.ClientFromConf().GetServer(entity.ServerExternalID)
	if err != nil {
		message.Send("ADMIN", entity.UserID, "您的服务器已续费，但翼龙面板备注修改失败，您可以联系管理员修改！")
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	if err := pterodactyl.ClientFromConf().UpdateServerDetail(entity.ServerExternalID, pterodactyl.PostUpdateDetails{
		UserID:      pteServer.UserId,
		ServerName:  pteServer.Name,
		Description: "到期时间：" + entity.ValidDate.Format("2006-01-02"),
		ExternalID:  pteServer.ExternalId,
	}); err != nil {
		glgf.Error(err)
		message.Send("ADMIN", entity.UserID, "您的服务器已续费，但翼龙面板备注修改失败，您可以联系管理员修改！")
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserConsoleController) Renew2() {
	entityID := this.Ctx.Input.Param(":entity")
	eid, err := strconv.Atoi(entityID)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法获取服务器编号"))
		return
	}
	DB := database.GetDatabase()
	user, err := session.SessionGetUser(this.StartSession())
	if err != nil {
		glgf.Warn(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("获取用户信息失败"))
		return
	}
	var entity database.WareEntity
	if DB.Where("id = ?", eid).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("找不到指定服务器"))
		return
	}
	var spec database.WareSpec
	if DB.Where("id = ?", entity.SpecID).First(&spec).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法获取对应商品"))
		return
	}
	cost := spec.PricePerMonth * uint(100-spec.Discount) / 100
	if cost > user.Balance {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("余额不足"))
		return
	}
	if err := DB.Model(&user).Update("balance", user.Balance-cost).Error; err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库错误"))
		return
	}
	if DB.Model(&entity).Update("valid_date", entity.ValidDate.AddDate(0, 1, 0)).Update("delete_status", 0).Error != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("修改服务有效期失败！"))
		return
	}
	pteServer, err := pterodactyl.ClientFromConf().GetServer(entity.ServerExternalID)
	if err != nil {
		message.Send("ADMIN", entity.UserID, "您的服务器已续费，但翼龙面板备注修改失败，您可以联系管理员修改！")
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	if err := pterodactyl.ClientFromConf().UpdateServerDetail(entity.ServerExternalID, pterodactyl.PostUpdateDetails{
		UserID:      pteServer.UserId,
		ServerName:  pteServer.Name,
		Description: "到期时间：" + entity.ValidDate.Format("2006-01-02"),
		ExternalID:  pteServer.ExternalId,
	}); err != nil {
		glgf.Error(err)
		message.Send("ADMIN", entity.UserID, "您的服务器已续费，但翼龙面板备注修改失败，您可以联系管理员修改！")
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserConsoleController) Reinstall() {
	user, err := session.SessionGetUser(this.StartSession())
	if err != nil {
		// glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	if bm.IsExist("REINSTALL" + user.Name) {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您每 10 秒只能重装一次服务器"))
		return
	}
	entityID := this.Ctx.Input.Param(":entityID")
	packIDstring := this.Ctx.Input.Param(":packID")
	packID, err := strconv.Atoi(packIDstring)
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("输入了无效的PackID"))
		return
	}
	if packID == -1 {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法安装这个包"))
		return
	}
	DB := database.GetDatabase()
	var entity database.WareEntity
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("找不到指定服务器"))
		return
	}
	if entity.UserID != user.ID && !user.IsAdmin {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您没有权限操作他人服务器"))
		return
	}
	if err = pterodactyl.ClientFromConf().UpdateServerStartup(entity.ServerExternalID, packID); err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("重装服务器失败！"))
		return
	}
	_ = bm.Put("REINSTALL"+user.Name, "", 10*time.Second)
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}
