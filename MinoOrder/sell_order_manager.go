package MinoOrder

import (
	"errors"
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/MinoIC-PE/MinoMessage"
	"github.com/MinoIC/MinoIC-PE/PterodactylAPI"
	"github.com/MinoIC/glgf"
	"github.com/jinzhu/gorm"
	"strconv"
	"time"
)

func SellCreate(SpecID uint, userID uint) uint {
	DB := MinoDatabase.GetDatabase()
	var (
		wareSpec    MinoDatabase.WareSpec
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
		if MinoConfigure.TotalDiscount {
			finalPrice = uint(0.01 * float32(uint(100-wareSpec.Discount)*wareSpec.PricePerMonth))
		} else {
			finalPrice = uint(0.01 * float32(100*wareSpec.PricePerMonth))
		}
	case 90 * 24 * time.Hour:
		originPrice = wareSpec.PricePerMonth * 3
		if MinoConfigure.TotalDiscount {
			finalPrice = uint(0.03 * float32(uint(100-wareSpec.Discount)*wareSpec.PricePerMonth))
		} else {
			finalPrice = uint(0.03 * float32(100*wareSpec.PricePerMonth))
		}
	case 365 * 24 * time.Hour:
		originPrice = wareSpec.PricePerMonth * 12
		if MinoConfigure.TotalDiscount {
			finalPrice = uint(0.12 * float32(uint(100-wareSpec.Discount)*wareSpec.PricePerMonth))
		} else {
			finalPrice = uint(0.12 * float32(100*wareSpec.PricePerMonth))
		}
	}
	// glgf.Debug(originPrice, finalPrice)
	order := MinoDatabase.Order{
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

func SellGet(orderID uint) (MinoDatabase.Order, error) {
	var order MinoDatabase.Order
	DB := MinoDatabase.GetDatabase()
	if !DB.Where("id = ?", orderID).First(&order).RecordNotFound() {
		return order, nil
	}
	return MinoDatabase.Order{}, errors.New("cant find order by id " + strconv.Itoa(int(orderID)))
}

func SellPaymentCheck(orderID uint, keyString string, selectedIP int, hostName string) error {
	DB := MinoDatabase.GetDatabase()
	var (
		order MinoDatabase.Order
		key   MinoDatabase.WareKey
		user  MinoDatabase.User
		spec  MinoDatabase.WareSpec
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
	pteUser, ok := PterodactylAPI.GetUser(PterodactylAPI.ConfGetParams(), user.Name, true)
	if !ok || pteUser == (PterodactylAPI.PterodactylUser{}) {
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
	err := PterodactylAPI.PterodactylCreateServer(PterodactylAPI.ConfGetParams(), PterodactylAPI.PterodactylServer{
		UserId:      pteUser.Uid,
		ExternalId:  user.Name + strconv.Itoa(int(orderID)),
		Name:        user.Name + strconv.Itoa(int(orderID)),
		Description: "到期时间：" + exp,
		Suspended:   false,
		Limits: PterodactylAPI.PterodactylServerLimit{
			Memory: spec.Memory,
			Swap:   spec.Swap,
			Disk:   spec.Disk,
			IO:     spec.Io,
			CPU:    spec.Cpu,
		},
		Allocation: selectedIP,
		NestId:     spec.Nest,
		EggId:      spec.Egg,
		PackId:     0,
	})
	if err == nil {
		entity := MinoDatabase.WareEntity{
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
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(orderID)))
			return err
		}
		if err = DB.Model(&order).Update("allocation_id", selectedIP).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("confirmed", true).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("paid", true).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Delete(&key).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(orderID)))
			DB.Delete(&entity)
			DB.Model(&order).Update("paid", false)
			return err
		}
		glgf.Info("KeyString used: " + key.KeyString)
		MinoMessage.Send("ADMIN", user.ID, "您的订单 #"+strconv.Itoa(int(order.ID))+" 已成功创建对应服务器，请前往控制台确认")
		glgf.Info("order id confirmed: " + strconv.Itoa(int(orderID)))
	} else {
		glgf.Error("cant create server for order id: " + strconv.Itoa(int(orderID)) + "with error: " + err.Error())
		return err
	}
	return nil
}

func SellPaymentCheckByBalance(order *MinoDatabase.Order, user *MinoDatabase.User, selectedIP int, hostName string) error {
	DB := MinoDatabase.GetDatabase()
	var (
		spec MinoDatabase.WareSpec
		exp  string
	)
	if user.Balance < order.FinalPrice {
		return errors.New("您的余额不足")
	}
	if err := DB.Where("id = ?", order.SpecID).First(&spec).Error; err != nil {
		return errors.New("无法获取对应商品")
	}
	pteUser, ok := PterodactylAPI.GetUser(PterodactylAPI.ConfGetParams(), user.Name, true)
	if !ok || pteUser == (PterodactylAPI.PterodactylUser{}) {
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
	err := PterodactylAPI.PterodactylCreateServer(PterodactylAPI.ConfGetParams(), PterodactylAPI.PterodactylServer{
		UserId:      pteUser.Uid,
		ExternalId:  user.Name + strconv.Itoa(int(order.ID)),
		Name:        user.Name + strconv.Itoa(int(order.ID)),
		Description: "到期时间：" + exp,
		Suspended:   false,
		Limits: PterodactylAPI.PterodactylServerLimit{
			Memory: spec.Memory,
			Swap:   spec.Swap,
			Disk:   spec.Disk,
			IO:     spec.Io,
			CPU:    spec.Cpu,
		},
		Allocation: selectedIP,
		NestId:     spec.Nest,
		EggId:      spec.Egg,
		PackId:     0,
	})
	if err == nil {
		entity := MinoDatabase.WareEntity{
			Model:            gorm.Model{},
			UserID:           order.UserID,
			ServerExternalID: user.Name + strconv.Itoa(int(order.ID)),
			UserExternalID:   user.Name,
			HostName:         hostName,
			DeleteStatus:     0,
			ValidDate:        time.Now().Add(spec.ValidDuration),
		}
		if err := DB.Create(&entity).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(order.ID)))
			return err
		}
		if err = DB.Model(&order).Update("allocation_id", selectedIP).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("confirmed", true).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			return err
		}
		if err = DB.Model(&order).Update("paid", true).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			DB.Model(&order).Update("paid", false).Update("confirmed", false)
			return err
		}
		if err = DB.Model(&user).Update("balance", user.Balance-order.FinalPrice).Error; err != nil {
			_ = PterodactylAPI.PterodactylDeleteServer(PterodactylAPI.ConfGetParams(), user.Name+strconv.Itoa(int(order.ID)))
			DB.Delete(&entity)
			DB.Model(&order).Update("paid", false).Update("confirmed", false)
			return err
		}
		MinoMessage.Send("ADMIN", user.ID, "您的订单 #"+strconv.Itoa(int(order.ID))+" 已成功创建对应服务器，请前往控制台确认")
	} else {
		return err
	}
	return nil
}
