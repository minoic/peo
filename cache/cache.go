package cache

import (
	"github.com/MinoIC/peo/configure"
	"github.com/astaxie/beego/cache"
	_ "github.com/astaxie/beego/cache/memcache"
	_ "github.com/astaxie/beego/cache/redis"
	_ "github.com/astaxie/beego/cache/ssdb"
	"strconv"
)

var bm cache.Cache

func init() {
	conf := configure.GetConf()
	switch conf.String("CacheMode") {
	case "memory":
		interval, err := conf.Int("CacheMemoryGCInterval")
		if err != nil {
			panic(err)
		}
		bm, err = cache.NewCache("memory", `{"interval":`+strconv.Itoa(interval)+"}")
		if err != nil {
			panic(err)
		}
	case "file":
		var err error
		bm, err = cache.NewCache("file", `{"CachePath":"`+conf.String("CacheFilePath")+`","FileSuffix":"`+conf.String("CacheFileSuffix")+`","DirectoryLevel":"`+conf.String("CacheFileDirectoryLevel")+`","EmbedExpiry":"`+conf.String("CacheFileEmbedExpiry")+`"}`)
		if err != nil {
			panic(err)
		}
	case "redis":
		var err error
		bm, err = cache.NewCache("redis", `{"key":"`+conf.String("CacheRedisKey")+`","conn":"`+conf.String("CacheRedisCONN")+`","dbNum":"`+conf.String("CacheRedisdbNum")+`","password":"`+conf.String("CacheRedisPassword")+`"}`)
		if err != nil {
			panic(err)
		}
	case "memcache":
		var err error
		bm, err = cache.NewCache("memcache", `{"conn":"`+conf.String("CacheMemcacheCONN")+`"}`)
		if err != nil {
			panic(err)
		}
	}
}

func GetCache() cache.Cache {
	return bm
}
