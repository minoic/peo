package controllers

import (
	"context"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/hako/durafmt"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/session"
	"github.com/minoic/peo/internal/status"
	"html/template"
	"strconv"
	"sync"
	"time"
)

type UserConsoleController struct {
	web.Controller
	i18n.Locale
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
	ServerEggs     []pterodactyl.Egg
}

func (this *UserConsoleController) Prepare() {
	if !session.Logged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.Data["i"] = 1
	this.Data["u"] = 3

}

var (
	entityMap sync.Map
	EggsMap   sync.Map
	waiting   = serverInfo{
		ServerIsOnline:    false,
		ServerIconData:    "",
		ServerName:        tr("loading"),
		ServerDescription: tr("backend_waiting"),
	}
)

func RefreshServerInfo() {
	DB := database.Mysql()
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
	for i, e := range entities {
		wg.Add(1)
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
		pteServer, err := cli.GetServer(entities[i].ServerExternalID, true)
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
				ServerDescription:  tr("offline"),
				ServerHostName:     entities[i].HostName,
				ServerIdentifier:   pteServer.Identifier,
				ServerIndex:        strconv.Itoa(i),
				ServerRenewURL:     template.URL(configure.Viper().GetString("WebHostName") + "/user-console/renew/" + strconv.Itoa(int(entities[i].ID))),
				ServerRenew2URL:    template.URL(configure.Viper().GetString("WebHostName") + "/user-console/renew2/" + strconv.Itoa(int(entities[i].ID))),
				ServerReinstallURL: template.URL(configure.Viper().GetString("WebHostName") + "/user-console/reinstall/" + strconv.Itoa(int(entities[i].ID))),
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
				ServerFMLType:      p.ModInfo.ModType,
				ServerVersion:      p.Version.Name,
				ServerIndex:        strconv.Itoa(i),
				ServerRenewURL:     template.URL(configure.Viper().GetString("WebHostName") + "/user-console/renew/" + strconv.Itoa(int(entities[i].ID))),
				ServerRenew2URL:    template.URL(configure.Viper().GetString("WebHostName") + "/user-console/renew2/" + strconv.Itoa(int(entities[i].ID))),
				ServerReinstallURL: template.URL(configure.Viper().GetString("WebHostName") + "/user-console/reinstall/" + strconv.Itoa(int(entities[i].ID))),
			}
			if info.ServerFMLType != "" {
				for _, f := range p.ModInfo.ModList {
					info.ServerModList = append(info.ServerModList, struct{ ModText string }{ModText: f.ModID + " " + f.ModVersion})
				}
				info.ServerModCount = len(info.ServerModList)
			}
		}
		/* no matter server is online or offline*/

		eggsv, ok := EggsMap.Load(pteServer.NestId)
		if ok {
			eggs := eggsv.([]pterodactyl.Egg)
			info.ServerEggs = append(info.ServerEggs, eggs...)
			if len(info.ServerEggs) == 0 {
				info.ServerEggs = append(info.ServerEggs, pterodactyl.Egg{
					Id:   -1,
					Nest: pteServer.NestId,
					Name: tr("no_packs"),
				})
			}
		}
		entityMap.Store(entities[i].ID, info)
	}

}

