package controllers

import (
	"context"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/session"
	"github.com/spf13/cast"
	"strings"
)

type AdminSettingsController struct {
	web.Controller
	i18n.Locale
}

var (
	BuildTime string
	GoVersion string
)

func (this *AdminSettingsController) Prepare() {
	this.TplName = "AdminSettings.html"
	this.Data["u"] = 4
	handleNavbar(&this.Controller)

	sess := this.StartSession()
	if !session.Logged(sess) {
		this.Abort("401")
	} else if !session.IsAdmin(sess) {
		this.Abort("401")
	}
	this.Data["BuildTime"] = BuildTime
	this.Data["GoVersion"] = GoVersion
	if err := database.Mysql().DB().Ping(); err == nil {
		this.Data["MysqlStats"] = "success"
	} else {
		this.Data["MysqlStats"] = "failed：" + err.Error()
	}
	if err := database.Redis().Ping(context.Background()).Err(); err == nil {
		this.Data["RedisStats"] = "success"
	} else {
		this.Data["RedisStats"] = "failed：" + err.Error()
	}
	if err := pterodactyl.ClientFromConf().TestConnection(); err == nil {
		this.Data["PterodactylStats"] = "success"
	} else {
		this.Data["PterodactylStats"] = "failed：" + err.Error()
	}
	this.Data["options"] = this.getSettings()

}

func (this *AdminSettingsController) Get() {}

func (this *AdminSettingsController) Post() {
	configure.Viper().Set("WebHostName", strings.TrimRight(this.GetString("WebHostName"), "/"))
	configure.Viper().Set("WebApplicationName", this.GetString("WebApplicationName"))
	configure.Viper().Set("WebDescription", this.GetString("WebDescription"))
	configure.Viper().Set("WebAdminAddress", this.GetString("WebAdminAddress"))
	configure.Viper().Set("PterodactylHostname", strings.TrimRight(this.GetString("PterodactylHostname"), "/"))
	configure.Viper().Set("PterodactylToken", this.GetString("PterodactylToken"))
	configure.Viper().Set("DatabaseSalt", this.GetString("DatabaseSalt"))
	configure.Viper().Set("MYSQLHost", this.GetString("MYSQLHost"))
	configure.Viper().Set("MYSQLUsername", this.GetString("MYSQLUsername"))
	configure.Viper().Set("MYSQLUserPassword", this.GetString("MYSQLUserPassword"))
	configure.Viper().Set("MYSQLDatabaseName", this.GetString("MYSQLDatabaseName"))
	configure.Viper().Set("RedisHost", this.GetString("RedisHost"))
	configure.Viper().Set("RedisPassword", this.GetString("RedisPassword"))
	configure.Viper().Set("RedisDB", this.GetString("RedisDB"))
	configure.Viper().Set("SMTPEnabled", cast.ToBool(this.GetString("SMTPEnabled")))
	configure.Viper().Set("SMTPHost", this.GetString("SMTPHost"))
	configure.Viper().Set("SMTPPort", cast.ToInt(this.GetString("SMTPPort")))
	configure.Viper().Set("SMTPSendFrom", this.GetString("SMTPSendFrom"))
	configure.Viper().Set("SMTPUsername", this.GetString("SMTPUsername"))
	configure.Viper().Set("SMTPUserPassword", this.GetString("SMTPUserPassword"))
	configure.Viper().Set("SMTPEncryption", this.GetString("SMTPEncryption"))
	configure.Viper().Set("DeleteEmailConfirm", cast.ToBool(this.GetString("DeleteEmailConfirm")))
	configure.Viper().Set("RechargeMode", cast.ToBool(this.GetString("RechargeMode")))
	configure.Viper().Set("TotalDiscount", cast.ToBool(this.GetString("TotalDiscount")))
	configure.Viper().Set("AliPayPublicKey", this.GetString("AliPayPublicKey"))
	configure.Viper().Set("AliPayPrivateKey", this.GetString("AliPayPrivateKey"))
	configure.Viper().Set("AliPayAppID", this.GetString("AliPayAppID"))
	configure.Viper().Set("AliPayEnabled", this.GetString("AliPayEnabled"))
	configure.Viper().Set("AlbumEnabled", cast.ToBool(this.GetString("AlbumEnabled")))
	configure.Viper().Set("SocialLink", this.GetString("SocialLink"))
	configure.Viper().Set("SocialLinkTitle", this.GetString("SocialLinkTitle"))
	configure.Viper().Set("Language", this.GetString("Language"))
	err := configure.Viper().WriteConfig()
	if err != nil {
		glgf.Error(err)
	}
	configure.ReloadConfig()
	database.Reset()
	this.Prepare()
}

