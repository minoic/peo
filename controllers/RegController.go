package controllers

import (
	"NTOJ/models"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
)

type RegController struct {
	beego.Controller
}

func (this *RegController) Get() {
	this.TplName = "reg.html"
}

func (this *RegController) Post() {
	this.TplName = "reg.html"
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
	newUser := models.User{
		Name:     registerName,
		Email:    registerEmail,
		Password: registerPassword,
	}
	DB, er := gorm.Open("sqlite3", "test.db")
	if er != nil {
		panic("Failed to connect database")
	}
	defer DB.Close()
	DB.Create(&newUser)
	var tmp models.User
	DB.Last(&tmp)
	beego.Info("last user in sql:" + tmp.Name)
}
