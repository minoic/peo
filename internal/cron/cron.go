package cron

import (
	"fmt"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/controllers"
	"github.com/minoic/peo/internal/cryptoo"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/status"
	"time"
)

func LoopTasksManager() {
	defer func() {
		if err := recover(); err != nil {
			glgf.Error("cron error caught:", fmt.Errorf("%v", err).Error())
			LoopTasksManager()
		}
	}()
	controllers.RefreshWareInfo()
	DB := database.Mysql()
	ticker := time.NewTicker(10 * time.Minute)
	ticker2 := time.NewTicker(30 * time.Second)
	for {
		select {
		case <-ticker.C:
			// todo: 更新任务调用方式防止单任务阻塞全局任务
			controllers.RefreshWareInfo()
			pterodactyl.CheckServers()
			pterodactyl.CacheNeededEggs()
			pterodactyl.CacheNeededServers()
		case <-ticker2.C:
			controllers.RefreshServerInfo()
			func() {
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
				// glgf.Info("Servers Online - ",count)
			}()
			cryptoo.DeleteOutdatedKeys()
		}
	}
}
