package PterodactylAPI

import (
	"github.com/MinoIC/MinoIC-PE/MinoCache"
	"github.com/MinoIC/MinoIC-PE/MinoConfigure"
	"github.com/MinoIC/glgf"
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
		glgf.Error(err)
	}
}

func ConfGetParams() ParamsData {
	conf := MinoConfigure.GetConf()
	sec, err := conf.Bool("Serversecure")
	if err != nil {
		glgf.Error(err.Error())
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

const (
	nest int = iota
	allNests
	egg
	allEggs
	node
	allocations
	env
	server
)

var pool = make(chan struct{}, 2)

func get(data ParamsData, key string, mode int, id []int, ExternalID string) interface{} {
	pool <- struct{}{}
	if bm.IsExist(key) {
		<-pool
		return bm.Get(key)
	} else {
		var ret interface{}
		switch mode {
		case nest:
			ret = pterodactylGetNest(data, id[0])
		case allNests:
			ret = pterodactylGetAllNests(data)
		case egg:
			ret = pterodactylGetEgg(data, id[0], id[1])
		case allEggs:
			ret = pterodactylGetAllEggs(data, id[0])
		case node:
			ret = pterodactylGetNode(data, id[0])
		case allocations:
			ret = pterodactylGetAllocations(data, id[0])
		case env:
			ret = pterodactylGetEnv(data, id[0], id[1])
		case server:
			ret = pterodactylGetServer(data, ExternalID, true)
		}
		err := bm.Put(key, ret, timeout)
		if err != nil {
			glgf.Error(err)
		}
		<-pool
		return ret
	}
}

func GetServer(data ParamsData, ExternalID string) PterodactylServer {
	return get(data, "SERVER"+ExternalID, server, []int{}, ExternalID).(PterodactylServer)
}

func GetAllEggs(data ParamsData) []PterodactylEgg {
	return get(data, "ALLEGGS", allEggs, []int{}, "").([]PterodactylEgg)
}

func GetNest(data ParamsData, nestID int) PterodactylNest {
	return get(data, "nest"+strconv.Itoa(nestID), nest, []int{nestID}, "").(PterodactylNest)
}

func GetAllNests(data ParamsData) []PterodactylNest {
	return get(data, "allNests", allNests, []int{}, "").([]PterodactylNest)
}

func GetEgg(data ParamsData, nestID int, eggID int) PterodactylEgg {
	return get(data, "EGG"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), egg, []int{nestID, eggID}, "").(PterodactylEgg)
}

func GetAllocations(data ParamsData, nodeID int) []PterodactylAllocation {
	return get(data, "ALLOCATIONS", allocations, []int{nodeID}, "").([]PterodactylAllocation)
}

func GetNode(data ParamsData, nodeID int) PterodactylNode {
	return get(data, "NODE"+strconv.Itoa(nodeID), node, []int{nodeID}, "").(PterodactylNode)
}

func GetEnv(data ParamsData, nestID int, eggID int) map[string]string {
	return get(data, "ENV"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), env, []int{nestID, eggID}, "").(map[string]string)
}
