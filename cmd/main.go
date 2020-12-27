package main

import (
	"github.com/MinoIC/peo/api"
	"github.com/MinoIC/peo/internal/cron"
	"github.com/astaxie/beego"
)

const Version = "v0.1.0"

func main() {
	beego.BConfig.WebConfig.Session.SessionDisableHTTPOnly = true
	api.InitRouter()
	go cron.LoopTasksManager()
	beego.Run()
}

// todo: add code comments
