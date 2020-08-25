package AutoManager

import (
	"github.com/MinoIC/MinoIC-PE/Controllers"
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/MinoIC-PE/MinoDatabase"
	"github.com/MinoIC/MinoIC-PE/MinoKey"
	"github.com/MinoIC/MinoIC-PE/PterodactylAPI"
	"github.com/MinoIC/MinoIC-PE/ServerStatus"
	"github.com/astaxie/beego"
	"strings"
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
				go PterodactylAPI.CheckServers()
			case <-ticker.C:
				go PterodactylAPI.CacheNeededEggs()
			case <-ticker.C:
				go PterodactylAPI.CacheNeededServers()
			case <-ticker.C:
				go Controllers.RefreshWareInfo()
			case <-ticker.C:
				go MinoKey.DeleteOutdatedKeys()
			case <-ticker.C:
				go func() {
					DB := MinoDatabase.GetDatabase()
					beego.Info("DB_OpenConnections: ", DB.DB().Stats().OpenConnections, " - ",
						DB.DB().Stats().WaitCount)
				}()
			}
		}
	}()
	// always go task
	go func() {
		ticker := time.NewTicker(10 * time.Minute)
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
							DB.Model(&user).Update("total_up_time", user.TotalUpTime+5*time.Minute)
							count++
						}
					}
					// beego.Info("Servers Online - ",count)
				}()
				go func() {
					var rlogs []MinoDatabase.RechargeLog
					DB.Find(&rlogs, "method = ?", "支付宝")
					for i := range rlogs {
						if strings.Contains(rlogs[i].Code, "Waiting") && rlogs[i].CreatedAt.Add(10*time.Minute).Before(time.Now()) {
							DB.Model(&rlogs[i]).Update(&MinoDatabase.RechargeLog{
								Code:   rlogs[i].Code[:23] + "OutOfTime",
								Status: `<span class="label">已超时</span>`,
							})
						}
					}
				}()
			}
		}
	}()
}
