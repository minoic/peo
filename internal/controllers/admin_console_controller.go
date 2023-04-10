package controllers

import (
	"compress/flate"
	"github.com/beego/beego/v2/server/web"
	"github.com/beego/i18n"
	"github.com/hako/durafmt"
	"github.com/mholt/archiver"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/cryptoo"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/email"
	"github.com/minoic/peo/internal/message"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/session"
	"html/template"
	"os"
	"strconv"
	"sync"
	"time"
)

type AdminConsoleController struct {
	web.Controller
	i18n.Locale
}

func (this *AdminConsoleController) Prepare() {
	this.TplName = "AdminConsole.html"
	this.Data["lang"] = configure.Viper().GetString("Language")
	this.Data["u"] = 4
	handleNavbar(&this.Controller)
	sess := this.StartSession()
	if !session.Logged(sess) {
		this.Abort("401")
	} else if !session.IsAdmin(sess) {
		this.Abort("401")
	}
}

type dServer struct {
	ServerName            string
	ServerConsoleHostName template.URL
	ServerIdentifier      string
	DeleteURL             template.URL
	ServerOwner           string
	ServerEXP             string
	ServerHostName        string
}

func (this *AdminConsoleController) Get() {
	DB := database.Mysql()
	/* delete confirm */
	var (
		dib           []database.DeleteConfirm
		deleteServers []dServer
	)
	DB.Find(&dib)
	for _, d := range dib {
		var entity database.WareEntity
		if DB.Where("id = ?", d.WareID).First(&entity).RecordNotFound() || entity.DeleteStatus != 1 {
			DB.Delete(&d)
		} else {
			pteServer, err := pterodactyl.ClientFromConf().GetServer(entity.ServerExternalID, true)
			if err != nil {
				glgf.Error(err)
				continue
			}
			ds := dServer{
				ServerName:            entity.ServerExternalID,
				ServerConsoleHostName: template.URL(pterodactyl.ClientFromConf().HostName() + "/server/" + pteServer.Identifier),
				ServerIdentifier:      pteServer.Identifier,
				DeleteURL:             template.URL("/admin-console/delete-confirm/" + strconv.Itoa(int(entity.ID))),
				ServerOwner:           entity.UserExternalID,
				ServerEXP:             entity.ValidDate.Format("2006-01-02"),
				ServerHostName:        entity.HostName,
			}
			if ds.ServerIdentifier == "" {
				ds.ServerIdentifier = "无法获取编号"
			}
			deleteServers = append(deleteServers, ds)

		}
	}
	// glgf.Debug(deleteServers )
	this.Data["deleteServers"] = deleteServers
	/* panel stats*/
	var (
		specs        []database.WareSpec
		entities     []database.WareEntity
		users        []database.User
		keys         []database.WareKey
		rkeys        []database.RechargeKey
		orders       []database.Order
		WorkOrders   []database.WorkOrder
		galleryItems []database.GalleryItem
	)
	DB.Find(&specs)
	DB.Find(&entities)
	DB.Find(&users)
	DB.Find(&keys)
	DB.Where("confirmed = ?", true).Find(&orders)
	DB.Find(&rkeys)
	DB.Where("closed = ?", false).Find(&WorkOrders)
	DB.Find(&galleryItems)
	for i, j := 0, len(galleryItems)-1; i < j; i, j = i+1, j-1 {
		galleryItems[i], galleryItems[j] = galleryItems[j], galleryItems[i]
	}
	this.Data["WorkOrders"] = WorkOrders
	this.Data["specAmount"] = len(specs)
	this.Data["entityAmount"] = len(entities)
	this.Data["userAmount"] = len(users)
	this.Data["keyAmount"] = len(keys) + len(rkeys)
	this.Data["orderAmount"] = len(orders)
	this.Data["galleryItems"] = galleryItems
	type keySpec struct {
		ID            uint
		Name          string
		Description   string
		ValidDuration string
	}
	var keySpecs []keySpec
	for _, s := range specs {
		keySpecs = append(keySpecs, keySpec{
			ID:            s.ID,
			Name:          s.WareName,
			Description:   "Memory:" + strconv.Itoa(s.Memory),
			ValidDuration: durafmt.Parse(s.ValidDuration).LimitFirstN(1).String(),
		})
	}
	keySpecs = append(keySpecs, keySpec{
		ID:            ^uint(0),
		Name:          "全部商品",
		Description:   "包含全部的商品激活码",
		ValidDuration: "跟随商品",
	})
	for _, s := range []uint{30, 50, 100} {
		keySpecs = append(keySpecs, keySpec{
			ID:            ^uint(0) - s,
			Name:          "余额",
			Description:   strconv.Itoa(int(s)) + " CNY",
			ValidDuration: "余额无有效期",
		})
	}
	keySpecs = append(keySpecs, keySpec{
		ID:            ^uint(0) - 1,
		Name:          "全部余额",
		Description:   "包含全部余额的激活码",
		ValidDuration: "余额无有效期",
	})
	this.Data["keySpecs"] = keySpecs
}

