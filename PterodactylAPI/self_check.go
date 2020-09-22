package PterodactylAPI

import (
	"errors"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/glgf"
	"github.com/jinzhu/gorm"
	"strconv"
	"time"
)

func CheckServers() {
	var entities []MinoDatabase.WareEntity
	cli := ClientFromConf()
	DB := MinoDatabase.GetDatabase()
	DB.Find(&entities)
	for _, entity := range entities {
		if entity.DeleteStatus == 1 {
			if time.Now().Before(entity.ValidDate) {
				DB.Delete(&MinoDatabase.DeleteConfirm{}, "ware_id = ?", entity.ID)
				DB.Model(&entity).Update("delete_status", 0)
				glgf.Info("removed delete confirm for entity: ", entity.ServerExternalID)
			}
			continue
		}
		if entity.ValidDate.Before(time.Now()) &&
			entity.ValidDate.AddDate(0, 0, 10).After(time.Now()) {
			server, err := cli.getServer(entity.ServerExternalID, true)
			if err == nil && !server.Suspended {
				err := cli.SuspendServer(server.ExternalId)
				glgf.Info("server suspended because Expired: ", entity.ServerExternalID)
				if err != nil {
					glgf.Error(err)
				}
			} else {
				glgf.Warn("nonexistent wareEntity: ", entity)
			}
		} else if entity.ValidDate.AddDate(0, 0, 10).Before(time.Now()) {
			if entity.DeleteStatus == 0 {
				addConfirmWareEntity(entity)
				DB.Model(&entity).Update("delete_status", 1)
				glgf.Info("server added to delete confirm list because Expired more than 10 days: ",
					entity.ServerExternalID)
			} else if entity.DeleteStatus == 2 {
				err := cli.DeleteServer(entity.ServerExternalID)
				if err != nil {
					glgf.Error(err)
				} else {
					DB.Delete(&entity)
				}
			}
		} else if entity.ValidDate.After(time.Now()) && entity.DeleteStatus != 0 {
			DB.Model(&entity).Update("delete_status", 0)
			DB.Delete(&MinoDatabase.DeleteConfirm{}, "ware_id = ?", entity.ID)
			err := cli.UnsuspendServer(entity.ServerExternalID)
			if err != nil {
				glgf.Error(err)
			}
		}
	}
}

func CacheNeededEggs() {
	var wareSpecs []MinoDatabase.WareSpec
	DB := MinoDatabase.GetDatabase()
	if !DB.Find(&wareSpecs).RecordNotFound() {
		for _, spec := range wareSpecs {
			ClientFromConf().GetEgg(spec.Nest, spec.Egg)
		}
	}
}

func CacheNeededServers() {
	var entities []MinoDatabase.WareEntity
	DB := MinoDatabase.GetDatabase()
	if !DB.Find(&entities).RecordNotFound() {
		for _, entity := range entities {
			ClientFromConf().GetServer(entity.ServerExternalID)
		}
	}
}

func ConfirmDelete(entityID uint) error {
	var entity MinoDatabase.WareEntity
	DB := MinoDatabase.GetDatabase()
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		return errors.New("cant find entity by ID: " + strconv.Itoa(int(entityID)))
	}
	err := ClientFromConf().DeleteServer(entity.ServerExternalID)
	if err != nil {
		return err
	}
	DB.Delete(&entity)
	DB.Where("ware_id = ?", entityID).Delete(&MinoDatabase.DeleteConfirm{})
	return nil
}

func GetConfirmWareEntities() []MinoDatabase.WareEntity {
	DB := MinoDatabase.GetDatabase()
	var entities []MinoDatabase.WareEntity
	DB.Find(&entities)
	glgf.Debug(entities)
	return entities
}

func addConfirmWareEntity(entity MinoDatabase.WareEntity) {
	DB := MinoDatabase.GetDatabase()
	d := MinoDatabase.DeleteConfirm{
		Model:  gorm.Model{},
		WareID: entity.ID,
	}
	if err := DB.Create(&d).Error; err != nil {
		glgf.Error(err)
	}
}
