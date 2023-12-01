package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/session"
	"github.com/spf13/cast"
)

type AdminConsoleOrderController struct {
	web.Controller
	i18n.Locale
}

func (this *AdminConsoleOrderController) Prepare() {
	this.TplName = "AdminConsoleOrder.html"
	this.Data["u"] = 4
	handleNavbar(&this.Controller)
	sess := this.StartSession()
	if !session.Logged(sess) {
		this.Abort("401")
	} else if !session.IsAdmin(sess) {
		this.Abort("401")
	}
	var orders []database.Order
	database.Mysql().Find(&orders)
	var ret []map[string]any
	for i := range orders {
		if !orders[i].Paid {
			continue
		}
		var user database.User
		var spec database.WareSpec
		database.Mysql().Where("id = ?", orders[i].UserID).Find(&user)
		database.Mysql().Where("id = ?", orders[i].SpecID).Find(&spec)
		ret = append(ret, map[string]any{
			"ID":           orders[i].ID,
			"FinalPrice":   cast.ToString(orders[i].FinalPrice) + "￥",
			"UserName":     user.Name,
			"CreatedAt":    orders[i].CreatedAt,
			"SpecName":     spec.WareName,
			"SpecDuration": cast.ToString(cast.ToInt(spec.ValidDuration.Hours()/24)) + "Days",
		})
	}
	this.Data["orders"] = ret
}

func (this *AdminConsoleOrderController) Get() {

}
