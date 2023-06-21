package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/jinzhu/gorm"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/session"
	"strconv"
	"strings"
)

type DelayController struct {
	web.Controller
	i18n.Locale
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
	return "/delay/?URL=" + info.URL + "&title=" + info.Title + "&detail=" + info.Detail
}

type DelayLoginController struct {
	web.Controller
}

func (this *DelayLoginController) Get() {
	user, err := session.GetUser(this.StartSession())
	if err != nil {
		this.Abort("401")
		return
	}
	token, err := pterodactyl.ClientFromConf().Login(user.Email, getPterodactylPassword(&user))
	if err != nil {
		glgf.Error(err)
	}
	_, after, _ := strings.Cut(configure.Viper().GetString("WebHostName"), ".")
	this.Ctx.SetCookie("pterodactyl_session", token, 43200, "/", "."+after, true, false, "None")
	this.Redirect(configure.Viper().GetString("PterodactylHostname")+"/auth/login", 302)
	//this.Redirect("/", 302)
}

func getPterodactylPassword(user *database.User) string {
	var pp database.PterodactylPassword
	err := database.Mysql().First(&pp, "user_id = ?", user.ID).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			pp.UserID = user.ID
			pp.Password = user.Name
			database.Mysql().Create(&pp)
			return user.Name
		} else {
			glgf.Error(err)
			return ""
		}
	}
	return pp.Password
}
