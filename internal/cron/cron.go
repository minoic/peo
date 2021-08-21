package cron

import (
	"fmt"
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"github.com/minoic/peo/internal/controllers"
	"github.com/minoic/peo/internal/cryptoo"
	"github.com/minoic/peo/internal/database"
	"github.com/minoic/peo/internal/pterodactyl"
	"github.com/minoic/peo/internal/status"
	"time"
)

func LoopTasksManager() {
	defer func() {
		if err := recover(); err != nil {
			glgf.Error("cron error caught:", fmt.Errorf("%v", err).Error())
			LoopTasksManager()
		}
	}()
	controllers.RefreshWareInfo()
	DB := database.GetDatabase()
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
			// todo: 更新任务调用方式防止单任务阻塞全局任务
			controllers.RefreshWareInfo()
			controllers.RefreshServerInfo()
			pterodactyl.CheckServers()
			pterodactyl.CacheNeededEggs()
			pterodactyl.CacheNeededServers()
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
