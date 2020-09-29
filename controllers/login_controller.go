package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"github.com/MinoIC/glgf"
	"github.com/MinoIC/peo/configure"
	"github.com/MinoIC/peo/database"
	"github.com/MinoIC/peo/session"
	"github.com/astaxie/beego"
)

type LoginController struct {
	beego.Controller
}

func (this *LoginController) Get() {
	this.TplName = "Login.html"
	handleNavbar(&this.Controller)
}

func (this *LoginController) Post() {
	this.TplName = "Login.html"
	handleNavbar(&this.Controller)
	if !this.CheckXSRFCookie() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "XSRF 验证失败！"
		return
	}
	DB := database.GetDatabase()
	loginEOU := this.GetString("loginEOU")
	loginPass := this.GetString("loginPass")
	loginRemember, err := this.GetBool("loginRemember", false)
	if err != nil {
		glgf.Error(err)
	}
	var user database.User
	conf := configure.GetConf()
	if !DB.Where("email = ?", loginEOU).Or("name = ?", loginEOU).First(&user).RecordNotFound() {
		b := md5.Sum([]byte(loginPass + conf.String("DatabaseSalt")))
		if hex.EncodeToString(b[:]) == user.Password {
			this.SetSession("LST", session.GeneToken(user.Name, loginRemember))
			this.SetSession("ID", user.ID)
			this.SetSession("UN", user.Name)
			DelayRedirect(DelayInfo{
				URL:    configure.WebHostName,
				Detail: "正在跳转到主页",
				Title:  "您已成功登录！",
			}, &this.Controller)
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = "密码错误！"
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "用户不存在！"
	}
}

func (this *LoginController) CheckXSRFCookie() bool {
	if !this.EnableXSRF {
		return true
	}
	token := this.Ctx.Input.Query("_xsrf")
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Xsrftoken")
	}
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Csrftoken")
	}
	if token == "" {
		return false
	}
	if this.XSRFToken() != token {
		return false
	}
	return true
}
