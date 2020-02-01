package PterodactylAPI

import (
	"NTPE/models"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/cache"
	"strconv"
	"time"
)

const checkInterval = 3 * time.Minute

var bm, _ = cache.NewCache("memory", `{"interval":60}`)

func ClearCache() {
	err := bm.ClearAll()
	if err != nil {
		beego.Error(err)
	}
}

func ConfGetParams() ParamsData {
	conf := models.GetConf()
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
			user, ok := PterodactylGetUser(data, ID, isExternal)
			err := bm.Put("USERE"+ID.(string), user, checkInterval)
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
			user, ok := PterodactylGetUser(data, ID, isExternal)
			err := bm.Put("USER"+strconv.Itoa(ID.(int)), user, checkInterval)
			if err != nil {
				panic(err)
			}
			return user, ok
		}
	}
}

func get(data ParamsData, key string, mode string, id []int) interface{} {
	if bm.IsExist(key) {
		return bm.Get(key)
	} else {
		var ret interface{}
		switch mode {
		case "NEST":
			ret = PterodactylGetNest(data, id[0])
		case "ALLNESTS":
			ret = PterodactylGetAllNests(data)
		case "EGG":
			ret = PterodactylGetEgg(data, id[0], id[1])
		case "ALLEGGS":
			ret = PterodactylGetAllEggs(data, id[0])
		case "NODE":
			ret = PterodactylGetNode(data, id[0])
		case "ALLOCATIONS":
			ret = PterodactylGetAllocations(data, id[0])
		case "ENV":
			ret = PterodactylGetEnv(data, id[0], id[1])
		}
		err := bm.Put(key, ret, checkInterval)
		if err != nil {
			panic(err)
		}
		return ret
	}
}

func GetAllEggs(data ParamsData) []PterodactylEgg {
	return get(data, "ALLEGGS", "ALLEGGS", []int{}).([]PterodactylEgg)
}

func GetNest(data ParamsData, nestID int) PterodactylNest {
	return get(data, "NEST"+strconv.Itoa(nestID), "NEST", []int{nestID}).(PterodactylNest)
}

func GetAllNests(data ParamsData) []PterodactylNest {
	return get(data, "ALLNESTS", "ALLNESTS", []int{}).([]PterodactylNest)
}

func GetEgg(data ParamsData, nestID int, eggID int) PterodactylEgg {
	return get(data, "EGG"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), "EGG", []int{nestID, eggID}).(PterodactylEgg)
}

func GetAllocations(data ParamsData, nodeID int) []PterodactylAllocation {
	return get(data, "ALLOCATIONS", "ALLOCATIONS", []int{nodeID}).([]PterodactylAllocation)
}

func GetNode(data ParamsData, nodeID int) PterodactylNode {
	return get(data, "NODE"+strconv.Itoa(nodeID), "NODE", []int{nodeID}).(PterodactylNode)
}

func GetEnv(data ParamsData, nestID int, eggID int) map[string]string {
	return get(data, "ENV"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), "ENV", []int{nestID, eggID}).(map[string]string)
}
