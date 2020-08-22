package Controllers

import (
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/MinoIC-PE/MinoSession"
	"github.com/MinoIC/MinoIC-PE/PterodactylAPI"
	"github.com/astaxie/beego"
	"strings"
)

type NewPackController struct {
	beego.Controller
}

var packInfo []InfoDetail

func init() {
	packInfo = []InfoDetail{
		{
			Name:           "pack_name",
			FriendlyName:   "整合包名称",
			Description:    "输入整合包的名称",
			Type:           "text",
			AdditionalTags: "required",
		},
		{
			Name:           "pack_description",
			FriendlyName:   "整合包描述",
			Description:    "输入整合包的详细描述",
			Type:           "text",
			AdditionalTags: "",
		},
		{
			Name:           "nest_id",
			FriendlyName:   "NEST ID",
			Description:    "输入包所在的 NEST 的 ID 在翼龙面板中可以清晰的看到",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "egg_id",
			FriendlyName:   "EGG ID",
			Description:    "输入包所在的 EGG 的 ID 在翼龙面板中可以清晰的看到",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "pack_id",
			FriendlyName:   "PACK ID",
			Description:    "输入包所在的 PACK 的 ID 在翼龙面板中可以清晰的看到",
			Type:           "number",
			AdditionalTags: "required",
		},
	}
	for i, w := range packInfo {
		if strings.Index(w.AdditionalTags, "required") != -1 {
			packInfo[i].Required = true
		} else {
			packInfo[i].Required = false
		}
	}
}

func (this *NewPackController) Prepare() {
	this.TplName = "NewPack.html"
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		this.Abort("401")
	} else if !MinoSession.SessionIsAdmin(sess) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	// beego.Info(wareInfo)
	this.Data["options"] = packInfo
	this.Data["u"] = 0
}

func (this *NewPackController) Get() {}

func (this *NewPackController) Post() {
	if !this.CheckXSRFCookie() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "XSRF 验证失败！"
		return
	}
	var (
		pack         MinoDatabase.Pack
		err          error
		hasError     bool
		hasErrorText string
	)
	pack.PackName = this.GetString("pack_name")
	pack.PackDescription = this.GetString("pack_description")
	pack.NestID, err = this.GetInt("nest_id")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 nest_id " + err.Error()
	}
	pack.EggID, err = this.GetInt("egg_id")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 egg_id " + err.Error()
	}
	if PterodactylAPI.GetEgg(PterodactylAPI.ConfGetParams(), pack.NestID, pack.EggID) == (PterodactylAPI.PterodactylEgg{}) {
		hasError = true
		hasErrorText = "获取 EGG 信息失败！"
	}
	if hasError {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = hasErrorText
	} else {
		DB := MinoDatabase.GetDatabase()
		DB.Create(&pack)
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/new-pack",
			Detail: "正在跳转回添加页面",
			Title:  "添加整合包成功！",
		}, &this.Controller)
	}
}

func (this *NewPackController) CheckXSRFCookie() bool {
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
