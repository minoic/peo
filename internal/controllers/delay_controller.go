package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/minoic/peo/internal/configure"
	"strconv"
)

type DelayController struct {
	web.Controller
}

type DelayInfo struct {
	URL    string
	Detail string
	Title  string
}

func (this *DelayController) Get() {
	this.TplName = "Delay.html"
	this.Data["detail"] = this.GetString("detail")
	this.Data["URL"] = this.GetString("URL")
	this.Data["title"] = this.GetString("title")
	// code,_:=this.GetInt("code",200)
}

func DelayRedirect(info DelayInfo, c *web.Controller, code ...int) {
	if len(code) != 0 {
		c.Redirect("/delay/?URL="+info.URL+"&title="+info.Title+"&detail="+info.Detail+"&code="+strconv.Itoa(code[0]), 302)
	} else {
		c.Redirect("/delay/?URL="+info.URL+"&title="+info.Title+"&detail="+info.Detail+"&code=200", 302)
	}
}

func DelayRedirectGetURL(info DelayInfo) string {
	return configure.Viper().GetString("WebHostName") + "/delay/?URL=" + info.URL + "&title=" + info.Title + "&detail=" + info.Detail
}
