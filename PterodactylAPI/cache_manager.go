package PterodactylAPI

import (
	"git.ntmc.tech/root/MinoIC-PE/MinoCache"
	"git.ntmc.tech/root/MinoIC-PE/MinoConfigure"
	"github.com/astaxie/beego"
	"strconv"
	"time"
)

/* set interval to refresh cache */
const timeout = 3 * time.Minute

var bm = MinoCache.GetCache()

func ClearCache() {
	/* force refresh cache */
	err := bm.ClearAll()
	if err != nil {
		beego.Error(err)
	}
}

func ConfGetParams() ParamsData {
	conf := MinoConfigure.GetConf()
	sec, err := conf.Bool("Serversecure")
	if err != nil {
		beego.Error(err.Error())
	}
	data := ParamsData{
		Serverhostname: conf.String("Serverhostname"),
		Serversecure:   sec,
		Serverpassword: conf.String("Serverpassword"),
	}
	return data
}

func GetUser(data ParamsData, ID interface{}, isExternal bool) (PterodactylUser, bool) {
	if isExternal {
		if bm.IsExist("USERE" + ID.(string)) {
			user := bm.Get("USERE" + ID.(string))
			ok := true
			if user == (PterodactylUser{}) {
				ok = false
			}
			return user.(PterodactylUser), ok
		} else {
			user, ok := pterodactylGetUser(data, ID, isExternal)
			err := bm.Put("USERE"+ID.(string), user, timeout)
			if err != nil {
				panic(err)
			}
			return user, ok
		}
	} else {
		if bm.IsExist("USER" + strconv.Itoa(ID.(int))) {
			user := bm.Get("USER" + strconv.Itoa(ID.(int)))
			ok := true
			if user == (PterodactylUser{}) {
				ok = false
			}
			return user.(PterodactylUser), ok
		} else {
			user, ok := pterodactylGetUser(data, ID, isExternal)
			err := bm.Put("USER"+strconv.Itoa(ID.(int)), user, timeout)
			if err != nil {
				panic(err)
			}
			return user, ok
		}
	}
}

func get(data ParamsData, key string, mode string, id []int, ExternalID string) interface{} {
	if bm.IsExist(key) {
		return bm.Get(key)
	} else {
		var ret interface{}
		switch mode {
		case "NEST":
			ret = pterodactylGetNest(data, id[0])
		case "ALLNESTS":
			ret = pterodactylGetAllNests(data)
		case "EGG":
			ret = pterodactylGetEgg(data, id[0], id[1])
		case "ALLEGGS":
			ret = pterodactylGetAllEggs(data, id[0])
		case "NODE":
			ret = pterodactylGetNode(data, id[0])
		case "ALLOCATIONS":
			ret = pterodactylGetAllocations(data, id[0])
		case "ENV":
			ret = pterodactylGetEnv(data, id[0], id[1])
		case "SERVER":
			ret = pterodactylGetServer(data, ExternalID, true)

		}
		err := bm.Put(key, ret, timeout)
		if err != nil {
			panic(err)
		}
		return ret
	}
}

func GetServer(data ParamsData, ExternalID string) PterodactylServer {
	return get(data, "SERVER"+ExternalID, "SERVER", []int{}, ExternalID).(PterodactylServer)
}

func GetAllEggs(data ParamsData) []PterodactylEgg {
	return get(data, "ALLEGGS", "ALLEGGS", []int{}, "").([]PterodactylEgg)
}

func GetNest(data ParamsData, nestID int) PterodactylNest {
	return get(data, "NEST"+strconv.Itoa(nestID), "NEST", []int{nestID}, "").(PterodactylNest)
}

func GetAllNests(data ParamsData) []PterodactylNest {
	return get(data, "ALLNESTS", "ALLNESTS", []int{}, "").([]PterodactylNest)
}

func GetEgg(data ParamsData, nestID int, eggID int) PterodactylEgg {
	return get(data, "EGG"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), "EGG", []int{nestID, eggID}, "").(PterodactylEgg)
}

func GetAllocations(data ParamsData, nodeID int) []PterodactylAllocation {
	return get(data, "ALLOCATIONS", "ALLOCATIONS", []int{nodeID}, "").([]PterodactylAllocation)
}

func GetNode(data ParamsData, nodeID int) PterodactylNode {
	return get(data, "NODE"+strconv.Itoa(nodeID), "NODE", []int{nodeID}, "").(PterodactylNode)
}

func GetEnv(data ParamsData, nestID int, eggID int) map[string]string {
	return get(data, "ENV"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), "ENV", []int{nestID, eggID}, "").(map[string]string)
}
