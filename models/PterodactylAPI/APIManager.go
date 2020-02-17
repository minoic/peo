package PterodactylAPI

import (
	"bytes"
	"encoding/json"
	"errors"
	"github.com/astaxie/beego"
	"io/ioutil"
	"net/http"
	"strconv"
)

type ParamsData struct {
	Serverhostname string
	Serversecure   bool
	Serverpassword string
}

func PterodactylGethostname(params ParamsData) string {
	var hostname string
	if params.Serversecure {
		hostname = "https://" + params.Serverhostname
	} else {
		hostname = "http://" + params.Serverhostname
	}
	for stringLen := len(hostname); hostname[stringLen-1] == '/'; stringLen -= 1 {
	}
	return hostname
}

func pterodactylApi(params ParamsData, data interface{}, endPoint string, method string) (string, int) {
	url := PterodactylGethostname(params) + "/api/application/" + endPoint
	//beego.Info(url)
	var res string
	var status int
	if method == "POST" || method == "PATCH" {
		ujson, err := json.Marshal(data)
		if err != nil {
			beego.Error("cant marshal data:" + err.Error())
		}
		//beego.Info("ujson: ", string(ujson))
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
		//beego.Info("Pterodactyl Post status:" + resp.Status + " body: " + string(body))
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
		//beego.Info("status: " + resp.Status)
	}
	return res, status
}

func PterodactylTestConnection(params ParamsData) {
	test, _ := pterodactylApi(params, "", "nodes", "GET")
	beego.Debug("PterodactylAPI returns: ", test)
}

func PterodactylGetUser(params ParamsData, ID interface{}, isExternal bool) (PterodactylUser, bool) {
	var endPoint string
	if isExternal {
		endPoint = "users/external/" + ID.(string)
	} else {
		endPoint = "users/" + strconv.Itoa(ID.(int))
	}
	body, status := pterodactylApi(params, "", endPoint, "GET")
	if status == 404 || status == 400 {
		return PterodactylUser{}, false
	}
	dec := struct {
		Object     string          `json:"object"`
		Attributes PterodactylUser `json:"attributes"`
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes, true
	}
	return PterodactylUser{}, false
}

func PterodactylGetAllUsers(params ParamsData) []PterodactylUser {
	body, status := pterodactylApi(params, "", "users/", "GET")
	if status != 200 {
		beego.Error("cant get all users: " + strconv.Itoa(status))
		return []PterodactylUser{}
	}
	dec := struct {
		data []struct {
			Attributes PterodactylUser `json:"attributes"`
		}
	}{}
	var users []PterodactylUser
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		for _, v := range dec.data {
			users = append(users, v.Attributes)
		}
	}
	return users
}

func pterodactylGetNest(data ParamsData, nestID int) PterodactylNest {
	body, status := pterodactylApi(data, "", "nests/"+strconv.Itoa(nestID), "GET")
	if status != 200 {
		beego.Error("cant get nest: " + strconv.Itoa(nestID) + " with status code: " + strconv.Itoa(status))
		return PterodactylNest{}
	}
	dec := struct {
		Attributes PterodactylNest `json:"attributes"`
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes
	}
	return PterodactylNest{}
}

func pterodactylGetAllNests(data ParamsData) []PterodactylNest {
	body, status := pterodactylApi(data, "", "nests/", "GET")
	if status != 200 {
		beego.Error("cant get all nests: " + strconv.Itoa(status))
		return []PterodactylNest{}
	}
	var ret []PterodactylNest
	dec := struct {
		data []struct {
			Attributes PterodactylNest `json:"attributes"`
		}
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		for _, v := range dec.data {
			ret = append(ret, v.Attributes)
		}
		return ret
	}
	return []PterodactylNest{}
}

