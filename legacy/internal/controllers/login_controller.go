package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/session"
)

type LoginController struct {
	web.Controller
	i18n.Locale
}

func (this *LoginController) Prepare() {
	this.TplName = "Login.html"
	handleNavbar(&this.Controller)

}

func (this *LoginController) Get() {}

func (this *LoginController) Post() {
	DB := database.Mysql()
	loginEOU := this.GetString("loginEOU")
	loginPass := this.GetString("loginPass")
	loginRemember, err := this.GetBool("loginRemember", false)
	if err != nil {
		glgf.Error(err)
	}
	var user database.User
	if !DB.Where("email = ?", loginEOU).Or("name = ?", loginEOU).First(&user).RecordNotFound() {
		b := md5.Sum([]byte(loginPass + configure.Viper().GetString("DatabaseSalt")))
		if hex.EncodeToString(b[:]) == user.Password {
			this.SetSession("LST", session.GeneToken(user.Name, loginRemember))
			this.SetSession("ID", user.ID)
			this.SetSession("UN", user.Name)
			DelayRedirect(DelayInfo{
				URL:    "/",
				Detail: tr("auth.login_success_title"),
				Title:  tr("auth.login_success_detail"),
			}, &this.Controller)
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = tr("auth.wrong_password")
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.user_invalid")
	}
}
