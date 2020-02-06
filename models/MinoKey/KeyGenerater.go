package MinoKey

import (
	"math/rand"
	"time"
)

func RandKey(keyLength int) string {
	str := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	b := []byte(str)
	var ret []byte
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 1; i <= keyLength; i++ {
		ret = append(ret, b[r.Intn(len(str))])
	}
	return string(ret)
}

func RandNumKey(keyLength int) string {
	str := "1234567890"
	b := []byte(str)
	var ret []byte
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 1; i <= keyLength; i++ {
		ret = append(ret, b[r.Intn(len(str))])
	}
	return string(ret)
}
