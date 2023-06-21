package controllers

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
)

type ErrorController struct {
	web.Controller
	i18n.Locale
}

func (this *ErrorController) Prepare() {

}

func (this *ErrorController) Error400() {
	DelayRedirect(DelayInfo{
		URL:    "/",
		Detail: tr("error.400"),
		Title:  "400 Bad Request",
	}, &this.Controller, 400)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error401() {
	DelayRedirect(DelayInfo{
		URL:    "/login",
		Detail: tr("error.401"),
		Title:  "401 Unauthorized",
	}, &this.Controller, 401)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error403() {
	DelayRedirect(DelayInfo{
		URL:    "/",
		Detail: tr("error.403"),
		Title:  "403 Forbidden",
	}, &this.Controller, 403)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error404() {
	DelayRedirect(DelayInfo{
		URL:    "/",
		Detail: tr("error.404") + this.Ctx.Request.URL.String(),
		Title:  "404 Not Found 😭",
	}, &this.Controller, 404)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error405() {
	DelayRedirect(DelayInfo{
		URL:    "/",
		Detail: tr("error.405") + this.Ctx.Request.Method,
		Title:  "405 Method not Allowed",
	}, &this.Controller, 405)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error500() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: tr("error.500"),
		Title:  "500 Internal Server Error",
	}, &this.Controller, 500)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error502() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: tr("error.502"),
		Title:  "502 Bad Gateway",
	}, &this.Controller, 502)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error503() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: tr("error.503"),
		Title:  "503 Service Unavailable",
	}, &this.Controller, 503)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error504() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: tr("error.504"),
		Title:  "504 Gateway Timeout",
	}, &this.Controller, 504)
	this.TplName = "Delay.html"
}
