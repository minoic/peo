package controllers

import (
	"NTPE/models"
	"github.com/astaxie/beego"
)

type IndexController struct {
	beego.Controller
}

func (this *IndexController) Get() {
	this.TplName = "Index.html"
	params := models.ParamsData{
		Serverhostname: "pte.nightgod.xyz",
		Serversecure:   false,
		Serverpassword: "1qdsZGuaObjB9CkRtpqZLB6Q8SfH1txRsRJSEgRkMVZCEIHw",
	}
	models.Test()
	if user, exist := models.PterodactylGetUser(params, 1); exist {
		beego.Info(user)
	} else {
		beego.Info("user not found")
	}

}
