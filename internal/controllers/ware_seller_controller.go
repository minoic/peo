package controllers

import (
	"github.com/astaxie/beego"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/pterodactyl"
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

var (
	wares1 []ware
	wares2 []ware
	wares3 []ware
)

func RefreshWareInfo() {
	st := time.Now()
	wares1 = []ware{}
	wares2 = []ware{}
	wares3 = []ware{}
	var (
		waresInDB []database.WareSpec
		emailText string
	)

	DB := database.GetDatabase()
	if configure.SMTPEnabled {
		emailText = "邮件提醒！"
	}
	if DB.Find(&waresInDB).Error == nil {
		for _, w := range waresInDB {
			nest, err := pterodactyl.ClientFromConf().GetNest(w.Nest)
			if err != nil {
				glgf.Error(err)
				nest = &pterodactyl.Nest{}
			}
			// glgf.Debug(w)
			nw := ware{
				WareName: w.WareName,
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
						First:  "Docker",
						Second: "虚拟化隔离",
					},
					{
						First:  nest.Description,
						Second: "",
					},
					{
						First:  "到期后帮您保留" + strconv.Itoa(int(w.DeleteDuration.Hours()/24)) + "天",
						Second: emailText,
					},
				},
				SpecID:   w.ID,
				Discount: w.Discount,
			}
			if !configure.TotalDiscount {
				nw.Discount = 0
			}
			if w.WareDescription != "" {
				nw.Intros = append(nw.Intros, intro{
					First:  w.WareDescription,
					Second: "",
				})
			}
			switch w.ValidDuration {
			case 30 * 24 * time.Hour:
				nw.WarePricePerMonth = strconv.Itoa(int(w.PricePerMonth))
				wares1 = append(wares1, nw)
			case 90 * 24 * time.Hour:
				nw.WarePricePerMonth = strconv.Itoa(int(w.PricePerMonth) * 3)
				wares2 = append(wares2, nw)
			case 365 * 24 * time.Hour:
				nw.WarePricePerMonth = strconv.Itoa(int(w.PricePerMonth) * 12)
				wares3 = append(wares3, nw)
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
	glgf.Info("Refreshed Ware Info - ", time.Now().Sub(st).String())
}

func (this *WareSellerController) Get() {
	this.TplName = "WareSeller.html"
	this.Data["wareTitle"] = template.HTML("MinoIC - Minecraft 面板服")
	this.Data["wareDetail"] = template.HTML(``)
	this.Data["u"] = 1
	handleNavbar(&this.Controller)
	this.Ctx.ResponseWriter.Flush()
	// glgf.Debug(wares)
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
