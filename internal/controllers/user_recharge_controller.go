package controllers

import (
	"encoding/base64"
	"github.com/MinoIC/glgf"
	"github.com/MinoIC/peo/internal/configure"
	"github.com/MinoIC/peo/internal/cryptoo"
	"github.com/MinoIC/peo/internal/database"
	"github.com/MinoIC/peo/internal/session"
	"github.com/astaxie/beego"
	"github.com/jinzhu/gorm"
	"github.com/skip2/go-qrcode"
	"github.com/smartwalle/alipay/v3"
	_ "github.com/smartwalle/alipay/v3"
	"strconv"
	"time"
)

type UserRechargeController struct {
	beego.Controller
}

func (this *UserRechargeController) Prepare() {
	if !session.SessionIslogged(this.StartSession()) {
		this.Abort("401")
	}
	handleNavbar(&this.Controller)
	handleSidebar(&this.Controller)
	this.TplName = "UserRecharge.html"
	this.Data["i"] = 3
	this.Data["u"] = 3
}

func (this *UserRechargeController) Get() {
	user, _ := session.SessionGetUser(this.StartSession())
	DB := database.GetDatabase()
	var logs []database.RechargeLog
	DB.Where("user_id = ?", user.ID).Find(&logs)
	this.Data["rechargeLogs"] = logs
	/* reverse logs */
	for i, j := 0, len(logs)-1; i < j; i, j = i+1, j-1 {
		logs[i], logs[j] = logs[j], logs[i]
	}
	this.Data["balance"] = user.Balance
	this.Data["rechargeTimes"] = len(logs)
	if configure.AliClient == nil {
		this.Data["aliEnabled"] = false
	} else {
		this.Data["aliEnabled"] = true
	}
}

func (this *UserRechargeController) RechargeByKey() {
	if !this.CheckXSRFCookie() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("XSRF 验证失败"))
		return
	}
	user, err := session.SessionGetUser(this.StartSession())
	if err != nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("请重新登录"))
		return
	}
	// glgf.Debug(bm.Get("RECHARGE_DELAY"+user.Name))
	if bm.IsExist("RECHARGE_DELAY" + user.Name) {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("您 3 秒钟内只能充值一次"))
		return
	}
	err = bm.Put("RECHARGE_DELAY"+user.Name, 1, 3*time.Second)
	if err != nil {
		glgf.Error(err)
	}
	keyString := this.GetString("keyString")
	DB := database.GetDatabase()
	var key database.RechargeKey
	if DB.Where("key_string = ?", keyString).First(&key).RecordNotFound() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("无效的 KEY"))
		DB.Create(&database.RechargeLog{
			Model:   gorm.Model{},
			UserID:  user.ID,
			Code:    "FAILED_ByKEY_" + keyString + "_" + strconv.Itoa(int(user.Balance)),
			Method:  "激活码",
			Balance: 0,
			Time:    time.Now().Format("2006-01-02 15:04:05"),
			Status:  `<span class="label label-danger">无效的激活码</span>`,
		})
		return
	}
	/* valid post */
	if err = DB.Model(&user).Update("balance", user.Balance+key.Balance).Error; err != nil {
		DB.Create(&database.RechargeLog{
			Model:   gorm.Model{},
			UserID:  user.ID,
			Code:    "FAILED_ByKEY_" + keyString + "_" + strconv.Itoa(int(user.Balance)),
			Method:  "激活码",
			Balance: 0,
			Time:    time.Now().Format("2006-01-02_15:04:05"),
			Status:  `<span class="label label-warning">请重试</span>`,
		})
		DB.Create(&database.RechargeKey{
			Model:     gorm.Model{},
			KeyString: key.KeyString,
			Balance:   key.Balance,
			Exp:       key.Exp,
		})
		_, _ = this.Ctx.ResponseWriter.Write([]byte("增加余额失败！"))
		return
	}
	if err = DB.Delete(&key).Error; err != nil {
		DB.Create(&database.RechargeLog{
			Model:   gorm.Model{},
			UserID:  user.ID,
			Code:    "FAILED_ByKEY_" + keyString + "_" + strconv.Itoa(int(user.Balance)),
			Method:  "激活码",
			Balance: 0,
			Time:    time.Now().Format("2006-01-02_15:04:05"),
			Status:  `<span class="label label-warning">请重试</span>`,
		})
		DB.Model(&user).Update("balance", user.Balance-key.Balance)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("销毁激活码失败！"))
		return
	}
	DB.Create(&database.RechargeLog{
		Model:   gorm.Model{},
		UserID:  user.ID,
		Code:    "ByKEY_" + key.KeyString + "_" + strconv.Itoa(int(user.Balance-key.Balance)) + "_" + strconv.Itoa(int(user.Balance)),
		Method:  "激活码",
		Balance: key.Balance,
		Time:    time.Now().Format("2006-01-02_15:04:05"),
		Status:  `<span class="label label-success">已到账</span>`,
	})
	_, _ = this.Ctx.ResponseWriter.Write([]byte("SUCCESS"))
}

func (this *UserRechargeController) CreateZFB() {
	if !this.CheckXSRFCookie() {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("0"))
		return
	}
	if configure.AliClient == nil {
		_, _ = this.Ctx.ResponseWriter.Write([]byte("0"))
		return
	}
	user, err := session.SessionGetUser(this.StartSession())
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("0"))
		return
	}
	amount, err := this.GetInt("amount")
	if amount <= 0 || err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("0"))
	}
	tradeNo := cryptoo.RandNumKey(16)
	p := alipay.TradePreCreate{}
	p.NotifyURL = configure.WebHostName + "/alipay"
	p.Subject = "peo 充值"
	p.OutTradeNo = tradeNo
	p.TotalAmount = strconv.Itoa(amount)
	resp, err := configure.AliClient.TradePreCreate(p)
	glgf.Debug(resp)
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("0"))
		return
	}
	rlog := database.RechargeLog{
		UserID:     user.ID,
		Code:       "ByZFB_" + tradeNo + "_Waiting",
		Method:     "支付宝",
		Balance:    uint(amount),
		OutTradeNo: tradeNo,
		Time:       time.Now().Format("2006-01-02_15:04:05"),
		Status:     `<span class="label label-warning">未支付</span>`,
	}
	database.GetDatabase().Create(&rlog)
	img, err := qrcode.Encode(resp.Content.QRCode, qrcode.High, 256)
	if err != nil {
		glgf.Error(err)
		_, _ = this.Ctx.ResponseWriter.Write([]byte("0"))
		return
	}
	_, _ = this.Ctx.ResponseWriter.Write([]byte(base64.StdEncoding.EncodeToString(img)))
}

func (this *UserRechargeController) CheckXSRFCookie() bool {
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
