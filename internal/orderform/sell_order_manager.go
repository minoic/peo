package orderform

import (
	"errors"
	"github.com/jinzhu/gorm"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/pterodactyl"
	"strconv"
	"time"
)

func SellCreate(SpecID uint, userID uint) uint {
	DB := database.Mysql()
	var (
		wareSpec    database.WareSpec
		finalPrice  uint
		originPrice uint
	)
	DB.Where("id = ?", SpecID).First(&wareSpec)
	switch wareSpec.ValidDuration {
	case 3 * 24 * time.Hour:
		originPrice = 1
		finalPrice = 1
	case 30 * 24 * time.Hour:
		originPrice = wareSpec.PricePerMonth
		if configure.Viper().GetBool("TotalDiscount") {
			finalPrice = uint(0.01 * float32(uint(100-wareSpec.Discount)*wareSpec.PricePerMonth))
		} else {
			finalPrice = uint(0.01 * float32(100*wareSpec.PricePerMonth))
		}
	case 90 * 24 * time.Hour:
		originPrice = wareSpec.PricePerMonth * 3
		if configure.Viper().GetBool("TotalDiscount") {
			finalPrice = uint(0.03 * float32(uint(100-wareSpec.Discount)*wareSpec.PricePerMonth))
		} else {
			finalPrice = uint(0.03 * float32(100*wareSpec.PricePerMonth))
		}
	case 365 * 24 * time.Hour:
		originPrice = wareSpec.PricePerMonth * 12
		if configure.Viper().GetBool("TotalDiscount") {
			finalPrice = uint(0.12 * float32(uint(100-wareSpec.Discount)*wareSpec.PricePerMonth))
		} else {
			finalPrice = uint(0.12 * float32(100*wareSpec.PricePerMonth))
		}
	}
	// glgf.Debug(originPrice, finalPrice)
	order := database.Order{
		Model:       gorm.Model{},
		SpecID:      SpecID,
		UserID:      userID,
		OriginPrice: originPrice,
		FinalPrice:  finalPrice,
		Paid:        false,
		Confirmed:   false,
	}
	DB.Create(&order)
	return order.ID
}

func SellGet(orderID uint) (database.Order, error) {
	var order database.Order
	DB := database.Mysql()
	if !DB.Where("id = ?", orderID).First(&order).RecordNotFound() {
		return order, nil
	}
	return database.Order{}, errors.New("cant find order by id " + strconv.Itoa(int(orderID)))
}

func SellPaymentCheck(orderID uint, keyString string, selectedIP int, hostName string) error {
	DB := database.Mysql()
	cli := pterodactyl.ClientFromConf()
	var (
		order database.Order
		key   database.WareKey
		user  database.User
		spec  database.WareSpec
		exp   string
	)
	if DB.Where("id = ?", orderID).First(&order).RecordNotFound() {
		return errors.New("cant find order by id: " + strconv.Itoa(int(orderID)))
	}
	if order.Paid {
		return errors.New("order is already paid: " + strconv.Itoa(int(orderID)))
	}
	if DB.Where("key_string = ?", keyString).First(&key).RecordNotFound() {
		return errors.New("cant find key: " + keyString)
	}
	if key.Exp.Before(time.Now()) || key.SpecID != order.SpecID {
		return errors.New("invalid key: " + keyString)
	}
	if DB.Where("id = ?", order.UserID).First(&user).RecordNotFound() {
		return errors.New("cant find order`s owner by id: " + strconv.Itoa(int(order.UserID)))
	}
	if DB.Where("id = ?", order.SpecID).First(&spec).RecordNotFound() {
		return errors.New("cant find wareSpec by id: " + strconv.Itoa(int(order.SpecID)))
	}
	pteUser, err := cli.GetUser(user.Name, true)
	if err != nil {
		return errors.New("cant find pte user: " + user.Name)
	}
	switch spec.ValidDuration {
	case 3 * 24 * time.Hour:
		exp = time.Now().AddDate(0, 0, 3).Format("2006-01-02")
	case 30 * 24 * time.Hour:
		exp = time.Now().AddDate(0, 1, 0).Format("2006-01-02")
	case 90 * 24 * time.Hour:
		exp = time.Now().AddDate(0, 3, 0).Format("2006-01-02")
	case 365 * 24 * time.Hour:
		exp = time.Now().AddDate(1, 0, 0).Format("2006-01-02")
	}
	err = cli.CreateServer(pterodactyl.Server{
		ExternalId:  user.Name + strconv.Itoa(int(orderID)),
		Name:        user.Name + strconv.Itoa(int(orderID)),
		Description: "到期时间：" + exp,
		Suspended:   false,
		Limits: pterodactyl.ServerLimit{
			Memory: spec.Memory,
			Swap:   spec.Swap,
			Disk:   spec.Disk,
			IO:     spec.Io,
			CPU:    spec.Cpu,
		},
		FeatureLimits: pterodactyl.FeatureLimit{
			Backups: spec.Backups,
		},
		UserId:     pteUser.Uid,
		NodeId:     spec.Node,
		Allocation: selectedIP,
		NestId:     spec.Nest,
		EggId:      spec.Egg,
	})
	if err == nil {
		entity := database.WareEntity{
			Model:            gorm.Model{},
			UserID:           order.UserID,
			ServerExternalID: user.Name + strconv.Itoa(int(orderID)),
			UserExternalID:   user.Name,
			HostName:         hostName,
			DeleteStatus:     0,
			SpecID:           spec.ID,
			ValidDate:        time.Now().Add(spec.ValidDuration),
		}
		if err := DB.Create(&entity).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(orderID)))
			return err
		}
		if err = DB.Model(&order).Update("allocation_id", selectedIP).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("confirmed", true).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("paid", true).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Delete(&key).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			DB.Model(&order).Update("paid", false)
			return err
		}
		glgf.Info("KeyString used: " + key.KeyString)
		message.Send("ADMIN", user.ID, "您的订单 #"+strconv.Itoa(int(order.ID))+" 已成功创建对应服务器，请前往控制台确认")
		glgf.Info("order id confirmed: " + strconv.Itoa(int(orderID)))
	} else {
		glgf.Error("cant create server for order id: " + strconv.Itoa(int(orderID)) + "with error: " + err.Error())
		return err
	}
	return nil
}

