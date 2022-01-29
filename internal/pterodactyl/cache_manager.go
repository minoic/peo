package pterodactyl

import (
	"github.com/minoic/glgf"
	"github.com/minoic/peo/internal/configure"
	"strconv"
	"sync"
	"time"
)

/* set interval to refresh cache */
const timeout = 3 * time.Minute

var bm sync.Map

func ClearCache() {
	/* force refresh cache */
	bm = sync.Map{}
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
		if v, ok := bm.Load("USERE" + ID.(string)); ok {
			return v.(*User), nil
		} else {
			user, err := this.getUser(ID, isExternal)
			if err != nil {
				return nil, err
			}
			bm.Store("USERE"+ID.(string), user)
			return user, nil
		}
	} else {
		if v, ok := bm.Load("USER" + strconv.Itoa(ID.(int))); ok {
			return v.(*User), nil
		} else {
			user, err := this.getUser(ID, isExternal)
			if err != nil {
				return nil, err
			}
			bm.Store("USER"+strconv.Itoa(ID.(int)), user)
			return user, nil
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
	defer func() {
		<-pool
	}()
	if v, ok := bm.Load(key); ok {
		return v, nil
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
		if err != nil {
			glgf.Error(err)
		} else if ret != nil {
			bm.Store(key, ret)
		}
		return ret, err
	}
}

func (this *Client) GetServer(ExternalID string) (*Server, error) {
	ret, err := this.get("SERVER"+ExternalID, server, []int{}, ExternalID)
	return ret.(*Server), err
}

func (this *Client) GetAllEggs(nestID int) ([]Egg, error) {
	ret, err := this.get("ALLEGGS", allEggs, []int{nestID}, "")
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
