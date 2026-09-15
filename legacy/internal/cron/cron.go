package cron

import (
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/controllers"
	"github.com/minoic/peo/internal/cryptoo"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/status"
	"github.com/robfig/cron/v3"
	"time"
)

func LoopTasksManager() {
	DB := database.Mysql()
	go controllers.RefreshWareInfo()
	go CacheNeededEggs()
	c := cron.New()
	c.AddFunc("@every 1m", controllers.RefreshWareInfo)
	c.AddFunc("@every 5s", controllers.RefreshServerInfo)
	c.AddFunc("@every 5m", pterodactyl.CheckServers)
	c.AddFunc("@every 5m", CacheNeededEggs)
	c.AddFunc("@every 30m", cryptoo.DeleteOutdatedKeys)
	c.AddFunc("@every 30s", func() {
		var (
			entities []database.WareEntity
			count    int
		)
		DB.Find(&entities)
		for _, e := range entities {
			pong, err := status.Ping(e.HostName)
			if err == nil && pong.Version.Protocol != 0 {
				var user database.User
				DB.Model(&database.User{}).Where("id = ?", e.UserID).First(&user)
				DB.Model(&user).Update("total_up_time", user.TotalUpTime+30*time.Second)
				count++
			}
		}
	})
	c.Run()
}

func CacheNeededEggs() {
	var wareSpecs []database.WareSpec
	DB := database.Mysql()
	if !DB.Find(&wareSpecs).RecordNotFound() {
		for _, spec := range wareSpecs {
			eggs, err := pterodactyl.ClientFromConf().GetAllEggs(spec.Nest)
			if err != nil {
				glgf.Error(err)
				continue
			}
			controllers.EggsMap.Store(spec.Nest, eggs)
		}
	}
}
