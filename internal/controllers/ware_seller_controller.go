package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/jinzhu/gorm"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/spf13/cast"
	"strconv"
	"time"
)

type WareSellerController struct {
	web.Controller
	i18n.Locale
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
	var wares1n []ware
	var wares2n []ware
	var wares3n []ware
	var (
		waresInDB []database.WareSpec
		emailText string
	)
	DB := database.Mysql()
	if configure.Viper().GetBool("SMTPEnabled") {
		emailText = tr("intro.email_text")
	}
	if err := DB.Find(&waresInDB).Error; err == nil {
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
						Second: tr("intro.cpu"),
					},
					{
						First:  strconv.Itoa(w.Memory),
						Second: tr("intro.memory"),
					},
					{
						First:  strconv.Itoa(w.Disk),
						Second: tr("intro.disk"),
					},
					{
						First:  cast.ToString(w.Backups),
						Second: tr("intro.backups"),
					},
					{
						First:  "Docker",
						Second: tr("intro.virtual_env"),
					},
					{
						First:  nest.Description,
						Second: "",
					},
					{
						First:  tr("intro.save") + strconv.Itoa(int(w.DeleteDuration.Hours()/24)) + tr("days"),
						Second: emailText,
					},
				},
				SpecID:   w.ID,
				Discount: w.Discount,
			}
			if !configure.Viper().GetBool("TotalDiscount") {
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
				wares1n = append(wares1n, nw)
			case 90 * 24 * time.Hour:
				nw.WarePricePerMonth = strconv.Itoa(int(w.PricePerMonth) * 3)
				wares2n = append(wares2n, nw)
			case 365 * 24 * time.Hour:
				nw.WarePricePerMonth = strconv.Itoa(int(w.PricePerMonth) * 12)
				wares3n = append(wares3n, nw)
			}
		}
	} else if err == gorm.ErrRecordNotFound {
		wares1n = append(wares1n, ware{
			WareName:          "empty",
			WarePricePerMonth: "9999",
			Intros: []intro{{
				First:  "add some in admin console page",
				Second: "they will show here",
			},
			},
		})
	} else {
		wares1n = append(wares1n, ware{
			WareName:          "database error",
			WarePricePerMonth: "9999",
			Intros: []intro{{
				First:  "repair your database",
				Second: "",
			},
			},
		})
	}
	wares1 = wares1n
	wares2 = wares2n
	wares3 = wares3n
}

func (this *WareSellerController) Prepare() {
}

func (this *WareSellerController) Get() {
	// this.Data["langTemplateKey"] = this.Ctx.Request.Header.Get("Accept-Language")
	this.TplName = "WareSeller.html"
	this.Data["u"] = 1
	handleNavbar(&this.Controller)
	// glgf.Debug(wares)
	this.Data["wares1"] = wares1
	this.Data["wares2"] = wares2
	this.Data["wares3"] = wares3
}
