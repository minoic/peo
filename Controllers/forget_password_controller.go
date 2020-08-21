package Controllers

import (
	"crypto/md5"
	"encoding/hex"
	"git.ntmc.tech/root/MinoIC-PE/MinoCache"
	"git.ntmc.tech/root/MinoIC-PE/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/MinoEmail"
	"github.com/astaxie/beego"
	"time"
)

type ForgetPasswordController struct {
	beego.Controller
}

var bm = MinoCache.GetCache()

func (this *ForgetPasswordController) Get() {
	this.TplName = "ForgetPassword.html"
	handleNavbar(&this.Controller)
	if !MinoConfigure.SMTPEnabled {
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
	DB := MinoDatabase.GetDatabase()
	var user MinoDatabase.User
	if !DB.Where("email = ?", userEmail).First(&user).RecordNotFound() {
		if cpt == bm.Get("FORGET"+userEmail) {
			if password == passwordConfirm {
				conf := MinoConfigure.GetConf()
				b := md5.Sum([]byte(password + conf.String("DatabaseSalt")))
				DB.Model(&user).Update("Password", hex.EncodeToString(b[:]))
				DelayRedirect(DelayInfo{
					URL:    MinoConfigure.WebHostName + "/login",
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
	DB := MinoDatabase.GetDatabase()
	if DB.Where("email = ?", userEmail).First(&MinoDatabase.User{}).RecordNotFound() || bm.IsExist("FORGET"+userEmail) {
		return
	}
	key, err := MinoEmail.SendCaptcha(userEmail)
	if err != nil {
		beego.Error(err)
	} else {
		err := bm.Put("FORGET"+userEmail, key, 1*time.Minute)
		if err != nil {
			beego.Error(err)
		}
	}
}

func (this *ForgetPasswordController) CheckXSRFCookie() bool {
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
