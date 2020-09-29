package cron

import (
	"fmt"
	"github.com/MinoIC/glgf"
	"github.com/MinoIC/peo/configure"
	"github.com/MinoIC/peo/controllers"
	"github.com/MinoIC/peo/cryptoo"
	"github.com/MinoIC/peo/database"
	"github.com/MinoIC/peo/pterodactyl"
	"github.com/MinoIC/peo/status"
	"time"
)

func LoopTasksManager() {
	DB := database.GetDatabase()
	defer func() {
		if err := recover(); err != nil {
			glgf.Error("cron error caught:", fmt.Errorf("%v", err).Error())
			LoopTasksManager()
		}
	}()
	interval, err := configure.GetConf().Int("AutoTaskInterval")
	if err != nil {
		interval = 10
		glgf.Error("cant get AutoTaskInterval ,set it to 10sec as default")
	}
	ticker := time.NewTicker(time.Duration(interval) * time.Second)
	time2 := 5 * time.Minute
	ticker2 := time.NewTicker(time2)
	for {
		select {
		case <-ticker.C:
			pterodactyl.CheckServers()
			pterodactyl.CacheNeededEggs()
			pterodactyl.CacheNeededServers()
			controllers.RefreshWareInfo()
			controllers.RefreshServerInfo()
			glgf.Info("DB_OpenConnections: ", DB.DB().Stats().OpenConnections, " - ", DB.DB().Stats().WaitCount)
		case <-ticker2.C:
			func() {
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
			cryptoo.DeleteOutdatedKeys()
		}
	}
	// always go task
	/*	time2 := 5 * time.Minute
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
		}()*/
}
