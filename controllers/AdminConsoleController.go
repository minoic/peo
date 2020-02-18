package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"html/template"
	"strconv"
)

type AdminConsoleController struct {
	beego.Controller
}

func (this *AdminConsoleController) Prepare() {
	this.TplName = "AdminConsole.html"
	this.Data["u"] = 4
	handleNavbar(&this.Controller)
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转到登录",
			Title:  "您还没有登录",
		}, &this.Controller)
	} else if !MinoSession.SessionIsAdmin(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName,
			Detail: "正在跳转到主页",
			Title:  "您不是管理员",
		}, &this.Controller)
	}
	DB := MinoDatabase.GetDatabase()
	var (
		dib           []MinoDatabase.DeleteConfirm
		deleteServers []struct {
			ServerName            string
			ServerConsoleHostName template.URL
			ServerIdentifier      string
			DeleteURL             template.URL
			ServerOwner           string
			ServerEXP             string
			ServerHostName        string
		}
	)
	DB.Find(&dib)
	for i, d := range dib {
		var entity MinoDatabase.WareEntity
		if DB.Where("id = ?", d.WareID).First(&entity).RecordNotFound() {
			DB.Delete(&d)
		} else {
			pteServer := PterodactylAPI.GetServer(PterodactylAPI.ConfGetParams(), entity.ServerExternalID)
			deleteServers = append(deleteServers, struct {
				ServerName            string
				ServerConsoleHostName template.URL
				ServerIdentifier      string
				DeleteURL             template.URL
				ServerOwner           string
				ServerEXP             string
				ServerHostName        string
			}{
				ServerName:            pteServer.Name,
				ServerConsoleHostName: template.URL(PterodactylAPI.PterodactylGethostname(PterodactylAPI.ConfGetParams()) + "/server/" + pteServer.Identifier),
				ServerIdentifier:      pteServer.Identifier,
				DeleteURL:             template.URL(MinoConfigure.WebHostName + "/admin-console/delete-confirm/" + strconv.Itoa(int(entity.ID))),
				ServerOwner:           entity.UserExternalID,
				ServerEXP:             entity.ValidDate.Format("2006-01-02"),
				ServerHostName:        entity.HostName,
			})
			if deleteServers[i].ServerName == "" {
				deleteServers[i].ServerName = "无法获取服务器名称"
			}
			if deleteServers[i].ServerIdentifier == "" {
				deleteServers[i].ServerIdentifier = "无法获取编号"
			}
		}

	}
	//beego.Debug(deleteServers)
	this.Data["deleteServers"] = deleteServers
}

func (this *AdminConsoleController) Get() {}

func (this *AdminConsoleController) DeleteConfirm() {
	entityID := this.Ctx.Input.Param(":entityID")
	entityIDint, err := strconv.Atoi(entityID)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("FAILED"))
	}
	if err := PterodactylAPI.ConfirmDelete(uint(entityIDint)); err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("FAILED"))
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}
