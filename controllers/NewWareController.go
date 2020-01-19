package controllers

import (
	"NTPE/models"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
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
		{
			Name:         "dedicated_ip",
			FriendlyName: "专用IP",
			Description:  "为服务器设置专用IP (可选)",
			Type:         "checkbox",
		},
		{
			Name:         "port_range",
			FriendlyName: "配备给服务器的端口范围",
			Description:  "端口范围，以逗号分隔以分配给服务器（例如：25565-25570、25580-25590）（可选）",
			Type:         "text",
		},
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
		{
			Name:         "oom_disabled",
			FriendlyName: "开启 OOM Killer",
			Description:  "是否应开启“内存不足杀手”（推荐关闭）",
			Type:         "checkbox",
		},
		{
			Name:         "start_on_completion",
			FriendlyName: "立即启动",
			Description: "是否在安装完成后立即启动服务器	",
			Type: "checkbox",
		},
		{
			Name:           "exp",
			FriendlyName:   "有效时间（天）",
			Description:    "商品从订购启动到被暂停的时间",
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
	}
}
func (this *NewWareController) Get() {
	this.TplName = "NewWare.html"
	this.Data["options"] = WareInfo
}

func (this *NewWareController) Post() {
	this.TplName = "NewWare.html"
	//formText,_:=template.ParseFiles("tpls/forms/text.html")
	ware := models.WareSpec{
		Model:           gorm.Model{},
		WareName:        this.GetString("ware_name"),
		WareDescription: this.GetString("ware_description"),
		DockerImage:     this.GetString("image"),
	}
	ware.Cpu, _ = this.GetInt("cpu")
	ware.Disk, _ = this.GetInt("disk")
	ware.Memory, _ = this.GetInt("memory")
	ware.Io, _ = this.GetInt("io")
	ware.Swap, _ = this.GetInt("swap")
	ware.Nest, _ = this.GetInt("nest_id")
	ware.Egg, _ = this.GetInt("egg_id")
	ware.OomDisabled, _ = this.GetBool("oom_disabled")
	ware.StartOnCompletion, _ = this.GetBool("start_on_completion")
	e, _ := this.GetInt("exp")
	ware.ValidDuration = time.Duration(e*24) * time.Hour
	e, _ = this.GetInt("delete_time")
	ware.DeleteDuration = time.Duration(e*24) * time.Hour
	DB := models.GetDatabase()
	DB.Create(&ware)
}
