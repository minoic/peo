package main

import (
	"github.com/beego/beego/v2/server/web"
	"github.com/minoic/peo/api"
	"github.com/minoic/peo/internal/controllers"
	"github.com/minoic/peo/internal/cron"
)

var (
	BUILD_TIME string
	GO_VERSION string
)

func main() {
	controllers.BuildTime = BUILD_TIME
	controllers.GoVersion = GO_VERSION
	api.InitRouter()
	go cron.LoopTasksManager()
	web.Run()
}
