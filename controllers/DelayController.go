package controllers

import (
	"github.com/astaxie/beego"
)

type DelayController struct {
	beego.Controller
}

type DelayInfo struct {
	URL    string
	Detail string
	Title  string
}

func (this *DelayController) Get() {
	this.TplName = "Delay.html"
	this.Data["detail"] = this.Ctx.Input.Param(":detail")
	this.Data["URL"] = this.Ctx.Input.Param(":URL")
	this.Data["title"] = this.Ctx.Input.Param("title")
	this.Data["time"] = this.Ctx.Input.Param("time")
}

func DelayRedirect(info DelayInfo, c *beego.Controller) {
	c.Redirect("/delay/"+info.URL+"/"+info.Title+"/"+info.Detail, 302)
}
