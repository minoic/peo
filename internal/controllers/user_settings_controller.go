package controllers

import (
	"context"
	"crypto/md5"
	"encoding/hex"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/jinzhu/gorm"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/session"
	"html/template"
	"time"
)

type UserSettingsController struct {
	web.Controller
	i18n.Locale
}

func (this *UserSettingsController) Prepare() {
	if !session.Logged(this.StartSession()) {
		this.Abort("401")
	}
	this.Data["lang"] = configure.Viper().GetString("Language")
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.TplName = "UserSettings.html"
	this.Data["i"] = 2
	this.Data["u"] = 3
	user, _ := session.GetUser(this.StartSession())
	this.Data["userCreated"] = user.PteUserCreated
	if user.PteUserCreated {
		pteUser, err := pterodactyl.ClientFromConf().GetUser(user.Name, true)
		if err != nil {
			this.Data["pteUserUUID"] = "获取用户信息失败"
			this.Data["pteUserName"] = "获取用户信息失败"
			this.Data["pteUserEmail"] = "获取用户信息失败"
			this.Data["pteUser2FA"] = false
			this.Data["pteUserCreatedAt"] = "获取用户信息失败"
		} else {
			this.Data["pteUserUUID"] = pteUser.Uuid
			this.Data["pteUserName"] = pteUser.ExternalId
			this.Data["pteUserEmail"] = pteUser.Email
			this.Data["pteUser2FA"] = pteUser.TwoFA
			this.Data["pteUserCreatedAt"] = pteUser.CreatedAt
		}
	} else {
		this.Data["pteUserUUID"] = "请先创建用户"
		this.Data["pteUserName"] = "请先创建用户"
		this.Data["pteUserEmail"] = "请先创建用户"
		this.Data["pteUser2FA"] = false
		this.Data["pteUserCreatedAt"] = "请先创建用户"
		this.Data["pteUserCreateURL"] = "/user-settings/create-pterodactyl-user"
	}
	this.Data["pteUserPassword"] = "默认密码为注册时输入的用户名"
}

func (this *UserSettingsController) Get() {}

func (this *UserSettingsController) UpdateUserPassword() {
	oldPassword := this.GetString("oldPassword")
	newPassword := this.GetString("newPassword")
	confirmPassword := this.GetString("confirmPassword")
	DB := database.Mysql()
	user, err := session.GetUser(this.StartSession())
	if err != nil {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = err.Error() + " 获取用户信息失败，请重新登录！"
		return
	}
	b := md5.Sum([]byte(oldPassword + configure.Viper().GetString("DatabaseSalt")))
	if hex.EncodeToString(b[:]) == user.Password {
		if newPassword == confirmPassword {
			b2 := md5.Sum([]byte(newPassword + configure.Viper().GetString("DatabaseSalt")))
			err := DB.Model(&user).Update("password", hex.EncodeToString(b2[:])).Error
			if err != nil {
				glgf.Error(err)
				this.Data["hasError"] = true
				this.Data["hasErrorText"] = "数据库错误"
				return
			}
			message.Send("ADMIN", user.ID, "您刚刚成功修改了密码！")
			err = pterodactyl.ClientFromConf().ChangePassword(user.Name, newPassword)
			if err != nil {
				glgf.Error(err)
				this.Data["hasError"] = true
				this.Data["hasErrorText"] = "未能成功更改翼龙面板密码"
				return
			}
			message.Send("ADMIN", user.ID, "您刚刚成功修改了翼龙面板密码！")
			this.Redirect("/user-settings", 302)
		} else {
			this.Data["hasError"] = true
			this.Data["hasErrorText"] = "两次输入的新密码不一致"
			// this.Redirect("/user-settings",302)
		}
	} else {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "旧密码输入错误"
		// this.Redirect("/user-settings",302)
	}

}

func (this *UserSettingsController) UpdateUserEmail() {
	newEmail := this.GetString("email")
	cpt := database.Redis().Get(context.Background(), "CHANGE_EMAIL"+newEmail).String()
	cptInput := this.GetString("captcha")
	DB := database.Mysql()
	user, err := session.GetUser(this.StartSession())
	if err != nil {
		this.Data["hasError2"] = true
		this.Data["hasErrorText2"] = err.Error() + " 获取用户信息失败，请重新登录！"
		return
	}
	// glgf.Info(newEmail,cpt,cptInput)
	if cpt == cptInput {
		DB.Model(&user).Update("email", newEmail)
		message.Send("ADMIN", user.ID, "您刚刚将绑定的邮箱修改到了 "+newEmail)
		this.Redirect("/user-settings", 302)
	} else {
		this.Data["hasError2"] = true
		this.Data["hasErrorText2"] = "验证码输入错误"
	}
}

func (this *UserSettingsController) SendCaptcha() {
	this.TplName = "Loading.html"
	userEmail := this.Ctx.Input.Param(":email")
	DB := database.Mysql()
	if DB.Where("email = ?", userEmail).First(&database.User{}).RecordNotFound() || database.Redis().Get(context.Background(), "CHANGE_EMAIL"+userEmail).Err() == nil {
		return
	}
	key, err := email.SendCaptcha(userEmail)
	if err != nil {
		glgf.Error(err)
	} else {
		err := database.Redis().Set(context.Background(), "CHANGE_EMAIL"+userEmail, key, 1*time.Minute)
		if err != nil {
			glgf.Error(err)
		}
	}
}

func (this *UserSettingsController) CreatePterodactylUser() {
	sess := this.StartSession()
	user, err := session.GetUser(sess)
	if err != nil || user == (database.User{}) {
		glgf.Debug("cant get user")
		_, _ = this.Ctx.ResponseWriter.Write([]byte("FAILED"))
		return
	}
	if err = pterodactyl.ClientFromConf().CreateUser(pterodactyl.PostPteUser{
		ExternalId: user.Name,
		Username:   user.Name,
		Email:      user.Email,
		Language:   "en",
		RootAdmin:  user.IsAdmin,
		Password:   user.Name,
		FirstName:  user.Name,
		LastName:   "_",
	}); err != nil {
		glgf.Debug(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("FAILED"))
		return
	}
	DB := database.Mysql()
	DB.Model(&user).Update("pte_user_created", true)
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserSettingsController) GalleryPost() {
	itemName := this.GetString("itemName")
	itemDescription := this.GetString("itemDescription")
	imgSource := this.GetString("imgSource")
	user, err := session.GetUser(this.StartSession())
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("please login"))
		return
	}
	if itemName == "" || imgSource == "" {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("picture name or url cant be empty"))
		return
	}
	DB := database.Mysql()
	if err := DB.Create(&database.GalleryItem{
		Model:           gorm.Model{},
		UserID:          user.ID,
		ItemName:        itemName,
		ItemDescription: itemDescription,
		Likes:           0,
		ReviewPassed:    user.IsAdmin,
		ImgSource:       template.URL(imgSource),
	}).Error; err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("database error"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}
