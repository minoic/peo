package models

import (
	"bytes"
	"encoding/json"
	"github.com/astaxie/beego"
	"io/ioutil"
	"net/http"
	"strconv"
	"time"
)

type ParamsData struct {
	Serverhostname string
	Serversecure   bool
	Serverpassword string
}

type PterodactylUser struct {
	Uid        int       `json:"id"`
	ExternalId int       `json:"external_id"`
	Uuid       string    `json:"uuid"`
	UserName   string    `json:"username"`
	Email      string    `json:"email"`
	FirstName  string    `json:"first_name"`
	LastName   string    `json:"last_name"`
	Language   string    `json:"language"`
	RootAdmin  bool      `json:"root_admin"`
	TwoFA      bool      `json:"2fa"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

type PterodactylEgg struct {
	Id          int       `json:"id"`
	Uuid        string    `json:"uuid"`
	Name        string    `json:"name"`
	Nest        int       `json:"nest"`
	Author      string    `json:"author"`
	Description string    `json:"description"`
	DockerImage string    `json:"docker_image"`
	StartUp     string    `json:"startup"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
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
func pterodactylApi(params ParamsData, data string, endPoint string, method string) (string, int) {
	url := pterodactylGethostname(params) + "/api/application/" + endPoint
	beego.Info(url)
	var res string
	var status int
	if method == "POST" || method == "PATCH" {
		ujson, err := json.Marshal(data)
		if err != nil {
			beego.Error("cant marshal data:" + err.Error())
		}
		ubody := bytes.NewReader(ujson)
		req, _ := http.NewRequest("POST", url, ubody)
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
		res = string(body)
		status = resp.StatusCode
		beego.Info("Pterodactyl Post status:" + resp.Status)

	} else {
		req, _ := http.NewRequest(method, url, nil)
		req.Header.Set("Authorization", "Bearer "+params.Serverpassword)
		req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
		//beego.Info(req.Header.Get("Authorization"))
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			panic("cant Do req:" + err.Error())
		}
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		res = string(body)
		status = resp.StatusCode
		beego.Info("status:" + resp.Status)
	}
	return res, status
}

type TestRet struct {
	isSuccess bool
	err       string
}

func PterodactylTestConnection(params ParamsData) {
	test, _ := pterodactylApi(params, "", "nodes", "GET")
	beego.Info("PterodactylAPI returns: ", test)
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

func PterodactylGetUser(params ParamsData, externalID int) (PterodactylUser, bool) {
	body, status := pterodactylApi(params, "", "users/"+strconv.Itoa(externalID), "GET")
	beego.Info(body, status)
	if status == 404 || status == 400 {
		return PterodactylUser{}, false
	}
	type decoder struct {
		Object     string          `json:"object"`
		Attributes PterodactylUser `json:"attributes"`
	}
	var dec decoder
	if err := json.Unmarshal([]byte(body), &dec); err == nil {

		beego.Info(dec.Attributes)
		return dec.Attributes, true
	}
	return PterodactylUser{}, false
}

func PterodactylGetExternalUser(params ParamsData, externalID int) (PterodactylUser, bool) {
	body, status := pterodactylApi(params, "", "users/external/"+strconv.Itoa(externalID), "GET")
	beego.Info(body, status)
	if status == 404 || status == 400 {
		return PterodactylUser{}, false
	}
	type decoder struct {
		Object     string          `json:"object"`
		Attributes PterodactylUser `json:"attributes"`
	}
	var dec decoder
	if err := json.Unmarshal([]byte(body), &dec); err == nil {

		beego.Info(dec.Attributes)
		return dec.Attributes, true
	}
	return PterodactylUser{}, false
}

func PterodactylGetAllUsers(params ParamsData) []PterodactylUser {
	body, status := pterodactylApi(params, "", "users/", "GET")
	if status == 400 || status == 404 {
		return []PterodactylUser{}
	}
	type userDecoder struct {
		Attributes PterodactylUser `json:"attributes"`
	}
	type decoder struct {
		Data []userDecoder `json:"data"`
	}
	var dec decoder
	var users []PterodactylUser
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		for _, v := range dec.Data {
			users = append(users, v.Attributes)
		}
	}
	return users
}

func PterodactylGetEgg(params ParamsData, nestID int, eggID int) PterodactylEgg {
	body, status := pterodactylApi(params, "", "nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID), "GET")
	if status != 200 {
		return PterodactylEgg{}
	}
	type decoder struct {
		Attributes PterodactylEgg `json:"attributes"`
	}
	var dec decoder
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes
	}
	return PterodactylEgg{}
}
