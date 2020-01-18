package models

import (
	"bytes"
	"encoding/json"
	"errors"
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

type PterodactylNode struct {
	Id                 int       `json:"id"`
	Public             bool      `json:"public"`
	Name               string    `json:"name"`
	Description        string    `json:"description"`
	LocationId         int       `json:"location_id"`
	FQDN               string    `json:"fqdn"`
	Scheme             string    `json:"scheme"`
	BehindProxy        bool      `json:"behind_proxy"`
	MaintenanceMode    bool      `json:"maintenance_mode"`
	Memory             int       `json:"memory"`
	MemoryOverAllocate int       `json:"memory_overallocate"`
	Disk               int       `json:"disk"`
	DiskOverAllocate   int       `json:"disk_overallocate"`
	UploadSize         int       `json:"upload_size"`
	DaemonListen       int       `json:"daemon_listen"`
	DaemonSftp         int       `json:"daemon_sftp"`
	DaemonBase         string    `json:"daemon_base"`
	CreatedAt          time.Time `json:"created_at"`
	UpdatedAt          time.Time `json:"updated_at"`
}

type PterodactylServerLimit struct {
	Memory int `json:"memory"`
	Swap   int `json:"swap"`
	Disk   int `json:"disk"`
	IO     int `json:"io"`
	CPU    int `json:"cpu"`
}
type PterodactylServer struct {
	Id          int                    `json:"id"`
	ExternalId  int                    `json:"external_id"`
	Uuid        string                 `json:"uuid"`
	Identifier  string                 `json:"identifier"`
	Name        string                 `json:"name"`
	Description string                 `json:"description"`
	Suspended   bool                   `json:"suspended"`
	Limits      PterodactylServerLimit `json:"limits"`
	UserId      int                    `json:"user"`
	NodeId      int                    `json:"node"`
	Allocation  int                    `json:"allocation"`
	NestId      int                    `json:"nest"`
	EggId       int                    `json:"egg"`
	PackId      int                    `json:"pack"`
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

func pterodactylApi(params ParamsData, data interface{}, endPoint string, method string) (string, int) {
	url := pterodactylGethostname(params) + "/api/application/" + endPoint
	beego.Info(url)
	var res string
	var status int
	if method == "POST" || method == "PATCH" {
		ujson, err := json.Marshal(data)
		if err != nil {
			beego.Error("cant marshal data:" + err.Error())
		}
		beego.Info("ujson: ", string(ujson))
		ubody := bytes.NewReader(ujson)
		req, _ := http.NewRequest(method, url, ubody)
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
		beego.Info(string(body))

	} else {
		req, _ := http.NewRequest(method, url, nil)
		req.Header.Set("Authorization", "Bearer "+params.Serverpassword)
		req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
		//beego.Info(req.Header.Get("Authorization"))
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			panic("cant Do req: " + err.Error())
		}
		defer resp.Body.Close()
		body, _ := ioutil.ReadAll(resp.Body)
		res = string(body)
		status = resp.StatusCode
		beego.Info("status: " + resp.Status)
	}
	return res, status
}

type TestRet struct {
	IsSuccess bool
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
	pterodactylGetEnv(params, 1, 17)
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
	if status != 200 {
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

func PterodactylGetNode(data ParamsData, nodeID int) PterodactylNode {
	body, status := pterodactylApi(data, "", "nodes/"+strconv.Itoa(nodeID), "GET")
	if status != 200 {
		return PterodactylNode{}
	}
	type decoder struct {
		Attributes PterodactylNode `json:"attributes"`
	}
	var dec decoder
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes
	}
	return PterodactylNode{}
}

func PterodactylGetServer(data ParamsData, ID int, isExternal bool) PterodactylServer {
	var endPoint string
	if isExternal {
		endPoint = "servers/external/" + strconv.Itoa(ID)
	} else {
		endPoint = "servers/" + strconv.Itoa(ID)
	}
	body, status := pterodactylApi(data, "", endPoint, "GET")
	if status != 200 {
		return PterodactylServer{}
	}
	type decoder struct {
		Attributes PterodactylServer
	}
	var dec decoder
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes
	}
	return PterodactylServer{}
}

func PterodactylGetAllServers(data ParamsData) []PterodactylServer {
	body, status := pterodactylApi(data, "", "servers", "GET")
	if status != 200 {
		return []PterodactylServer{}
	}
	type sDecoder struct {
		Attributes PterodactylServer `json:"attributes"`
	}
	type decoder struct {
		Data []sDecoder `json:"data"`
	}
	var dec decoder
	var servers []PterodactylServer
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		for _, v := range dec.Data {
			servers = append(servers, v.Attributes)
		}
	}
	return servers
}

