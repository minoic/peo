package models

import (
	"bytes"
	"encoding/json"
	"github.com/astaxie/beego"
	"io/ioutil"
	"net/http"
)

type ParamsData struct {
	Serverhostname string
	Serversecure   bool
	Serverpassword string
}

func pterodactylGethostname(params ParamsData) string {
	var hostname string
	if params.Serversecure {
		hostname = "https://" + params.Serverhostname
	} else {
		hostname = "http://" + params.Serverhostname
	}
	//todo: rtrim($hostname, '/')
	return hostname
}
func pterodactylApi(params ParamsData, data string, endPoint string, method string) map[string]interface{} {
	url := pterodactylGethostname(params) + "/api/application/" + endPoint
	beego.Info("URL:" + url)
	var res map[string]interface{}
	if method == "POST" || method == "PATCH" {
		ujson, err := json.Marshal(data)
		if err != nil {
			panic("cant marshal data:" + err.Error())
		}
		ubody := bytes.NewReader(ujson)
		req, err := http.NewRequest("POST", url, ubody)
		if err != nil {
			panic("cant New a Request:" + err.Error())
		}
		req.Header.Set("Authorization", "Bearer "+params.Serverpassword)
		req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
		req.ContentLength = int64(len(ujson))
		req.Header.Set("Content-Type", "application/json")

		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			panic("cant Do req:" + err.Error())
		}
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		if err := json.Unmarshal(body, &res); err != nil {
			panic("cant unmarshal body to res:" + err.Error())
		}
		beego.Info("status:" + resp.Status)

	} else {
		req, err := http.NewRequest(method, url, nil)
		if err != nil {
			panic("cant New a Request:" + err.Error())
		}
		req.Header.Set("Authorization", "Bearer "+params.Serverpassword)
		req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
		//beego.Info(req.Header.Get("Authorization"))
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			panic("cant Do req:" + err.Error())
		}
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)

		if err = json.Unmarshal(body, &res); err != nil {
			panic("cant unmarshal body to res:" + err.Error())
		}
		beego.Info("status:" + resp.Status)
	}
	return res
}

type TestRet struct {
	isSuccess bool
	err       string
}

func PterodactylTestConnection(params ParamsData) {
	test := pterodactylApi(params, "", "nodes", "GET")
	beego.Info(test)
}

func PterodactylGetOption() {

}

func PterodactylCreateAccount() {

}

func Test() {
	params := ParamsData{
		Serverhostname: "pte.nightgod.xyz",
		Serversecure:   false,
		Serverpassword: "4byjDYceumT4ylszaCWENzEQWBZCPgEZMh1AtNRonZsnnljp",
	}
	PterodactylTestConnection(params)
}
