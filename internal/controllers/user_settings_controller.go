package controllers

import (
	"crypto/md5"
	"encoding/hex"
	"github.com/astaxie/beego"
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
	beego.Controller
}

func (this *UserSettingsController) Prepare() {
	if !session.SessionIslogged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.TplName = "UserSettings.html"
	this.Data["i"] = 2
	this.Data["u"] = 3
	user, _ := session.SessionGetUser(this.StartSession())
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
		this.Data["pteUserCreateURL"] = configure.WebHostName + "/user-settings/create-pterodactyl-user"
	}
	this.Data["pteUserPassword"] = "默认密码为注册时输入的用户名"
}

func (this *UserSettingsController) Get() {}

func (this *UserSettingsController) UpdateUserPassword() {
	if !this.CheckXSRFCookie() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "XSRF 验证失败！"
		return
	}
	oldPassword := this.GetString("oldPassword")
	newPassword := this.GetString("newPassword")
	confirmPassword := this.GetString("confirmPassword")
	DB := database.GetDatabase()
	conf := configure.GetConf()
	user, err := session.SessionGetUser(this.StartSession())
	if err != nil {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = err.Error() + " 获取用户信息失败，请重新登录！"
		return
	}
	b := md5.Sum([]byte(oldPassword + conf.String("DatabaseSalt")))
	if hex.EncodeToString(b[:]) == user.Password {
		if newPassword == confirmPassword {
			b2 := md5.Sum([]byte(newPassword + conf.String("DatabaseSalt")))
			DB.Model(&user).Update("password", hex.EncodeToString(b2[:]))
			message.Send("ADMIN", user.ID, "您刚刚成功修改了密码！")
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
	if !this.CheckXSRFCookie() {
		this.Data["hasError2"] = true
		this.Data["hasErrorText2"] = "XSRF 验证失败！"
		return
	}
	newEmail := this.GetString("email")
	cpt := bm.Get("CHANGE_EMAIL" + newEmail)
	cptInput := this.GetString("captcha")
	DB := database.GetDatabase()
	user, err := session.SessionGetUser(this.StartSession())
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
	DB := database.GetDatabase()
	if DB.Where("email = ?", userEmail).First(&database.User{}).RecordNotFound() || bm.IsExist("CHANGE_EMAIL"+userEmail) {
		return
	}
	key, err := email.SendCaptcha(userEmail)
	if err != nil {
		glgf.Error(err)
	} else {
		err := bm.Put("CHANGE_EMAIL"+userEmail, key, 1*time.Minute)
		if err != nil {
			glgf.Error(err)
		}
	}
}

func (this *UserSettingsController) CreatePterodactylUser() {
	sess := this.StartSession()
	user, err := session.SessionGetUser(sess)
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
	DB := database.GetDatabase()
	DB.Model(&user).Update("pte_user_created", true)
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserSettingsController) GalleryPost() {
	itemName := this.GetString("itemName")
	itemDescription := this.GetString("itemDescription")
	imgSource := this.GetString("imgSource")
	user, err := session.SessionGetUser(this.StartSession())
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	if itemName == "" || imgSource == "" {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("图片名称或地址不能为空"))
		return
	}
	DB := database.GetDatabase()
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
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库错误"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserSettingsController) CheckXSRFCookie() bool {
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
