package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"html/template"
	"strconv"
	"time"
)

type WareSellerController struct {
	beego.Controller
}

type ware struct {
	WareName          string
	WarePricePerMonth string
	Intros            []intro
	SpecID            uint
	Discount          int
}

type intro struct {
	First  string
	Second string
}

func (this *WareSellerController) Get() {
	this.TplName = "WareSeller.html"
	this.Data["wareTitle"] = template.HTML("MinoIC - Minecraft 面板服")
	this.Data["wareDetail"] = template.HTML(``)
	this.Data["u"] = 1
	handleNavbar(&this.Controller)
	this.Ctx.ResponseWriter.Flush()
	var (
		wares1    []ware
		wares2    []ware
		wares3    []ware
		waresInDB []MinoDatabase.WareSpec
		emailText string
	)
	DB := MinoDatabase.GetDatabase()
	if MinoConfigure.SMTPEnabled {
		emailText = "邮件提醒！"
	}
	if !DB.Find(&waresInDB).RecordNotFound() && len(waresInDB) != 0 {
		for _, w := range waresInDB {
			egg := PterodactylAPI.GetEgg(PterodactylAPI.ConfGetParams(), w.Nest, w.Egg)
			//beego.Debug(w)
			switch w.ValidDuration {
			case 30 * 24 * time.Hour:
				wares1 = append(wares1, ware{
					WareName:          w.WareName,
					WarePricePerMonth: strconv.Itoa(int(w.PricePerMonth)),
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
					SpecID:   w.ID,
					Discount: w.Discount,
				})
				if w.WareDescription != "" {
					wares1[len(wares1)-1].Intros = append(wares1[len(wares1)-1].Intros, intro{
						First:  w.WareDescription,
						Second: "",
					})
				}
			case 90 * 24 * time.Hour:
				wares2 = append(wares2, ware{
					WareName:          w.WareName,
					WarePricePerMonth: strconv.Itoa(int(w.PricePerMonth) * 3),
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
					SpecID:   w.ID,
					Discount: w.Discount,
				})
				if w.WareDescription != "" {
					wares2[len(wares2)-1].Intros = append(wares2[len(wares2)-1].Intros, intro{
						First:  w.WareDescription,
						Second: "",
					})
				}
			case 365 * 24 * time.Hour:
				wares3 = append(wares3, ware{
					WareName:          w.WareName,
					WarePricePerMonth: strconv.Itoa(int(w.PricePerMonth) * 12),
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
					SpecID:   w.ID,
					Discount: w.Discount,
				})
				if w.WareDescription != "" {
					wares3[len(wares3)-1].Intros = append(wares3[len(wares3)-1].Intros, intro{
						First:  w.WareDescription,
						Second: "",
					})
				}

			}
		}
	} else {
		wares1 = append(wares1, ware{
			WareName:          "没有商品",
			WarePricePerMonth: "9999",
			Intros: []intro{{
				First:  "去添加一些商品",
				Second: "这里就会显示",
			},
			},
		})
	}
	//beego.Debug(wares)
	this.Data["wares1"] = wares1
	this.Data["wares2"] = wares2
	this.Data["wares3"] = wares3
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
