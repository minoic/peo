package controllers

import (
	"github.com/astaxie/beego"
)

type ConfirmController struct {
	beego.Controller
}

func (this *ConfirmController) Get() {
	DelayRedirect(DelayInfo{
		URL:    "www.baidu.com",
		Detail: "hahahahha",
		Title:  "delay",
	}, &this.Controller)
}
