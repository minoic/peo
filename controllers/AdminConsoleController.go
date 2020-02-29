package controllers

import (
	"compress/flate"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoConfigure"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoDatabase"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoKey"
	"git.ntmc.tech/root/MinoIC-PE/models/MinoSession"
	"git.ntmc.tech/root/MinoIC-PE/models/PterodactylAPI"
	"github.com/astaxie/beego"
	"github.com/hako/durafmt"
	"github.com/mholt/archiver"
	"html/template"
	"os"
	"strconv"
	"sync"
	"time"
)

type AdminConsoleController struct {
	beego.Controller
}

func (this *AdminConsoleController) Prepare() {
	this.TplName = "AdminConsole.html"
	this.Data["u"] = 4
	handleNavbar(&this.Controller)
	sess := this.StartSession()
	if !MinoSession.SessionIslogged(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName + "/login",
			Detail: "正在跳转到登录",
			Title:  "您还没有登录",
		}, &this.Controller)
	} else if !MinoSession.SessionIsAdmin(sess) {
		DelayRedirect(DelayInfo{
			URL:    MinoConfigure.WebHostName,
			Detail: "正在跳转到主页",
			Title:  "您不是管理员",
		}, &this.Controller)
	}
}

func (this *AdminConsoleController) Get() {
	DB := MinoDatabase.GetDatabase()
	/* delete confirm */
	var (
		dib           []MinoDatabase.DeleteConfirm
		deleteServers []struct {
			ServerName            string
			ServerConsoleHostName template.URL
			ServerIdentifier      string
			DeleteURL             template.URL
			ServerOwner           string
			ServerEXP             string
			ServerHostName        string
		}
	)
	DB.Find(&dib)
	for i, d := range dib {
		var entity MinoDatabase.WareEntity
		if DB.Where("id = ?", d.WareID).First(&entity).RecordNotFound() {
			DB.Delete(&d)
		} else {
			pteServer := PterodactylAPI.GetServer(PterodactylAPI.ConfGetParams(), entity.ServerExternalID)
			deleteServers = append(deleteServers, struct {
				ServerName            string
				ServerConsoleHostName template.URL
				ServerIdentifier      string
				DeleteURL             template.URL
				ServerOwner           string
				ServerEXP             string
				ServerHostName        string
			}{
				ServerName:            pteServer.Name,
				ServerConsoleHostName: template.URL(PterodactylAPI.PterodactylGethostname(PterodactylAPI.ConfGetParams()) + "/server/" + pteServer.Identifier),
				ServerIdentifier:      pteServer.Identifier,
				DeleteURL:             template.URL(MinoConfigure.WebHostName + "/admin-console/delete-confirm/" + strconv.Itoa(int(entity.ID))),
				ServerOwner:           entity.UserExternalID,
				ServerEXP:             entity.ValidDate.Format("2006-01-02"),
				ServerHostName:        entity.HostName,
			})
			if deleteServers[i].ServerName == "" {
				deleteServers[i].ServerName = "无法获取服务器名称"
			}
			if deleteServers[i].ServerIdentifier == "" {
				deleteServers[i].ServerIdentifier = "无法获取编号"
			}
		}
	}
	//beego.Debug(deleteServers )
	this.Data["deleteServers"] = deleteServers
	/* panel stats*/
	var (
		specs    []MinoDatabase.WareSpec
		entities []MinoDatabase.WareEntity
		users    []MinoDatabase.User
		packs    []MinoDatabase.Pack
		keys     []MinoDatabase.WareKey
		rkeys    []MinoDatabase.RechargeKey
		orders   []MinoDatabase.Order
		wg       sync.WaitGroup
	)
	wg.Add(7)
	go func() {
		DB.Find(&specs)
		wg.Done()
	}()
	go func() {
		DB.Find(&entities)
		wg.Done()
	}()
	go func() {
		DB.Find(&users)
		wg.Done()
	}()
	go func() {
		DB.Find(&packs)
		wg.Done()
	}()
	go func() {
		DB.Find(&keys)
		wg.Done()
	}()
	go func() {
		DB.Where("confirmed = ?", true).Find(&orders)
		wg.Done()
	}()
	go func() {
		DB.Find(&rkeys)
		wg.Done()
	}()
	wg.Wait()
	this.Data["specAmount"] = len(specs)
	this.Data["entityAmount"] = len(entities)
	this.Data["userAmount"] = len(users)
	this.Data["packAmount"] = len(packs)
	this.Data["keyAmount"] = len(keys) + len(rkeys)
	this.Data["orderAmount"] = len(orders)
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
	err = PterodactylAPI.ConfirmDelete(uint(entityIDint))
	DB := MinoDatabase.GetDatabase()
	DB.Delete(&MinoDatabase.DeleteConfirm{}, "ware_id = ?", entityIDint)
	DB.Delete(&MinoDatabase.WareEntity{}, "id = ?", entityIDint)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无法在面板中删除该服务器，请手动删除！"))
	} else {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
	}
}

