package controllers

import (
	"NTPE/models"
	"github.com/astaxie/beego"
	"github.com/satori/go.uuid"
)

type RegController struct {
	beego.Controller
}

func (this *RegController) Get() {
	this.TplName = "Register.html"
}

func (this *RegController) Post() {
	this.TplName = "Register.html"
	//beego.Info("user posted!")
	registerEmail := this.GetString("registerEmail")
	registerPassword := this.GetString("registerPassword")
	registerPasswordConfirm := this.GetString("registerPasswordConfirm")
	registerName := this.GetString("registerName")
	if registerPassword != registerPasswordConfirm {
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
		Name:     registerName,
		Email:    registerEmail,
		Password: registerPassword,
		UUID:     newUuid,
	}
	DB := models.GetDatabase()
	defer DB.Close()
	DB.Create(&newUser)
	var tmp models.User
	DB.Last(&tmp)
	beego.Info("last user in sql:", tmp)
	//todo: add Verification Code
	//todo: create Pterodactyl user at the same time
}