func SellPaymentCheckByBalance(order *database.Order, user *database.User, selectedIP int, hostName string) error {
	DB := database.Mysql()
	cli := pterodactyl.ClientFromConf()
	var (
		spec database.WareSpec
		exp  string
	)
	if user.Balance < order.FinalPrice {
		return errors.New("您的余额不足")
	}
	if err := DB.Where("id = ?", order.SpecID).First(&spec).Error; err != nil {
		return errors.New("无法获取对应商品")
	}
	pteUser, err := cli.GetUser(user.Name, true)
	if err != nil {
		return errors.New("cant find pte user: " + user.Name)
	}
	switch spec.ValidDuration {
	case 3 * 24 * time.Hour:
		exp = time.Now().AddDate(0, 0, 3).Format("2006-01-02")
	case 30 * 24 * time.Hour:
		exp = time.Now().AddDate(0, 1, 0).Format("2006-01-02")
	case 90 * 24 * time.Hour:
		exp = time.Now().AddDate(0, 3, 0).Format("2006-01-02")
	case 365 * 24 * time.Hour:
		exp = time.Now().AddDate(1, 0, 0).Format("2006-01-02")
	}
	err = cli.CreateServer(pterodactyl.Server{
		ExternalId:  user.Name + strconv.Itoa(int(order.ID)),
		Name:        user.Name + strconv.Itoa(int(order.ID)),
		Description: "到期时间：" + exp,
		Suspended:   false,
		Limits: pterodactyl.ServerLimit{
			Memory: spec.Memory,
			Swap:   spec.Swap,
			Disk:   spec.Disk,
			IO:     spec.Io,
			CPU:    spec.Cpu,
		},
		FeatureLimits: pterodactyl.FeatureLimit{
			Backups: spec.Backups,
		},
		UserId:     pteUser.Uid,
		NodeId:     spec.Node,
		Allocation: selectedIP,
		NestId:     spec.Nest,
		EggId:      spec.Egg,
	})
	if err == nil {
		entity := database.WareEntity{
			Model:            gorm.Model{},
			UserID:           order.UserID,
			ServerExternalID: user.Name + strconv.Itoa(int(order.ID)),
			UserExternalID:   user.Name,
			HostName:         hostName,
			SpecID:           spec.ID,
			DeleteStatus:     0,
			ValidDate:        time.Now().Add(spec.ValidDuration),
		}
		if err := DB.Create(&entity).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(order.ID)))
			return err
		}
		if err = DB.Model(&order).Update("allocation_id", selectedIP).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("confirmed", true).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("paid", true).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			DB.Model(&order).Update("paid", false).Update("confirmed", false)
			return err
		}
		if err = DB.Model(&user).Update("balance", user.Balance-order.FinalPrice).Error; err != nil {
			_ = cli.DeleteServer(user.Name + strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			DB.Model(&order).Update("paid", false).Update("confirmed", false)
			return err
		}
		message.Send("ADMIN", user.ID, "您的订单 #"+strconv.Itoa(int(order.ID))+" 已成功创建对应服务器，请前往控制台确认")
	} else {
		return err
	}
	return nil
}
