package models

import (
	"github.com/astaxie/beego"
	"time"
)

func LoopManager() {
	go func() {
		ticker := time.NewTicker(10 * time.Second)
		for {
			select {
			case <-ticker.C:
				go checkServers()
			}
		}
	}()
}

func checkServers() {
	var entities []WareEntity
	DB := GetDatabase()
	DB.Find(&entities)
	for _, entity := range entities {
		if entity.ValidDate.Before(time.Now()) &&
			entity.ValidDate.AddDate(0, 0, 7).After(time.Now()) {
			server := PterodactylGetServer(confGetParams(), entity.ServerExternalID, true)
			if server != (PterodactylServer{}) && !server.Suspended {
				err := PterodactylSuspendServer(confGetParams(), server.ExternalId)
				if err != nil {
					beego.Error(err)
				}
			} else {
				beego.Warn("nonexistent wareEntity: ", entity)
			}
		}
		if entity.ValidDate.AddDate(0, 0, 7).Before(time.Now()) {
			if entity.DeleteStatus == 0 {
				confirmDeleteServer(entity)
				entity.DeleteStatus = 1
			} else if entity.DeleteStatus == 2 {
				err := PterodactylDeleteServer(confGetParams(), entity.ServerExternalID)
				if err != nil {
					beego.Error(err)
				}
			}

		}
	}
}

func confirmDeleteServer(entity WareEntity) {

}
