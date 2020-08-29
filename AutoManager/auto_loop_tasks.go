package AutoManager

import (
	"github.com/MinoIC/MinoIC-PE/Controllers"
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/MinoIC-PE/MinoKey"
	"github.com/MinoIC/MinoIC-PE/PterodactylAPI"
	"github.com/MinoIC/MinoIC-PE/ServerStatus"
	"github.com/astaxie/beego"
	"time"
)

func LoopTasksManager() {
	// random task
	go func() {
		interval, err := MinoConfigure.GetConf().Int("AutoTaskInterval")
		if err != nil {
			interval = 10
			beego.Error("cant get AutoTaskInterval ,set it to 10sec as default")
		}
		ticker := time.NewTicker(time.Duration(interval) * time.Second)
		for {
			select {
			case <-ticker.C:
				go func() {
					PterodactylAPI.CheckServers()
					PterodactylAPI.CacheNeededEggs()
					PterodactylAPI.CacheNeededServers()
				}()
				go Controllers.RefreshWareInfo()
				go Controllers.RefreshServerInfo()
				go MinoKey.DeleteOutdatedKeys()
				DB := MinoDatabase.GetDatabase()
				beego.Info("DB_OpenConnections: ", DB.DB().Stats().OpenConnections, " - ",
					DB.DB().Stats().WaitCount)

			}
		}
	}()
	// always go task
	time2 := 5 * time.Minute
	go func() {
		ticker := time.NewTicker(time2)
		for {
			select {
			case <-ticker.C:
				DB := MinoDatabase.GetDatabase()
				go func() {
					var (
						entities []MinoDatabase.WareEntity
						count    int
					)
					DB.Find(&entities)
					for _, e := range entities {
						pong, err := ServerStatus.Ping(e.HostName)
						if err == nil && pong.Version.Protocol != 0 {
							var user MinoDatabase.User
							DB.Model(&MinoDatabase.User{}).Where("id = ?", e.UserID).First(&user)
							DB.Model(&user).Update("total_up_time", user.TotalUpTime+time2)
							count++
						}
					}
					// beego.Info("Servers Online - ",count)
				}()
				// go func() {
				//	var rlogs []MinoDatabase.RechargeLog
				//	DB.Find(&rlogs, "method = ?", "支付宝")
				//	for i := range rlogs {
				//		if strings.Contains(rlogs[i].Code, "Waiting") {
				//			if rlogs[i].CreatedAt.Add(25*time.Hour).Before(time.Now()) {
				//				DB.Model(&rlogs[i]).Update(&MinoDatabase.RechargeLog{
				//					Code:   rlogs[i].Code[:23] + "OutOfTime",
				//					Status: `<span class="label">已超时</span>`,
				//				})
				//			}
				//			p:=alipay.TradeQuery{}
				//			p.OutTradeNo="1316548716"
				//			resp,err:=MinoConfigure.AliClient.TradeQuery(p)
				//			if err != nil {
				//				beego.Error(err)
				//			}
				//			if resp.IsSuccess(){
				//				var user MinoDatabase.User
				//				DB.First(&user,"id = ?",rlogs[i].UserID)
				//				if err=DB.Model(&user).Update("balance",user.Balance+rlogs[i].Balance).Error;err!=nil{
				//					beego.Error(err)
				//					continue
				//				}
				//
				//				DB.Model(&rlogs[i]).Update(&MinoDatabase.RechargeLog{
				//					Code:   rlogs[i].Code[:23] + fmt.Sprintf("%d_%d_Finished",user.Balance-rlogs[i].Balance,user.Balance),
				//					Status:  `<span class="label label-success">已到账</span>`,
				//				})
				//				beego.Info("user",user.Name,user.Email,"has recharged ",rlogs[i].Balance)
				//				MinoMessage.SendAdmin("user",user.Name,user.Email,"has recharged ",rlogs[i].Balance)
				//			}
				//		}
				//	}
				//}()
			}
		}
	}()
}