func (this *AdminSettingsController) getSettings() []InputField {
	return []InputField{
		{
			Name:           "WebHostName",
			FriendlyName:   "网站地址",
			Description:    "用户访问本网站的网址，例如 https://www.baidu.com",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("WebHostName"),
		},
		{
			Name:           "WebApplicationName",
			FriendlyName:   "网站名称",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("WebApplicationName"),
		},
		{
			Name:           "WebDescription",
			FriendlyName:   "网站描述",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("WebDescription"),
		},
		{
			Name:           "WebAdminAddress",
			FriendlyName:   "网站管理员地址",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("WebAdminAddress"),
		},
		{
			Name:           "PterodactylHostname",
			FriendlyName:   "翼龙面板地址",
			Description:    "用于连接受控的翼龙面板，注：若要用户跳转时自动登录到翼龙面板，需要开启SSL（HTTPS），且两个网站为同一个域名的子域名（peo.A.com、pte.A.com）。",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("PterodactylHostname"),
		},
		{
			Name:           "PterodactylToken",
			FriendlyName:   "翼龙面板Token",
			Description:    "需要在翼龙面板的 Admin - Application API 中创建一个带有所有读写权限的Token",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("PterodactylToken"),
		},
		{
			Name:           "DatabaseSalt",
			FriendlyName:   "数据库SALT",
			Description:    "随机字符串即可，无特殊情况切勿改动",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("DatabaseSalt"),
		},
		{
			Name:           "MYSQLHost",
			FriendlyName:   "MYSQL地址",
			Description:    "数据库地址，IP:端口",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("MYSQLHost"),
		},
		{
			Name:           "MYSQLUsername",
			FriendlyName:   "MYSQL用户名",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("MYSQLUsername"),
		},
		{
			Name:           "MYSQLUserPassword",
			FriendlyName:   "MYSQL密码",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("MYSQLUserPassword"),
		},
		{
			Name:           "MYSQLDatabaseName",
			FriendlyName:   "MYSQL数据库名称",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("MYSQLDatabaseName"),
		},
		{
			Name:           "RedisHost",
			FriendlyName:   "Redis地址",
			Description:    "用于连接Redis，IP:端口",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("RedisHost"),
		},
		{
			Name:           "RedisPassword",
			FriendlyName:   "Redis Password, 若无密码可留空",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("RedisPassword"),
		},
		{
			Name:           "RedisDB",
			FriendlyName:   "Redis DB",
			Description:    "Redis DB number, 默认设置为 0 即可",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("RedisDB"),
		},
		{
			Name:           "SMTPEnabled",
			FriendlyName:   "开启邮件",
			Description:    "true/false",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SMTPEnabled"),
		},
		{
			Name:           "SMTPHost",
			FriendlyName:   "SMTPHost",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SMTPHost"),
		},
		{
			Name:           "SMTPPort",
			FriendlyName:   "SMTPPort",
			Description:    "",
			Type:           "number",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetInt("SMTPPort"),
		},
		{
			Name:           "SMTPSendFrom",
			FriendlyName:   "SMTPSendFrom",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SMTPSendFrom"),
		},
		{
			Name:           "SMTPUsername",
			FriendlyName:   "SMTPUsername",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SMTPUsername"),
		},
		{
			Name:           "SMTPUserPassword",
			FriendlyName:   "SMTPUserPassword",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SMTPUserPassword"),
		},
		{
			Name:           "SMTPEncryption",
			FriendlyName:   "SMTPEncryption",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SMTPEncryption"),
		},
		{
			Name:           "DeleteEmailConfirm",
			FriendlyName:   "删除提醒",
			Description:    "是否向用户发送删除提醒邮件，true/false",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("DeleteEmailConfirm"),
		},
		{
			Name:           "RechargeMode",
			FriendlyName:   "充值开关",
			Description:    "是否允许用户用支付宝等方式充值余额，true/false",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("RechargeMode"),
		},
		{
			Name:           "TotalDiscount",
			FriendlyName:   "全局打折开关",
			Description:    "是否允许用户以优惠价购买，true/false",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("TotalDiscount"),
		},
		{
			Name:           "AliPayEnabled",
			FriendlyName:   "支付宝开关",
			Description:    "是否开启支付宝支付（基于支付宝当面付 API），WebHostName 填写正确切公网可访问，公开使用前请测试，true/false",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("AliPayEnabled"),
		},
		{
			Name:           "AliPayPublicKey",
			FriendlyName:   "AliPayPublicKey",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("AliPayPublicKey"),
		},
		{
			Name:           "AliPayPrivateKey",
			FriendlyName:   "AliPayPrivateKey",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("AliPayPrivateKey"),
		},
		{
			Name:           "AliPayAppID",
			FriendlyName:   "AliPayAppID",
			Description:    "",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("AliPayAppID"),
		},
		{
			Name:           "AlbumEnabled",
			FriendlyName:   "相册开关",
			Description:    "是否开启相册功能，true/false",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("AlbumEnabled"),
		},
		{
			Name:           "SocialLink",
			FriendlyName:   "社区链接",
			Description:    "若为空则关闭顶栏社区按钮",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SocialLink"),
		},
		{
			Name:           "SocialLinkTitle",
			FriendlyName:   "社区链接标题",
			Description:    "可更改按钮标题",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("SocialLinkTitle"),
		},
		{
			Name:           "Language",
			FriendlyName:   "语言",
			Description:    "目前支持：zh-CN, en-US, de-DE, 也可以自行更改或添加，文件夹位于 conf/locale",
			Type:           "text",
			AdditionalTags: "",
			Required:       false,
			Default:        configure.Viper().GetString("Language"),
		},
	}
}
