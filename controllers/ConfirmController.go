package controllers

import (
	"NTPE/models"
	"NTPE/models/MinoEmail"
	"github.com/astaxie/beego"
)

type ConfirmController struct {
	beego.Controller
}

func (this *ConfirmController) Get() {
	key := this.Ctx.Input.Param(":key")
	ok := MinoEmail.ConfirmKey(key)
	if ok {
		DelayRedirect(DelayInfo{
			URL:    models.ConfGetHostName() + "/login",
			Detail: "即将跳转到登陆页面",
			Title:  "注册验证成功！",
		}, &this.Controller)
	} else {
		DelayRedirect(DelayInfo{
			URL:    models.ConfGetHostName() + "/login",
			Detail: "即将跳转到登陆页面",
			Title:  "注册验证失败！请重新验证！",
		}, &this.Controller)
	}
	this.TplName = "Delay.html"
}