func pterodactylGetEgg(params ParamsData, nestID int, eggID int) PterodactylEgg {
	body, status := pterodactylApi(params, "", "nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID), "GET")
	if status != 200 {
		return PterodactylEgg{}
	}
	dec := struct {
		Attributes PterodactylEgg `json:"attributes"`
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes
	}
	return PterodactylEgg{}
}

func pterodactylGetAllEggs(data ParamsData, nestID int) []PterodactylEgg {
	body, status := pterodactylApi(data, "", "nests/"+strconv.Itoa(nestID)+"/eggs/", "GET")
	if status != 200 {
		beego.Error("cant get all eggs: " + strconv.Itoa(status))
		return []PterodactylEgg{}
	}
	var ret []PterodactylEgg
	dec := struct {
		data []struct {
			Attributes PterodactylEgg `json:"attributes"`
		}
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		for _, v := range dec.data {
			ret = append(ret, v.Attributes)
		}
		return ret
	}
	return []PterodactylEgg{}
}

func pterodactylGetNode(data ParamsData, nodeID int) PterodactylNode {
	body, status := pterodactylApi(data, "", "nodes/"+strconv.Itoa(nodeID), "GET")
	if status != 200 {
		return PterodactylNode{}
	}
	dec := struct {
		Attributes PterodactylNode `json:"attributes"`
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes
	}
	return PterodactylNode{}
}

func pterodactylGetAllocations(data ParamsData, nodeID int) []PterodactylAllocation {
	body, status := pterodactylApi(data, "", "nodes/"+strconv.Itoa(nodeID)+"/allocations", "GET")
	if status != 200 {
		beego.Error("cant get allocations with status code: " + strconv.Itoa(status))
		return []PterodactylAllocation{}
	}
	dec := struct {
		Data []struct {
			Attributes PterodactylAllocation `json:"attributes"`
		} `json:"data"`
	}{}
	var ret []PterodactylAllocation
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		for _, v := range dec.Data {
			if !v.Attributes.Assigned {
				ret = append(ret, v.Attributes)
			}
		}
	}
	return ret
}

func PterodactylGetServer(data ParamsData, ID interface{}, isExternal bool) PterodactylServer {
	var endPoint string
	if isExternal {
		endPoint = "servers/external/" + ID.(string)
	} else {
		endPoint = "servers/" + strconv.Itoa(ID.(int))
	}
	body, status := pterodactylApi(data, "", endPoint, "GET")
	if status != 200 {
		return PterodactylServer{}
	}
	dec := struct {
		Attributes PterodactylServer `json:"attributes"`
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		return dec.Attributes
	} else {
		beego.Error(err.Error())
	}
	return PterodactylServer{}
}

func PterodactylGetAllServers(data ParamsData) []PterodactylServer {
	body, status := pterodactylApi(data, "", "servers", "GET")
	if status != 200 {
		return []PterodactylServer{}
	}
	dec := struct {
		data []struct {
			Attributes PterodactylServer `json:"attributes"`
		}
	}{}
	var servers []PterodactylServer
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		for _, v := range dec.data {
			servers = append(servers, v.Attributes)
		}
	}
	return servers
}

func pterodactylGetServerID(data ParamsData, serverExternalID string) int {
	server := PterodactylGetServer(data, serverExternalID, true)
	if server == (PterodactylServer{}) {
		return 0
	}
	return server.Id
}

