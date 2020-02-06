package MinoCache

import "github.com/astaxie/beego/cache"

var bm cache.Cache

func init() {
	var err error
	bm, err = cache.NewCache("memory", `{"interval":60}`)
	if err != nil {
		panic(err)
	}
}

func GetCache() cache.Cache {
	return bm
}
