package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"strconv"
)

type ConfirmDeleteController struct {
	beego.Controller
}

func (this *ConfirmDeleteController) Get() {
	this.TplName = "Index.html"
	wareID, _ := strconv.Atoi(this.Ctx.Input.Param(":wareID"))
	PterodactylAPI.ConfirmDelete(uint(wareID))
	DelayRedirect(DelayInfo{
		URL:    MinoConfigure.ConfGetHostName(),
		Detail: "正在跳转至主页",
		Title:  "删除完成",
	}, &this.Controller)
}
