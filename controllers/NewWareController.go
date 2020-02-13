package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
	"strings"
	"time"
)

var WareInfo []InfoDetail

type NewWareController struct {
	beego.Controller
}

type InfoDetail struct {
	Name           string
	FriendlyName   string
	Description    string
	Type           string
	AdditionalTags string
	Required       bool
}

func init() {
	WareInfo = []InfoDetail{
		{
			Name:           "ware_name",
			FriendlyName:   "商品名称",
			Description:    "显示在商品的标题",
			Type:           "text",
			AdditionalTags: "required",
		},
		{
			Name:         "ware_description",
			FriendlyName: "商品介绍",
			Description:  "显示在商品的介绍",
			Type:         "text",
		},
		{
			Name:           "cpu",
			FriendlyName:   "CPU 限制 (%)",
			Description:    "每100个CPU限制数值表示可以占用一个CPU线程(Thread)",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "disk",
			FriendlyName:   "磁盘限制 (MB)",
			Description:    "服务器的磁盘限制",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "memory",
			FriendlyName:   "内存限制 (MB)",
			Description:    "服务器的内存限制",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "swap",
			FriendlyName:   "SWAP内存限制 (MB)",
			Description:    "SWAP内存，即虚拟内存，映射到磁盘中",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "io",
			FriendlyName:   "Block IO 大小",
			Description:    "Block IO 大小 (10-1000) (默认500)",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "node_id",
			FriendlyName:   "节点ID",
			Description:    "服务器将会在这个节点上创建",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "nest_id",
			FriendlyName:   "Nest ID",
			Description:    "服务器使用的Nest的ID",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "egg_id",
			FriendlyName:   "Egg ID",
			Description:    "服务器使用的Egg的ID",
			Type:           "number",
			AdditionalTags: "required",
		},
		/*{
			Name:         "dedicated_ip",
			FriendlyName: "专用IP",
			Description:  "为服务器设置专用IP (可选)",
			Type:         "checkbox",
		},*/
		{
			Name:         "startup",
			FriendlyName: "启动命令",
			Description:  "定制启动命令以分配给创建的服务器（可选）",
			Type:         "text",
		},
		{
			Name:         "image",
			FriendlyName: "镜像",
			Description:  "自定义Docker映像以分配给创建的服务器（可选）",
			Type:         "text",
		},
		{
			Name:         "database",
			FriendlyName: "数据库数量",
			Description:  "客户端将能够为其服务器创建此数量的数据库（可选）",
			Type:         "int",
		},
		/*		{
					Name:         "start_on_completion",
					FriendlyName: "立即启动",
					Description:  "是否在安装完成后立即启动服务器",
					Type:         "checkbox",
				},
				{
					Name:         "oom_disabled",
					FriendlyName: "开启 OOM Killer",
					Description:  "是否应开启“内存不足杀手”（推荐关闭）",
					Type:         "checkbox",
				},*/
		{
			Name:           "exp",
			FriendlyName:   "有效时间（天）",
			Description:    "商品从订购启动到被暂停的时间（目前仅支持3/30/90即试用/月付/季付）",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "delete_time",
			FriendlyName:   "删除延迟（天）",
			Description:    "商品从失效暂停到被删除的时间",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "price",
			FriendlyName:   "价格（每三十天/人民币）",
			Description:    "打折前的原价（任意正整数）",
			Type:           "number",
			AdditionalTags: "required",
		},
		{
			Name:           "discount",
			FriendlyName:   "折扣",
			Description:    "付款时减去的百分比(0-100的整数)",
			Type:           "number",
			AdditionalTags: "required",
		},
	}
	for i, w := range WareInfo {
		if strings.Index(w.AdditionalTags, "required") != -1 {
			WareInfo[i].Required = true
		} else {
			WareInfo[i].Required = false
		}
	}
}

func (this *NewWareController) Get() {
	this.TplName = "NewWare.html"
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/login",
			Detail: "正在跳转至登录页面",
			Title:  "您还没有登录！",
		}, &this.Controller)
	} else if !MinoSession.SessionIsAdmin(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName(),
			Detail: "正在跳转至主页",
			Title:  "您不是管理员！",
		}, &this.Controller)
	}
	handleNavbar(&this.Controller)
	//beego.Info(WareInfo)
	this.Data["options"] = WareInfo
}

