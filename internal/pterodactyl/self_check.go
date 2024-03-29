package pterodactyl

import (
	"errors"
	"github.com/jinzhu/gorm"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"github.com/minoic/peo/internal/message"
	"strconv"
	"time"
)

func CheckServers() {
	var entities []database.WareEntity
	cli := ClientFromConf()
	DB := database.Mysql()
	DB.Find(&entities)
	for _, entity := range entities {
		if entity.DeleteStatus == 1 {
			if time.Now().Before(entity.ValidDate) {
				DB.Delete(&database.DeleteConfirm{}, "ware_id = ?", entity.ID)
				DB.Model(&entity).Update("delete_status", 0)
				glgf.Info("removed delete confirm for entity: ", entity.ServerExternalID)
			}
			continue
		}
		if entity.ValidDate.Before(time.Now()) &&
			entity.ValidDate.AddDate(0, 0, 10).After(time.Now()) {
			server, err := cli.GetServer(entity.ServerExternalID, true)
			if err == nil && !server.Suspended {
				err := cli.SuspendServer(server.ExternalId)
				if err != nil {
					glgf.Error(err)
				}
				glgf.Info("server suspended because Expired: ", entity.ServerExternalID)
				message.Send("ADMIN", entity.UserID, "您的服务器 <", entity.ServerExternalID, "> 因过期被暂停使用，请及时续费！")
				var user database.User
				if err := DB.First(&user, "id = ?", entity.UserID).Error; err != nil {
					message.SendAdmin("server with Non-existent user:", entity.ServerExternalID)
					continue
				}
				err = email.SendAnyEmail(user.Email, "您的服务器 <", entity.ServerExternalID, "> 已过期暂停，如需延长服务或保留数据请及时续费！")
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
			DB.Delete(&database.DeleteConfirm{}, "ware_id = ?", entity.ID)
			err := cli.UnsuspendServer(entity.ServerExternalID)
			if err != nil {
				glgf.Error(err)
			}
		}
	}
}

func ConfirmDelete(entityID uint) error {
	var entity database.WareEntity
	DB := database.Mysql()
	if DB.Where("id = ?", entityID).First(&entity).RecordNotFound() {
		return errors.New("cant find entity by ID: " + strconv.Itoa(int(entityID)))
	}
	err := ClientFromConf().DeleteServer(entity.ServerExternalID)
	if err != nil {
		return err
	}
	DB.Delete(&entity)
	DB.Where("ware_id = ?", entityID).Delete(&database.DeleteConfirm{})
	return nil
}

func GetConfirmWareEntities() []database.WareEntity {
	DB := database.Mysql()
	var entities []database.WareEntity
	DB.Find(&entities)
	glgf.Debug(entities)
	return entities
}

func addConfirmWareEntity(entity database.WareEntity) {
	DB := database.Mysql()
	d := database.DeleteConfirm{
		Model:  gorm.Model{},
		WareID: entity.ID,
	}
	if err := DB.Create(&d).Error; err != nil {
		glgf.Error(err)
	}
}