func pterodactylGetServerID(data ParamsData, serverExternalID int) int {
	server := PterodactylGetServer(data, serverExternalID, true)
	if server == (PterodactylServer{}) {
		return 0
	}
	return server.Id
}
func PterodactylSuspendServer(data ParamsData, serverExternalID int) error {
	serverID := pterodactylGetServerID(data, serverExternalID)
	if serverID == 0 {
		return errors.New("suspend failed because server not found: " + strconv.Itoa(serverID))
	}
	_, status := pterodactylApi(data, "", "servers/"+strconv.Itoa(serverID)+"/suspend", "POST")
	if status != 204 {
		return errors.New("cant suspend server: " + strconv.Itoa(serverID) + " with status code: " + strconv.Itoa(status))
	}
	return nil
}

func PterodactylUnsuspendServer(data ParamsData, serverExternalID int) error {
	serverID := pterodactylGetServerID(data, serverExternalID)
	if serverID == 0 {
		return errors.New("unsuspend failed because server not found: " + strconv.Itoa(serverID))
	}
	_, status := pterodactylApi(data, "", "servers/"+strconv.Itoa(serverID)+"/unsuspend", "POST")
	if status != 204 {
		return errors.New("cant unsuspend server: " + strconv.Itoa(serverID) + " with status code: " + strconv.Itoa(status))
	}
	return nil
}

func PterodactylDeleteServer(data ParamsData, serverExternalID int) error {
	serverID := pterodactylGetServerID(data, serverExternalID)
	if serverID == 0 {
		return errors.New("delete failed because server not found: " + strconv.Itoa(serverID))
	}
	_, status := pterodactylApi(data, "", "servers/"+strconv.Itoa(serverID), "DELETE")
	if status != 204 {
		return errors.New("cant delete server: " + strconv.Itoa(serverID) + " with status code: " + strconv.Itoa(status))
	}
	return nil
}

func PterodactylCreateUser(data ParamsData, userInfo interface{}) error {
	_, status := pterodactylApi(data, userInfo, "users/", "POST")
	if status != 201 {
		return errors.New("cant create user with status code: " + strconv.Itoa(status))
	}
	return nil
}
func pterodactylGetEnv(data ParamsData, nestID int, eggID int) map[string]string {
	ret := map[string]string{}
	body, status := pterodactylApi(data, "", "nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID)+"?include=variables", "GET")
	if status != 200 {
		return map[string]string{}
	}
	type decoder struct {
		Attributes struct {
			Relationships struct {
				Variables struct {
					Data []map[string]interface{} `json:"data"`
				} `json:"variables"`
			} `json:"relationships"`
		} `json:"attributes"`
	}
	var dec decoder
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		beego.Info(dec.Attributes.Relationships.Variables.Data)
		for _, v := range dec.Attributes.Relationships.Variables.Data {
			keys := v["attributes"].(map[string]interface{})
			key := keys["env_variable"].(string)
			value := keys["default_value"].(string)
			if key != "" {
				ret[key] = value
			}
		}
	} else {
		beego.Error(err.Error())
	}
	return ret
}
func PterodactylCreateServer(data ParamsData, serverInfo PterodactylServer) error {
	eggInfo := PterodactylGetEgg(data, serverInfo.NestId, serverInfo.EggId)
	envInfo := pterodactylGetEnv(data, serverInfo.NestId, serverInfo.EggId)
	postData := map[string]interface{}{
		"name":         serverInfo.Name,
		"user":         serverInfo.UserId,
		"nest":         serverInfo.NestId,
		"egg":          serverInfo.EggId,
		"docker_image": eggInfo.DockerImage,
		"startup":      eggInfo.StartUp,
		"oom_disabled": false,
		"limits": map[string]int{
			"memory": serverInfo.Limits.Memory,
			"swap":   serverInfo.Limits.Swap,
			"io":     serverInfo.Limits.IO,
			"cpu":    serverInfo.Limits.CPU,
			"disk":   serverInfo.Limits.Disk,
		},
		"feature_limits": map[string]int{
			"database":    0,
			"allocations": 0,
		},
		"deploy": map[string]interface{}{
			"locations":    nil,
			"dedicated_ip": nil,
			"port_range":   nil,
		},
		"environment":         envInfo,
		"start_on_completion": true,
		"external_id":         serverInfo.ExternalId,
	}
	body, status := pterodactylApi(data, postData, "servers", "POST")
	if status == 400 {
		return errors.New("could not find any nodes satisfying the request")
	}
	if status != 201 {
		return errors.New("failed to create the server, received the error code: " + strconv.Itoa(status))
	}
	var server PterodactylServer
	if err := json.Unmarshal([]byte(body), &server); err == nil {
		beego.Info("New server created: ", server)
	} else {
		beego.Error(err.Error())
	}
	return nil
}