//todo: add nest/egg select instead of input ID
func (this *NewWareController) Post() {
	this.TplName = "NewWare.html"
	this.Data["options"] = WareInfo
	handleNavbar(&this.Controller)
	if !this.CheckXSRFCookie() {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = "XSRF 验证失败！"
		return
	} else if !MinoSession.SessionIsAdmin(this.StartSession()) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName(),
			Detail: "正在跳转至主页",
			Title:  "您不是管理员！",
		}, &this.Controller)
		return
	}
	//formText,_:=template.ParseFiles("tpls/forms/waretext.html")
	ware := MinoDatabase.WareSpec{
		Model:           gorm.Model{},
		WareName:        this.GetString("ware_name"),
		WareDescription: this.GetString("ware_description"),
		DockerImage:     this.GetString("image"),
	}
	//todo: handle errors
	var (
		err          error
		hasError     bool
		hasErrorText string
	)
	ware.Cpu, err = this.GetInt("cpu")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 cpu " + err.Error()
	} else if ware.Cpu < 0 {
		hasError = true
		hasErrorText = "CPU 输入值不合法"
	}
	ware.Disk, err = this.GetInt("disk")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 disk " + err.Error()
	} else if ware.Disk <= 0 {
		hasError = true
		hasErrorText = "DISK 输入值不合法"
	}
	ware.Memory, err = this.GetInt("memory")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 memory " + err.Error()
	} else if ware.Memory <= 0 {
		hasError = true
		hasErrorText = "Memory 输入值不合法"
	}
	ware.Io, err = this.GetInt("io")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 io " + err.Error()
	} else if ware.Io < 100 || ware.Io > 1000 {
		hasError = true
		hasErrorText = "Block IO Weight 输入了不建议的值"
	}
	ware.Swap, err = this.GetInt("swap")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 swap " + err.Error()
	} else if ware.Swap < (-1) {
		hasError = true
		hasErrorText = "Swap 输入值不合法"
	}
	ware.Discount, err = this.GetInt("discount")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 discount " + err.Error()
	} else if ware.Discount > 100 || ware.Discount < 0 {
		hasError = true
		hasErrorText = "Discount 输入值不合法"
	}
	ware.Node, err = this.GetInt("node_id")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 discount " + err.Error()
	} else if ware.Node < 0 || PterodactylAPI.GetNode(PterodactylAPI.ConfGetParams(), ware.Node) == (PterodactylAPI.PterodactylNode{}) {
		hasError = true
		hasErrorText = "Node ID 输入值小于 0 或找不到该节点"
	}
	ware.Nest, err = this.GetInt("nest_id")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 nest_id " + err.Error()
	}
	ware.Egg, err = this.GetInt("egg_id")
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 egg_id " + err.Error()
	} else if PterodactylAPI.GetEgg(PterodactylAPI.ConfGetParams(), ware.Nest, ware.Egg) == (PterodactylAPI.PterodactylEgg{}) {
		hasError = true
		hasErrorText = "在翼龙面板中找不到对应的 EGG"
	}
	price, err := this.GetFloat("price", 999)
	if err != nil {
		beego.Error(err)
		hasError = true
		hasErrorText = "POST 表单获取错误 price " + err.Error()
	} else if price < 0 {
		hasError = true
		hasErrorText = "价格不能设置为负"
	}
	if hasError {
		this.Data["hasError"] = true
		this.Data["hasErrorText"] = hasErrorText
	} else {
		ware.PricePerMonth = float32(price)
		ware.OomDisabled = true
		ware.StartOnCompletion = true
		//todo: handle database number
		//todo: check if post data is valid
		e, _ := this.GetInt("exp")
		ware.ValidDuration = time.Duration(e*24) * time.Hour
		e, _ = this.GetInt("delete_time")
		ware.DeleteDuration = time.Duration(e*24) * time.Hour
		DB := MinoDatabase.GetDatabase()
		DB.Create(&ware)
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.ConfGetHostName() + "/new-ware",
			Detail: "正在跳转回添加页面",
			Title:  "添加商品成功！",
		}, &this.Controller)
	}
}

func (this *NewWareController) CheckXSRFCookie() bool {
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