func (this *UserConsoleController) Get() {
	this.TplName = "UserConsole.html"
	sess := this.StartSession()
	user, _ := session.GetUser(sess)
	this.Data["userName"] = user.Name
	DB := database.Mysql()
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
	if database.Redis().Get(context.Background(), "RENEW"+entityIDString).Err() == nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("renew_limit")))
		return
	}
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_server_id")))
		return
	}
	DB := database.Mysql()
	var (
		entity database.WareEntity
		key    database.WareKey
		spec   database.WareSpec
	)
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_server")))
		return
	}
	if DB.Where("key_string = ?", keyString).First(&key).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("invalid_key")))
		return
	}
	if DB.Where("id = ?", key.SpecID).First(&spec).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_ware_spec")))
		return
	}
	if key.SpecID != entity.SpecID {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("wrong_key_type")))
		return
	}
	/* correct renew post */
	if err = database.Redis().Set(context.Background(), "RENEW"+entityIDString, "", 10*time.Second).Err(); err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(err.Error()))
		return
	}
	if DB.Delete(&key).Error != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(err.Error()))
		return
	}
	startDate := entity.ValidDate
	if time.Now().After(entity.ValidDate) {
		startDate = time.Now()
	}
	if DB.Model(&entity).Update("valid_date", startDate.Add(spec.ValidDuration)).Update("delete_status", 0).Error != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("cant_edit_server")))
		DB.Create(&key)
		return
	}
	pteServer, err := pterodactyl.ClientFromConf().GetServer(entity.ServerExternalID, true)
	if err != nil {
		message.Send("ADMIN", entity.UserID, tr("edit_without_description"))
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	if err := pterodactyl.ClientFromConf().UpdateServerDetail(entity.ServerExternalID, pterodactyl.PostUpdateDetails{
		UserID:      pteServer.UserId,
		ServerName:  pteServer.Name,
		Description: tr("user_console.expire_time") + entity.ValidDate.Format("2006-01-02"),
		ExternalID:  pteServer.ExternalId,
	}); err != nil {
		glgf.Error(err)
		message.Send("ADMIN", entity.UserID, tr("edit_without_description"))
	}
	if err = pterodactyl.ClientFromConf().UnsuspendServer(entity.ServerExternalID); err != nil {
		glgf.Error(err)
		message.Send("ADMIN", entity.UserID, tr("edit_without_unsuspend"))
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserConsoleController) Renew2() {
	entityID := this.Ctx.Input.Param(":entity")
	eid, err := strconv.Atoi(entityID)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_server_id")))
		return
	}
	DB := database.Mysql()
	user, err := session.GetUser(this.StartSession())
	if err != nil {
		glgf.Warn(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_user")))
		return
	}
	var entity database.WareEntity
	if DB.Where("id = ?", eid).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_server")))
		return
	}
	var spec database.WareSpec
	if DB.Where("id = ?", entity.SpecID).First(&spec).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_ware_spec")))
		return
	}
	cost := spec.PricePerMonth * uint(100-spec.Discount) / 100
	if cost > user.Balance {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("not_enough_balance")))
		return
	}
	if err := DB.Model(&user).Update("balance", user.Balance-cost).Error; err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(err.Error()))
		return
	}
	if DB.Model(&entity).Update("valid_date", entity.ValidDate.AddDate(0, 1, 0)).Update("delete_status", 0).Error != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("cant_edit_server")))
		return
	}
	pteServer, err := pterodactyl.ClientFromConf().GetServer(entity.ServerExternalID, true)
	if err != nil {
		message.Send("ADMIN", entity.UserID, tr("edit_without_description"))
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
		message.Send("ADMIN", entity.UserID, tr("edit_without_description"))
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserConsoleController) Reinstall() {
	user, err := session.GetUser(this.StartSession())
	if err != nil {
		// glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("login")))
		return
	}
	if database.Redis().Get(context.Background(), "REINSTALL"+user.Name).Err() == nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("reinstall_limit")))
		return
	}
	entityID := this.Ctx.Input.Param(":entityID")
	eggIDstring := this.Ctx.Input.Param(":eggID")
	eggID, err := strconv.Atoi(eggIDstring)
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(err.Error()))
		return
	}
	DB := database.Mysql()
	var entity database.WareEntity
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_server")))
		return
	}
	if entity.UserID != user.ID && !user.IsAdmin {
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("no_permission")))
		return
	}
	if err = pterodactyl.ClientFromConf().UpdateServerStartup(entity.ServerExternalID, eggID); err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("cant_update_server")))
		return
	}
	if err = pterodactyl.ClientFromConf().ReinstallServer(entity.ServerExternalID); err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte(tr("cant_reinstall_server")))
		return
	}
	_ = database.Redis().Set(context.Background(), "REINSTALL"+user.Name, "", 10*time.Second)
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}
