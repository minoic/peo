package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
)

type PEAdminSettingsController struct {
	beego.Controller
}

func init() {
	DB := MinoDatabase.GetDatabase()
	var temp MinoDatabase.PEAdminSetting
	if DB.Where("Key = ?", "websiteName").First(&temp).RecordNotFound() {
		DB.Create(&MinoDatabase.PEAdminSetting{
			Model: gorm.Model{},
			Key:   "websiteName",
			Value: "DefaultName",
		})
	}
	temp = MinoDatabase.PEAdminSetting{}
	if DB.Where("Key = ?", "websiteHost").First(&temp).RecordNotFound() {
		DB.Create(&MinoDatabase.PEAdminSetting{
			Model: gorm.Model{},
			Key:   "websiteHost",
			Value: "localhost",
		})
	}
}

func (this *PEAdminSettingsController) Get() {
	this.TplName = "PEAdminSettings.html"
	this.Data["u"] = 4
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转到登录",
			Title:  "您还没有登录",
		}, &this.Controller)
	}
	userName := sess.Get("UN").(string)
	DB := MinoDatabase.GetDatabase()
	var user MinoDatabase.User
	if DB.Where("Name = ?", userName).First(&user).RecordNotFound() {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebApplicationName,
			Detail: "正在跳转到主页",
			Title:  "用户名未找到",
		}, &this.Controller)
	}
	if !user.IsAdmin {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebApplicationName,
			Detail: "正在跳转到主页",
			Title:  "用户没有访问权限",
		}, &this.Controller)
	}
	var s MinoDatabase.PEAdminSetting
	if !DB.Where("Key = ?", "websiteName").First(&s).RecordNotFound() {
		this.Data["websiteNameDef"] = s.Value
		//beego.Info("value:" + s.Value)
	}
	s = MinoDatabase.PEAdminSetting{}
	if !DB.Where("Key = ?", "websiteHost").First(&s).RecordNotFound() {
		this.Data["websiteHostDef"] = s.Value
		//beego.Info("value:" + s.Value)
	}
}

func (this *PEAdminSettingsController) Post() {
	this.TplName = "PEAdminSettings.html"
	handleNavbar(&this.Controller)
	websiteName := this.GetString("websiteName")
	websiteHost := this.GetString("websiteHost")
	beego.Info(websiteHost)
	DB := MinoDatabase.GetDatabase()
	DB.Model(&MinoDatabase.PEAdminSetting{}).Where("Key = ?", "websiteName").Update(&MinoDatabase.PEAdminSetting{
		Model: gorm.Model{},
		Key:   "websiteName",
		Value: websiteName,
	})
	DB.Model(&MinoDatabase.PEAdminSetting{}).Where("Key = ?", "websiteHost").Update(&MinoDatabase.PEAdminSetting{
		Model: gorm.Model{},
		Key:   "websiteHost",
		Value: websiteHost,
	})
	DelayRedirect(DelayInfo{
		URL:    MinoConfigure.WebApplicationName + "/pe-admin-settings",
		Detail: "正在跳转回设置页",
		Title:  "更新设置成功",
	}, &this.Controller)
}

//todo: use settings.conf instead of database
