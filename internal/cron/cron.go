package cron

import (
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

	c := cron.New()
	c.AddFunc("@every 10s", controllers.RefreshWareInfo)
	c.AddFunc("@every 5s", controllers.RefreshServerInfo)
	c.AddFunc("@every 5m", pterodactyl.CheckServers)
	c.AddFunc("@every 5m", pterodactyl.CacheNeededEggs)
	c.AddFunc("@every 5m", pterodactyl.CacheNeededServers)
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
