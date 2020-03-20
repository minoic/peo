package Controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/MinoConfigure"
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
	this.Data["detail"] = this.GetString("detail")
	this.Data["URL"] = this.GetString("URL")
	this.Data["title"] = this.GetString("title")
}

func DelayRedirect(info DelayInfo, c *beego.Controller) {
	c.Redirect("/delay/?URL="+info.URL+"&title="+info.Title+"&detail="+info.Detail, 302)
}

func DelayRedirectGetURL(info DelayInfo) string {
	return MinoConfigure.WebHostName + "/delay/?URL=" + info.URL + "&title=" + info.Title + "&detail=" + info.Detail
}
