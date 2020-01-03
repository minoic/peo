package controllers

import (
	"NTOJ/models"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
)

type LoginController struct {
	beego.Controller
}

func (this *LoginController) Get() {
	this.TplName = "login.html"
}

func (this *LoginController) Post() {
	this.TplName = "login.html"
	DB, er := gorm.Open("sqlite3", "test.db")
	if er != nil {
		panic("Failed to connect database")
	}
	defer DB.Close()
	loginEOU := this.GetString("loginEOU")
	loginPass := this.GetString("loginPass")
	var user models.User
	if !DB.Where("Email = ?", loginEOU).Or("Name = ?", loginEOU).First(&user).RecordNotFound() {
		if loginPass == user.Password {
			this.Data["loginReturnData"] = "logged in!"
		} else {
			this.Data["loginReturnData"] = "login failed!!"
		}
	}
	return
}
