package controllers

import (
	"context"
	"crypto/md5"
	"encoding/hex"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"time"
)

type ForgetPasswordController struct {
	web.Controller
	i18n.Locale
}

func (this *ForgetPasswordController) Prepare() {
	this.Data["lang"] = configure.Viper().GetString("Language")
}

func (this *ForgetPasswordController) Get() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
	if !configure.Viper().GetBool("SMTPEnabled") {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.no_smtp")
	}
}

func (this *ForgetPasswordController) Post() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
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
					Detail: tr("auth.jump_to_login"),
					Title:  tr("auth.change_success"),
				}, &this.Controller)
			} else {
				this.Data["hasError"] = true
				this.Data["hasErrorText"] = tr("auth.register_confirm_error")
			}
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = tr("auth.register_captcha_error")
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = tr("auth.verify_email_error")
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
