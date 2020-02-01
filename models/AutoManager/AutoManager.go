package AutoManager

import (
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"time"
)

func LoopManager() {
	go func() {
		ticker := time.NewTicker(10 * time.Second)
		for {
			select {
			case <-ticker.C:
				go PterodactylAPI.CheckServers()
			}
		}
	}()
}
