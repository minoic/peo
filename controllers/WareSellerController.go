package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"strconv"
)

type WareSellerController struct {
	beego.Controller
}

type ware struct {
	WareName          string
	WarePricePerMonth string
	Intros            []intro
	SpecID            uint
}

type intro struct {
	First  string
	Second string
}

func (this *WareSellerController) Get() {
	this.TplName = "WareSeller.html"
	this.Data["wareTitle"] = "Title"
	this.Data["wareDetail"] = "Detail"
	handleNavbar(&this.Controller)
	this.Ctx.ResponseWriter.Flush()
	wareChan := make(chan []ware)
	go func() {
		var wares []ware
		var waresInDB []MinoDatabase.WareSpec
		DB := MinoDatabase.GetDatabase()
		var emailText string
		if MinoConfigure.ConfGetSMTPEnabled() {
			emailText = "邮件提醒！"
		} else {
			emailText = ""
		}
		if !DB.Find(&waresInDB).RecordNotFound() && len(waresInDB) != 0 {
			for i, w := range waresInDB {
				egg := PterodactylAPI.GetEgg(PterodactylAPI.ConfGetParams(), w.Nest, w.Egg)
				wares = append(wares, ware{
					WareName:          w.WareName,
					WarePricePerMonth: strconv.FormatFloat(float64(w.PricePerMonth), 'f', 2, 64),
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
							Second: "虚拟化隔离",
						},
						{
							First:  egg.Description,
							Second: "",
						},
						{
							First:  "到期后帮您保留" + strconv.Itoa(int(w.DeleteDuration.Hours()/24)) + "天",
							Second: emailText,
						},
					},
					SpecID: w.ID,
				})
				if w.WareDescription != "" {
					wares[i].Intros = append(wares[i].Intros, intro{
						First:  w.WareDescription,
						Second: "",
					})
				}
			}
		} else {
			wares = append(wares, ware{
				WareName:          "没有商品",
				WarePricePerMonth: "9999",
				Intros: []intro{{
					First:  "去添加一些商品",
					Second: "这里就会显示",
				},
				},
			})
		}
		wareChan <- wares
	}()
	wares := <-wareChan
	//beego.Debug(wares)
	this.Data["wares"] = wares
	close(wareChan)
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
