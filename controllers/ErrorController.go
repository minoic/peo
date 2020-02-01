package controllers

import (
	"git.ntmc.tech/root/MinoIC-PE/models"
	"github.com/astaxie/beego"
)

type ErrorController struct {
	beego.Controller
}

func (this *ErrorController) Error400() {
	DelayRedirect(DelayInfo{
		URL:    "/",
		Detail: "请求参数有误",
		Title:  "400 Bad Request",
	}, &this.Controller)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error401() {
	DelayRedirect(DelayInfo{
		URL:    models.ConfGetHostName(),
		Detail: "未经授权，请求要求验证身份",
		Title:  "401 Unauthorized",
	}, &this.Controller)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error403() {
	DelayRedirect(DelayInfo{
		URL:    models.ConfGetHostName(),
		Detail: "服务器拒绝请求",
		Title:  "403 Forbidden",
	}, &this.Controller)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error404() {
	DelayRedirect(DelayInfo{
		URL:    models.ConfGetHostName(),
		Detail: "找不到指定页面",
		Title:  "404 Not Found",
	}, &this.Controller)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error500() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: "服务器遇到了一个未曾预料的状况",
		Title:  "500 Internal Server Error",
	}, &this.Controller)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error502() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: "从上游服务器接收到无效的响应",
		Title:  "502 Bad Gateway",
	}, &this.Controller)
	this.TplName = "Delay.html"
}
func (this *ErrorController) Error503() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: "临时的服务器维护或者过载",
		Title:  "503 Service Unavailable",
	}, &this.Controller)
	this.TplName = "Delay.html"
}

func (this *ErrorController) Error504() {
	DelayRedirect(DelayInfo{
		URL:    this.Ctx.Request.Referer(),
		Detail: "未能及时从上游服务器或者辅助服务器收到响应",
		Title:  "504 Gateway Timeout",
	}, &this.Controller)
	this.TplName = "Delay.html"
}
