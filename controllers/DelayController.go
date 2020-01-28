package controllers

import (
	"github.com/astaxie/beego"
)

type DelayController struct {
	beego.Controller
}

func (this *DelayController) Get() {
	this.TplName = "Delay.html"
	this.Data["detail"] = this.Ctx.Input.Param(":detail")
	this.Data["URL"] = this.Ctx.Input.Param(":URL")
}

func DelayRedirect(URL string, detail string, c *beego.Controller) {
	c.Redirect("/delay/"+URL+"/"+detail, 302)
}
