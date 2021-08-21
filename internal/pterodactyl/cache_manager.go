package pterodactyl

import (
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/cache"
	"github.com/minoic/peo/internal/configure"
	"strconv"
	"time"
)

/* set interval to refresh cache */
const timeout = 3 * time.Minute

var bm = cache.GetCache()

func ClearCache() {
	/* force refresh cache */
	err := bm.ClearAll()
	if err != nil {
		glgf.Error(err)
	}
}

var confInstance *Client

func ClientFromConf() *Client {
	if confInstance != nil {
		return confInstance
	}
	conf := configure.GetConf()
	sec, err := conf.Bool("Serversecure")
	if err != nil {
		panic(err)
	}
	Serverhostname := conf.String("Serverhostname")
	var hostname string
	if sec {
		hostname = "https://" + Serverhostname
	} else {
		hostname = "http://" + Serverhostname
	}
	ret := NewClient(hostname, conf.String("Serverpassword"))
	confInstance = ret
	return ret
}

func (this *Client) GetUser(ID interface{}, isExternal bool) (*User, error) {
	if isExternal {
		if bm.IsExist("USERE" + ID.(string)) {
			return bm.Get("USERE" + ID.(string)).(*User), nil
		} else {
			user, err := this.getUser(ID, isExternal)
			if err != nil {
				return nil, err
			}
			return user, bm.Put("USERE"+ID.(string), user, timeout)
		}
	} else {
		if bm.IsExist("USER" + strconv.Itoa(ID.(int))) {
			return bm.Get("USER" + strconv.Itoa(ID.(int))).(*User), nil
		} else {
			user, err := this.getUser(ID, isExternal)
			if err != nil {
				return nil, err
			}
			return user, bm.Put("USER"+strconv.Itoa(ID.(int)), user, timeout)
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

var pool = make(chan struct{}, 3)

func (this *Client) get(key string, mode int, id []int, ExternalID string) (interface{}, error) {
	pool <- struct{}{}
	if bm.IsExist(key) {
		<-pool
		return bm.Get(key), nil
	} else {
		var ret interface{}
		var err error
		switch mode {
		case nest:
			ret, err = this.getNest(id[0])
		case allNests:
			ret, err = this.getAllNests()
		case egg:
			ret, err = this.getEgg(id[0], id[1])
		case allEggs:
			ret, err = this.getAllEggs(id[0])
		case node:
			ret, err = this.getNode(id[0])
		case allocations:
			ret, err = this.getAllocations(id[0])
		case env:
			ret, err = this.getEnv(id[0], id[1])
		case server:
			ret, err = this.getServer(ExternalID, true)
		}
		<-pool
		if err != nil {
			glgf.Error(err)
		} else if ret != nil {
			_ = bm.Put(key, ret, timeout)
		}
		return ret, err
	}
}

func (this *Client) GetServer(ExternalID string) (*Server, error) {
	ret, err := this.get("SERVER"+ExternalID, server, []int{}, ExternalID)
	return ret.(*Server), err
}

func (this *Client) GetAllEggs() ([]Egg, error) {
	ret, err := this.get("ALLEGGS", allEggs, []int{}, "")
	return ret.([]Egg), err
}

func (this *Client) GetNest(nestID int) (*Nest, error) {
	ret, err := this.get("nest"+strconv.Itoa(nestID), nest, []int{nestID}, "")
	return ret.(*Nest), err
}

func (this *Client) GetAllNests() ([]Nest, error) {
	ret, err := this.get("allNests", allNests, []int{}, "")
	return ret.([]Nest), err
}

func (this *Client) GetEgg(nestID int, eggID int) (*Egg, error) {
	ret, err := this.get("EGG"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), egg, []int{nestID, eggID}, "")
	return ret.(*Egg), err
}

func (this *Client) GetAllocations(nodeID int) ([]Allocation, error) {
	ret, err := this.get("ALLOCATIONS", allocations, []int{nodeID}, "")
	return ret.([]Allocation), err
}

func (this *Client) GetNode(nodeID int) (*Node, error) {
	ret, err := this.get("NODE"+strconv.Itoa(nodeID), node, []int{nodeID}, "")
	return ret.(*Node), err
}

func (this *Client) GetEnv(nestID int, eggID int) (map[string]string, error) {
	ret, err := this.get("ENV"+strconv.Itoa(nestID)+"#"+strconv.Itoa(eggID), env, []int{nestID, eggID}, "")
	return ret.(map[string]string), err
}
