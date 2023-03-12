package controllers

import (
	"context"
	"crypto/md5"
	"encoding/hex"
	"github.com/beego/beego/v2/server/web"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"time"
)

type ForgetPasswordController struct {
	web.Controller
}

func (this *ForgetPasswordController) Get() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
	if !configure.Viper().GetBool("SMTPEnabled") {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "服务器没有开启SMTP服务，无法使用找回密码功能，请联系网站管理员找回密码！"
	}
}

func (this *ForgetPasswordController) Post() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
	if !this.CheckXSRFCookie() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "XSRF 验证失败！"
		return
	}
	userEmail := this.GetString("email")
	password := this.GetString("password")
	passwordConfirm := this.GetString("passwordConfirm")
	cpt := this.GetString("cpt")
	DB := database.Mysql()
	var user database.User
	if !DB.Where("email = ?", userEmail).First(&user).RecordNotFound() {
		if cpt == database.Redis().Get(context.Background(), "FORGET"+userEmail).String() {
			if password == passwordConfirm {

				b := md5.Sum([]byte(password + configure.Viper().GetString("DatabaseSalt")))
				DB.Model(&user).Update("Password", hex.EncodeToString(b[:]))
				DelayRedirect(DelayInfo{
					URL:    "/login",
					Detail: "正在跳转到登录页面",
					Title:  "修改成功 😀",
				}, &this.Controller)
			} else {
				this.Data["hasError"] = true
				this.Data["hasErrorText"] = "两次输入的密码不一致"
			}
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = "邮件验证码输入错误"
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "该邮箱未被注册，无法找回密码！"
	}
}

func (this *ForgetPasswordController) SendMail() {
	this.TplName = "Loading.html"
	userEmail := this.Ctx.Input.Param(":email")
	DB := database.Mysql()
	if DB.Where("email = ?", userEmail).First(&database.User{}).RecordNotFound() || database.Redis().Get(context.Background(), "FORGET"+userEmail).Err() == nil {
		return
	}
	key, err := email.SendCaptcha(userEmail)
	if err != nil {
		glgf.Error(err)
	} else {
		err := database.Redis().Set(context.Background(), "FORGET"+userEmail, key, 1*time.Minute).Err()
		if err != nil {
			glgf.Error(err)
		}
	}
}

func (this *ForgetPasswordController) CheckXSRFCookie() bool {
	if !this.EnableXSRF {
		return true
	}
	token := this.GetString("_xsrf")
	if token == "" {
		token = this.Ctx.Input.Query("_xsrf")
	}
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