func (this *AdminConsoleController) NewKey() {
	if !this.CheckXSRFCookie() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("XSRF 验证失败"))
		return
	}
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
	DB := MinoDatabase.GetDatabase()
	specID, err := this.GetUint64("spec_id")
	/* special method */
	if uint(specID) == ^uint(0) {
		/*add keys for all specs*/
		var specs []MinoDatabase.WareSpec
		DB.Find(&specs)
		for _, s := range specs {
			err = MinoKey.GeneKeys(keyAmount, s.ID, validDuration, 20)
			if err != nil {
				_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
				return
			}
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	if uint(specID) == ^uint(0)-30 {
		err = MinoKey.GeneRechargeKeys(keyAmount, 30, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	} else if uint(specID) == ^uint(0)-50 {
		err = MinoKey.GeneRechargeKeys(keyAmount, 50, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	} else if uint(specID) == ^uint(0)-100 {
		err = MinoKey.GeneRechargeKeys(keyAmount, 100, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	} else if uint(specID) == ^uint(0)-1 {
		err = MinoKey.GeneRechargeKeys(keyAmount, 30, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		err = MinoKey.GeneRechargeKeys(keyAmount, 50, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		err = MinoKey.GeneRechargeKeys(keyAmount, 100, validDuration, 20)
		if err != nil {
			_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
			return
		}
		_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
		return
	}
	/* end special method */
	if err != nil || DB.Where("id = ?", specID).First(&MinoDatabase.WareSpec{}).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("选择了无效的商品"))
		return
	}
	err = MinoKey.GeneKeys(keyAmount, uint(specID), validDuration, 20)
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("在数据库中创建 KeyString 失败"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *AdminConsoleController) GetKeys() {
	DB := MinoDatabase.GetDatabase()
	var (
		specs  []MinoDatabase.WareSpec
		wg     sync.WaitGroup
		failed bool
	)
	DB.Find(&specs)
	err := os.MkdirAll("tmp/download/keys", os.ModePerm)
	if err != nil {
		beego.Error(err)
	}
	for _, s := range specs {
		//beego.Debug(s)
		wg.Add(1)
		go func(spec MinoDatabase.WareSpec) {
			defer wg.Done()
			txt, err := os.Create("tmp/download/keys/key_" + spec.WareName + "_" + durafmt.Parse(spec.ValidDuration).LimitFirstN(1).String() + ".txt")
			if err != nil {
				beego.Error(err)
				failed = true
			}
			//beego.Debug(spec,txt.Name())
			var keys []MinoDatabase.WareKey
			DB.Where("spec_id = ?", spec.ID).Find(&keys)
			for _, k := range keys {
				_, err = txt.Write([]byte(k.KeyString + "\n"))
				if err != nil {
					beego.Error(err)
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
				beego.Error(err)
				failed = true
			}
			var keys []MinoDatabase.RechargeKey
			DB.Where("balance = ?", balance).Find(&keys)
			for _, k := range keys {
				_, err = txt.Write([]byte(k.KeyString + "\n"))
				if err != nil {
					beego.Error(err)
					failed = true
				}
			}
			_ = txt.Close()
		}(s)
	}
	wg.Wait()
	if failed {
		//_, _ = this.Ctx.ResponseWriter.Write([]byte("生成文件失败！"))
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
		beego.Error(err)
		//_, _ = this.Ctx.ResponseWriter.Write([]byte("生成文件失败！"+err.Error()))
		return
	}
	this.Ctx.Output.Download("tmp/download/keys.zip", "keys_"+time.Now().Format("2006-01-02 15:04:05")+".zip")
	err = os.RemoveAll("tmp/download/")
	if err != nil {
		beego.Error(err)
	}
	//_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *AdminConsoleController) CheckXSRFCookie() bool {
	if !this.EnableXSRF {
		return true
	}
	token := this.Ctx.Input.Query("_xsrf")
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Xsrftoken")
	}
	if token == "" {
		token = this.Ctx.Request.Header.Get("X-Csrftoken")
	}
	if token == "" {
		return false
	}
	if this.XSRFToken() != token {
		return false
	}
	return true
}
