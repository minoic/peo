package controllers

import (
	"github.com/astaxie/beego"
)

type ConfirmController struct {
	beego.Controller
}

func (this *ConfirmController) Get() {
	DelayRedirect("www.baidu.com", "hahaha", &this.Controller)
}