func (this *AdminConsoleController) DeleteConfirm() {
	entityID := this.Ctx.Input.Param(":entityID")
	entityIDint, err := strconv.Atoi(entityID)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("FAILED"))
		return
	}
	err = pterodactyl.ConfirmDelete(uint(entityIDint))
	DB := database.Mysql()
	DB.Delete(&database.DeleteConfirm{}, "ware_id = ?", entityIDint)
	DB.Delete(&database.WareEntity{}, "id = ?", entityIDint)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法在面板中删除该服务器，请手动删除！"))
	} else {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
	}
}

func (this *AdminConsoleController) NewKey() {
	keyAmount, err := this.GetInt("key_amount", 1)
	if err != nil || keyAmount <= 0 || keyAmount >= 100 {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("输入不合理的 KEY 数量"))
		return
	}
	validDuration, err := this.GetInt("valid_duration", 60)
	if err != nil || validDuration <= 0 {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("输入不合理的有效期"))
		return
	}
	DB := database.Mysql()
	specID, err := this.GetUint64("spec_id")
	/* special method */
	if uint(specID) == ^uint(0) {
		/*add keys for all specs*/
		var specs []database.WareSpec
		DB.Find(&specs)
		for _, s := range specs {
			err = cryptoo.GeneKeys(keyAmount, s.ID, validDuration, 20)
			if err != nil {
				_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
				return
			}
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	if uint(specID) == ^uint(0)-30 {
		err = cryptoo.GeneRechargeKeys(keyAmount, 30, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	} else if uint(specID) == ^uint(0)-50 {
		err = cryptoo.GeneRechargeKeys(keyAmount, 50, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	} else if uint(specID) == ^uint(0)-100 {
		err = cryptoo.GeneRechargeKeys(keyAmount, 100, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	} else if uint(specID) == ^uint(0)-1 {
		err = cryptoo.GeneRechargeKeys(keyAmount, 30, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		err = cryptoo.GeneRechargeKeys(keyAmount, 50, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		err = cryptoo.GeneRechargeKeys(keyAmount, 100, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	/* end special method */
	if err != nil || DB.Where("id = ?", specID).First(&database.WareSpec{}).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("选择了无效的商品"))
		return
	}
	err = cryptoo.GeneKeys(keyAmount, uint(specID), validDuration, 20)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *AdminConsoleController) GetKeys() {
	DB := database.Mysql()
	var (
		specs  []database.WareSpec
		wg     sync.WaitGroup
		failed bool
	)
	DB.Find(&specs)
	err := os.MkdirAll("tmp/download/keys", os.ModePerm)
	if err != nil {
		glgf.Error(err)
	}
	for _, s := range specs {
		// glgf.Debug(s)
		wg.Add(1)
		go func(spec database.WareSpec) {
			defer wg.Done()
			txt, err := os.Create("tmp/download/keys/key_" + spec.WareName + "_" + durafmt.Parse(spec.ValidDuration).LimitFirstN(1).String() + ".txt")
			if err != nil {
				glgf.Error(err)
				failed = true
			}
			// glgf.Debug(spec,txt.Name())
			var keys []database.WareKey
			DB.Where("spec_id = ?", spec.ID).Find(&keys)
			for _, k := range keys {
				_, err = txt.Write([]byte(k.KeyString + "\n"))
				if err != nil {
					glgf.Error(err)
					failed = true
				}
			}
			_ = txt.Close()
		}(s)
	}
	for _, s := range []uint{30, 50, 100} {
		wg.Add(1)
		go func(balance uint) {
			defer wg.Done()
			txt, err := os.Create("tmp/download/keys/recharge_key_" + strconv.Itoa(int(balance)) + ".txt")
			if err != nil {
				glgf.Error(err)
				failed = true
			}
			var keys []database.RechargeKey
			DB.Where("balance = ?", balance).Find(&keys)
			for _, k := range keys {
				_, err = txt.Write([]byte(k.KeyString + "\n"))
				if err != nil {
					glgf.Error(err)
					failed = true
				}
			}
			_ = txt.Close()
		}(s)
	}
	wg.Wait()
	if failed {
		// _, _ = this.Ctx.ResponseWriter.Write([]byte("生成文件失败！"))
		return
	}
	arc := archiver.Zip{
		CompressionLevel:       flate.DefaultCompression,
		OverwriteExisting:      true,
		MkdirAll:               true,
		SelectiveCompression:   false,
		ImplicitTopLevelFolder: false,
		ContinueOnError:        false,
	}
	err = arc.Archive([]string{"tmp/download/keys"}, "tmp/download/keys.zip")
	if err != nil {
		glgf.Error(err)
		// _, _ = this.Ctx.ResponseWriter.Write([]byte("生成文件失败！"+err.Error()))
		return
	}
	this.Ctx.Output.Download("tmp/download/keys.zip", "keys_"+time.Now().Format("2006-01-02 15:04:05")+".zip")
	err = os.RemoveAll("tmp/download/")
	if err != nil {
		glgf.Error(err)
	}
	// _, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *AdminConsoleController) CloseWorkOrder() {
	orderID, err := this.GetInt("workOrderID")
	if err != nil || orderID < 0 {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("获取工单 ID 失败"))
		return
	}
	closeInfo := this.GetString("closeInfo")
	DB := database.Mysql()
	var order database.WorkOrder
	if err := DB.Where("id = ?", orderID).First(&order).Error; err != nil || order.Closed {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("获取工单失败或工单已经被解决"))
		return
	}
	/* valid post */
	if err := DB.Model(&order).Update("closed", true).Error; err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("更新工单状态失败"))
		return
	}
	go func() {
		message.Send("WorkOrderSystem", order.UserID, "您的工单 #"+strconv.Itoa(int(orderID))+" 已被解决")
		var user database.User
		if !DB.Where("id = ?", order.UserID).First(&user).RecordNotFound() {
			_ = email.SendAnyEmail(user.Email, "您的工单 #"+strconv.Itoa(orderID)+" 已被解决："+closeInfo)
		}
	}()
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *AdminConsoleController) GalleryPass() {
	itemID, err := this.GetInt("itemID")
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("获取图片 ID 失败"))
		return
	}
	var item database.GalleryItem
	DB := database.Mysql()
	if err = DB.Where("id = ?", itemID).First(&item).Error; err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库查找图片失败"))
		return
	}
	/* item found correctly*/
	if err = DB.Model(&item).Update("review_passed", true).Error; err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库更新图片状态失败"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *AdminConsoleController) GalleryDelete() {
	itemID, err := this.GetInt("itemID")
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("获取图片 ID 失败"))
		return
	}
	var item database.GalleryItem
	DB := database.Mysql()
	if err = DB.Where("id = ?", itemID).First(&item).Error; err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库查找图片失败"))
		return
	}
	/* item found correctly*/
	if err = DB.Delete(&item).Error; err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("数据库更新图片状态失败"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}
