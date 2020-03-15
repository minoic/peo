package AutoManager

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoKey"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"time"
)

func LoopTasksManager() {
	go func() {
		ticker := time.NewTicker(10 * time.Second)
		for {
			select {
			case <-ticker.C:
				go PterodactylAPI.CheckServers()
			case <-ticker.C:
				go PterodactylAPI.CacheNeededEggs()
			case <-ticker.C:
				go PterodactylAPI.CacheNeededServers()
			case <-ticker.C:
				go MinoKey.DeleteOutdatedKeys()
			case <-ticker.C:
				go func() {
					DB := MinoDatabase.GetDatabase()
					beego.Info("DB_OpenConnections: ", DB.DB().Stats().OpenConnections, "(", DB.DB().Stats().WaitDuration, ")")
				}()
			}
		}
	}()
}
