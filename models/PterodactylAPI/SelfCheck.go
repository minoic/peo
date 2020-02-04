package PterodactylAPI

import (
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"github.com/astaxie/beego"
	"time"
)

func CheckServers() {
	var entities []MinoDatabase.WareEntity
	DB := MinoDatabase.GetDatabase()
	DB.Find(&entities)
	for _, entity := range entities {
		if entity.ValidDate.Before(time.Now()) &&
			entity.ValidDate.AddDate(0, 0, 7).After(time.Now()) {
			server := PterodactylGetServer(ConfGetParams(), entity.ServerExternalID, true)
			if server != (PterodactylServer{}) && !server.Suspended {
				err := PterodactylSuspendServer(ConfGetParams(), server.ExternalId)
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
				err := PterodactylDeleteServer(ConfGetParams(), entity.ServerExternalID)
				if err != nil {
					beego.Error(err)
				}
			}

		}
	}
}

func CacheNeededEggs() {
	var wareSpecs []MinoDatabase.WareSpec
	DB := MinoDatabase.GetDatabase()
	if !DB.Find(&wareSpecs).RecordNotFound() {
		for _, spec := range wareSpecs {
			PterodactylGetEgg(ConfGetParams(), spec.Nest, spec.Egg)
		}
	}
}

func confirmDeleteServer(entity MinoDatabase.WareEntity) {
	//todo: add a page to manage the deletion
}
