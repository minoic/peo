package controllers

import "github.com/astaxie/beego"

type WareChartController struct {
	beego.Controller
}

func (this *WareChartController) Get() {
	this.TplName = "Index.html"
}
