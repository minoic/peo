package AutoManager

import (
	"github.com/MinoIC/MinoIC-PE/Controllers"
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/MinoIC-PE/MinoKey"
	"github.com/MinoIC/MinoIC-PE/PterodactylAPI"
	"github.com/MinoIC/MinoIC-PE/ServerStatus"
	"github.com/astaxie/beego"
	"time"
)

func LoopTasksManager() {
	// random task
	go func() {
		interval, err := MinoConfigure.GetConf().Int("AutoTaskInterval")
		if err != nil {
			interval = 10
			beego.Error("cant get AutoTaskInterval ,set it to 10sec as default")
		}
		ticker := time.NewTicker(time.Duration(interval) * time.Second)
		for {
			select {
			case <-ticker.C:
				go PterodactylAPI.CheckServers()
			case <-ticker.C:
				go PterodactylAPI.CacheNeededEggs()
			case <-ticker.C:
				go PterodactylAPI.CacheNeededServers()
			case <-ticker.C:
				go Controllers.RefreshWareInfo()
			case <-ticker.C:
				go MinoKey.DeleteOutdatedKeys()
			case <-ticker.C:
				go func() {
					DB := MinoDatabase.GetDatabase()
					beego.Info("DB_OpenConnections: ", DB.DB().Stats().OpenConnections, " - ",
						DB.DB().Stats().WaitCount)
				}()
			}
		}
	}()
	// always go task
	go func() {
		ticker := time.NewTicker(5 * time.Minute)
		for {
			select {
			case <-ticker.C:
				go func() {
					DB := MinoDatabase.GetDatabase()
					var (
						entities []MinoDatabase.WareEntity
						count    int
					)
					DB.Find(&entities)
					for _, e := range entities {
						pong, err := ServerStatus.Ping(e.HostName)
						if err == nil && pong.Version.Protocol != 0 {
							var user MinoDatabase.User
							DB.Model(&MinoDatabase.User{}).Where("id = ?", e.UserID).First(&user)
							DB.Model(&user).Update("total_up_time", user.TotalUpTime+5*time.Minute)
							count++
						}
					}
					// beego.Info("Servers Online - ",count)
				}()
			}
		}
	}()
}
