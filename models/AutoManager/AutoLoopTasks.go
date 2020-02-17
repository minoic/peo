package AutoManager

import (
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
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

			}
		}
	}()
}