func PterodactylSuspendServer(data ParamsData, serverExternalID string) error {
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

func PterodactylUnsuspendServer(data ParamsData, serverExternalID string) error {
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

func PterodactylDeleteServer(data ParamsData, serverExternalID string) error {
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

/*_ = PterodactylCreateUser(params, PostPteUser{
ExternalId: "1212",
Username:   "1212",
Email:      "222@qq.com",
Language:   "zh",
RootAdmin:  false,
Password:   "22233",
FirstName:  "s",
LastName:   "ds",
})*/

func PterodactylCreateUser(data ParamsData, userInfo interface{}) error {
	_, status := pterodactylApi(data, userInfo, "users", "POST")
	if status != 201 {
		return errors.New("cant create user with status code: " + strconv.Itoa(status))
	}
	return nil
}

func PterodactylDeleteUser(data ParamsData, externalID string) error {
	if user, ok := PterodactylGetUser(data, externalID, true); ok {
		_, status := pterodactylApi(data, "", "users/"+strconv.Itoa(user.Uid), "DELETE")
		if status != 204 {
			return errors.New("cant delete user: " + user.UserName + " with status code: " + strconv.Itoa(status))
		}
		return nil
	} else {
		return errors.New("cant get user")
	}
}

func pterodactylGetEnv(data ParamsData, nestID int, eggID int) map[string]string {
	ret := map[string]string{}
	body, status := pterodactylApi(data, "", "nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID)+"?include=variables", "GET")
	if status != 200 {
		return map[string]string{}
	}
	dec := struct {
		Attributes struct {
			Relationships struct {
				Variables struct {
					Data []map[string]interface{} `json:"data"`
				} `json:"variables"`
			} `json:"relationships"`
		} `json:"attributes"`
	}{}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		//beego.Info(dec.Attributes.Relationships.Variables.Data)
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

func Test() {
	params := ConfGetParams()
	PterodactylTestConnection(params)
	ret := pterodactylGetAllocations(params, 6)
	for k, v := range ret {
		beego.Debug(k, v)
	}
}

/*_ = PterodactylCreateServer(params, PterodactylServer{
Id:          111,
ExternalId:  "12121",
Uuid:        "",
Identifier:  "",
Name:        "12121",
Description: "12121",
Suspended:   false,
Limits: PterodactylServerLimit{
Memory: 1212,
Swap:   1212,
Disk:   1212,
IO:     500,
CPU:    100,
},
UserId:     1,
NodeId:     5,
Allocation: 517,
NestId:     1,
EggId:      17,
PackId:     0,
})*/

func PterodactylCreateServer(data ParamsData, serverInfo PterodactylServer) error {
	eggInfo := pterodactylGetEgg(data, serverInfo.NestId, serverInfo.EggId)
	envInfo := pterodactylGetEnv(data, serverInfo.NestId, serverInfo.EggId)
	postData := map[string]interface{}{
		"name":         serverInfo.Name,
		"user":         serverInfo.UserId,
		"nest":         serverInfo.NestId,
		"egg":          serverInfo.EggId,
		"docker_image": eggInfo.DockerImage,
		"startup":      eggInfo.StartUp,
		"description":  serverInfo.Description,
		"oom_disabled": true,
		"limits": map[string]int{
			"memory": serverInfo.Limits.Memory,
			"swap":   serverInfo.Limits.Swap,
			"io":     serverInfo.Limits.IO,
			"cpu":    serverInfo.Limits.CPU,
			"disk":   serverInfo.Limits.Disk,
		},
		"feature_limits": map[string]interface{}{
			"databases":   nil,
			"allocations": serverInfo.Allocation,
		},
		"environment":         envInfo,
		"start_on_completion": false,
		"external_id":         serverInfo.ExternalId,
		"allocation": map[string]interface{}{
			"default": serverInfo.Allocation,
		},
	}
	body, status := pterodactylApi(data, postData, "servers", "POST")
	//beego.Debug("body:",body)
	if status == 400 {
		return errors.New("could not find any nodes satisfying the request")
	}
	if status != 201 {
		return errors.New("failed to create the server, received the error code: " + strconv.Itoa(status))
	}
	var dec struct {
		Server PterodactylServer `json:"attributes"`
	}
	if err := json.Unmarshal([]byte(body), &dec); err == nil {
		beego.Info("New server created: ", dec.Server)
	} else {
		return err
	}
	if dec.Server == (PterodactylServer{}) {
		return errors.New("Pterodactyl API returns empty struct: " + body)
	}
	//beego.Info(dec.Server)
	return nil
}
