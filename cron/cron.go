package cron

import (
	"github.com/MinoIC/MinoIC-PE/configure"
	"github.com/MinoIC/MinoIC-PE/controllers"
	"github.com/MinoIC/MinoIC-PE/cryptoo"
	"github.com/MinoIC/MinoIC-PE/database"
	"github.com/MinoIC/MinoIC-PE/pterodactyl"
	"github.com/MinoIC/MinoIC-PE/status"
	"github.com/MinoIC/glgf"
	"time"
)

func LoopTasksManager() {
	// random task
	go func() {
		interval, err := configure.GetConf().Int("AutoTaskInterval")
		if err != nil {
			interval = 10
			glgf.Error("cant get AutoTaskInterval ,set it to 10sec as default")
		}
		ticker := time.NewTicker(time.Duration(interval) * time.Second)
		for {
			select {
			case <-ticker.C:
				go func() {
					pterodactyl.CheckServers()
					pterodactyl.CacheNeededEggs()
					pterodactyl.CacheNeededServers()
				}()
				go controllers.RefreshWareInfo()
				go controllers.RefreshServerInfo()
				go cryptoo.DeleteOutdatedKeys()
				DB := database.GetDatabase()
				glgf.Info("DB_OpenConnections: ", DB.DB().Stats().OpenConnections, " - ",
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
				DB := database.GetDatabase()
				go func() {
					var (
						entities []database.WareEntity
						count    int
					)
					DB.Find(&entities)
					for _, e := range entities {
						pong, err := status.Ping(e.HostName)
						if err == nil && pong.Version.Protocol != 0 {
							var user database.User
							DB.Model(&database.User{}).Where("id = ?", e.UserID).First(&user)
							DB.Model(&user).Update("total_up_time", user.TotalUpTime+time2)
							count++
						}
					}
					// glgf.Info("Servers Online - ",count)
				}()
				// go func() {
				//	var rlogs []database.RechargeLog
				//	DB.Find(&rlogs, "method = ?", "支付宝")
				//	for i := range rlogs {
				//		if strings.Contains(rlogs[i].Code, "Waiting") {
				//			if rlogs[i].CreatedAt.Add(25*time.Hour).Before(time.Now()) {
				//				DB.Model(&rlogs[i]).Update(&database.RechargeLog{
				//					Code:   rlogs[i].Code[:23] + "OutOfTime",
				//					Status: `<span class="label">已超时</span>`,
				//				})
				//			}
				//			p:=alipay.TradeQuery{}
				//			p.OutTradeNo="1316548716"
				//			resp,err:=configure.AliClient.TradeQuery(p)
				//			if err != nil {
				//				glgf.Error(err)
				//			}
				//			if resp.IsSuccess(){
				//				var user database.User
				//				DB.First(&user,"id = ?",rlogs[i].UserID)
				//				if err=DB.Model(&user).Update("balance",user.Balance+rlogs[i].Balance).Error;err!=nil{
				//					glgf.Error(err)
				//					continue
				//				}
				//
				//				DB.Model(&rlogs[i]).Update(&database.RechargeLog{
				//					Code:   rlogs[i].Code[:23] + fmt.Sprintf("%d_%d_Finished",user.Balance-rlogs[i].Balance,user.Balance),
				//					Status:  `<span class="label label-success">已到账</span>`,
				//				})
				//				glgf.Info("user",user.Name,user.Email,"has recharged ",rlogs[i].Balance)
				//				message.SendAdmin("user",user.Name,user.Email,"has recharged ",rlogs[i].Balance)
				//			}
				//		}
				//	}
				//}()
			}
		}
	}()
}
