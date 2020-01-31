package controllers

import (
	"NTPE/models"
	"github.com/astaxie/beego"
	"strconv"
)

type WareSellerController struct {
	beego.Controller
}

type ware struct {
	WareName          string
	WarePricePerMonth string
	WarePricePerHour  string
	Intros            []intro
}

type intro struct {
	First  string
	Second string
}

var wares []ware

func (this *WareSellerController) Get() {
	this.TplName = "WareSeller.html"
	this.Data["wareTitle"] = "Title"
	this.Data["wareDetail"] = "Detail"
	this.Data["webApplicationName"] = models.ConfGetWebName()
	sess := this.StartSession()
	if !models.SessionIslogged(sess) {
		this.Data["bottomLink"] = "/reg"
		this.Data["bottomText"] = "注册账号"
	} else {
		this.Data["bottomLink"] = "/user-settings"
		this.Data["bottomText"] = "控制台"
	}
	var waresInDB []models.WareSpec
	DB := models.GetDatabase()
	if !DB.Find(&waresInDB).RecordNotFound() && len(waresInDB) != 0 {
		for _, w := range waresInDB {
			egg := models.PterodactylGetEgg(models.ConfGetParams(), w.Nest, w.Egg)
			wares = append(wares, ware{
				WareName:          w.WareName,
				WarePricePerMonth: strconv.FormatFloat(float64(w.PricePerMonth), 'f', 6, 64),
				WarePricePerHour:  strconv.FormatFloat(float64(w.PricePerMonth)/30/24, 'f', 6, 64),
				Intros: []intro{
					{
						First:  strconv.Itoa(w.Cpu / 100),
						Second: "个CPU核心",
					},
					{
						First:  strconv.Itoa(w.Memory),
						Second: "MB物理内存",
					},
					{
						First:  strconv.Itoa(w.Disk),
						Second: "MB存储空间",
					},
					{
						First:  egg.DockerImage,
						Second: "<br>Docker虚拟化隔离",
					},
					{
						First:  egg.Description,
						Second: "",
					},
				},
			})
		}
	} else {
		wares = append(wares, ware{
			WareName:          "没有商品",
			WarePricePerMonth: "0",
			WarePricePerHour:  "0",
			Intros: []intro{{
				First:  "去添加一些商品",
				Second: "这里就会显示",
			},
			},
		})
	}
	//beego.Info(wares)
	this.Data["wares"] = wares
}

/*
wareTitle/wareDetail/webApplicationName string
bottomLink/bottomText string
wares []ware
ware struct{
	wareName string
	warePricePerMonth float
	warePricePerHour float
	intros []item
}

*/
