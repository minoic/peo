package AutoManager

import (
	"NTPE/models/PterodactylAPI"
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
