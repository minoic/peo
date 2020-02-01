package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoEmail"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/cache"
	"github.com/astaxie/beego/utils/captcha"
	"github.com/satori/go.uuid"
)

var cpt *captcha.Captcha

func init() {
	// use beego cache system store the captcha data
	store := cache.NewMemoryCache()
	cpt = captcha.NewWithFilter("/captcha/", store)
	cpt.StdHeight = 48
	cpt.StdWidth = 100
	cpt.ChallengeNums = 5
}

type RegController struct {
	beego.Controller
}

func (this *RegController) Get() {
	this.TplName = "Register.html"
	this.Data["webHostName"] = models.ConfGetHostName()
	this.Data["webApplicationName"] = models.ConfGetWebName()
}

func (this *RegController) Post() {
	this.TplName = "Register.html"
	//beego.Info("user posted!")
	registerEmail := this.GetString("registerEmail")
	registerPassword := this.GetString("registerPassword")
	registerPasswordConfirm := this.GetString("registerPasswordConfirm")
	registerName := this.GetString("registerName")
	cptSuccess := cpt.VerifyReq(this.Ctx.Request)
	if registerPassword != registerPasswordConfirm && cptSuccess {
		beego.Info("user invalid post!")
		this.Data["textType"] = "warning"
		this.Data["textData"] = "Register Failed:Password invalid!"
		return
	}
	beego.Info(registerName + " " + registerEmail + " " + registerPassword + " " + registerPasswordConfirm)
	this.Data["textType"] = "success"
	this.Data["textData"] = "Register Success!"
	newUuid := uuid.NewV4()
	newUser := models.User{
		Name:           registerName,
		Email:          registerEmail,
		Password:       registerPassword,
		UUID:           newUuid,
		IsAdmin:        false,
		EmailConfirmed: false,
	}
	DB := models.GetDatabase()
	defer DB.Close()
	DB.Create(&newUser)
	var tmp models.User
	DB.Last(&tmp)
	beego.Info("last user in sql:", tmp)
	if models.ConfGetSMTPEnabled() {
		if err := MinoEmail.ConfirmRegister(newUser); err != nil {
			beego.Error(err)
			DelayRedirect(DelayInfo{
				URL:    models.ConfGetHostName() + "/reg",
				Detail: "即将跳转到注册页面",
				Title:  "邮件发送失败，请联系网站管理员！",
			}, &this.Controller)
		} else {
			DelayRedirect(DelayInfo{
				URL:    models.ConfGetHostName() + "/login",
				Detail: "即将跳转到登陆页面",
				Title:  "请前往您的邮箱进行验证！",
			}, &this.Controller)
		}
	} else {
		DelayRedirect(DelayInfo{
			URL:    models.ConfGetHostName() + "/login",
			Detail: "即将跳转到登陆页面",
			Title:  "注册成功！",
		}, &this.Controller)
	}
	//todo: create Pterodactyl user at the same time
}
