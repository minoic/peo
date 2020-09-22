package PterodactylAPI

import (
	"bytes"
	"errors"
	"fmt"
	jsoniter "github.com/json-iterator/go"
	"io/ioutil"
	"net/http"
	"strconv"
)

//  Pterodactyl API client
type Client struct {
	/* ServerHostname = "http://xxx.example.com" */
	url string
	/* your application API */
	token string
}

// initial a new client instance
func NewClient(url string, token string) *Client {
	for stringLen := len(url); url[stringLen-1] == '/'; stringLen -= 1 {
	}
	return &Client{url: url, token: token}
}

var json = jsoniter.ConfigCompatibleWithStandardLibrary

func (this *Client) HostName() string {
	return this.url
}

func (this *Client) api(data interface{}, endPoint string, method string) ([]byte, error) {
	/* Send requests to pterodactyl panel */
	url := this.url + "/api/application/" + endPoint
	var (
		err error
		req *http.Request
	)
	if method == "POST" || method == "PATCH" {
		ujson, err := json.Marshal(data)
		if err != nil {
			fmt.Print("cant marshal data:" + err.Error())
		}
		ubody := bytes.NewReader(ujson)
		req, err = http.NewRequest(method, url, ubody)
		if err != nil {
			return nil, err
		}
		req.Header.Set("Authorization", "Bearer "+this.token)
		req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
		req.ContentLength = int64(len(ujson))
		req.Header.Set("Content-Type", "application/json")
	} else {
		req, err = http.NewRequest(method, url, nil)
		if err != nil {
			return nil, err
		}
		req.Header.Set("Authorization", "Bearer "+this.token)
		req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	if resp.StatusCode >= 400 {
		return nil, errors.New(strconv.Itoa(resp.StatusCode) + ":" + string(body))
	}
	return body, nil
}

func (this *Client) TestConnection() {
	test, _ := this.api("", "nodes", "GET")
	fmt.Print("PterodactylAPI returns: ", test)
}

func (this *Client) getUser(ID interface{}, isExternal bool) (*User, error) {
	var endPoint string
	if isExternal {
		endPoint = "users/external/" + ID.(string)
	} else {
		endPoint = "users/" + strconv.Itoa(ID.(int))
	}
	body, err := this.api("", endPoint, "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Object     string `json:"object"`
		Attributes User   `json:"attributes"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		return &dec.Attributes, nil
	}
	return nil, err
}

func (this *Client) getAllUsers() ([]User, error) {
	body, err := this.api("", "users/", "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		data []struct {
			Attributes User `json:"attributes"`
		}
	}{}
	var users []User
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.data {
			users = append(users, v.Attributes)
		}
	}
	return users, nil
}

func (this *Client) getNest(nestID int) (*Nest, error) {
	body, err := this.api("", "nests/"+strconv.Itoa(nestID), "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Attributes Nest `json:"attributes"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		return &dec.Attributes, nil
	}
	return nil, err
}

func (this *Client) getAllNests() ([]Nest, error) {
	body, err := this.api("", "nests/", "GET")
	if err != nil {
		return nil, err
	}
	var ret []Nest
	dec := struct {
		data []struct {
			Attributes Nest `json:"attributes"`
		}
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.data {
			ret = append(ret, v.Attributes)
		}
		return ret, nil
	}
	return nil, err
}

func (this *Client) getEgg(nestID int, eggID int) (*Egg, error) {
	body, err := this.api("", "nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID), "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Attributes Egg `json:"attributes"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		return &dec.Attributes, nil
	}
	return nil, err
}

func (this *Client) getAllEggs(nestID int) ([]Egg, error) {
	body, err := this.api("", "nests/"+strconv.Itoa(nestID)+"/eggs/", "GET")
	if err != nil {
		return nil, err
	}
	var ret []Egg
	dec := struct {
		data []struct {
			Attributes Egg `json:"attributes"`
		}
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.data {
			ret = append(ret, v.Attributes)
		}
		return ret, err
	}
	return nil, err
}

func (this *Client) getNode(nodeID int) (*Node, error) {
	body, err := this.api("", "nodes/"+strconv.Itoa(nodeID), "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Attributes Node `json:"attributes"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		return &dec.Attributes, nil
	}
	return nil, err
}

func (this *Client) getAllocations(nodeID int) ([]Allocation, error) {
	body, err := this.api("", "nodes/"+strconv.Itoa(nodeID)+"/allocations", "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Data []struct {
			Attributes Allocation `json:"attributes"`
		} `json:"data"`
	}{}
	var ret []Allocation
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.Data {
			if !v.Attributes.Assigned {
				ret = append(ret, v.Attributes)
			}
		}
	}
	return ret, nil
}

func (this *Client) getServer(ID interface{}, isExternal bool) (*Server, error) {
	var endPoint string
	if isExternal {
		endPoint = "servers/external/" + ID.(string)
	} else {
		endPoint = "servers/" + strconv.Itoa(ID.(int))
	}
	body, err := this.api("", endPoint, "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Attributes Server `json:"attributes"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		return &dec.Attributes, nil
	} else {
		fmt.Print(err.Error())
	}
	return nil, err
}

func (this *Client) GetAllServers() ([]Server, error) {
	body, err := this.api("", "servers", "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		data []struct {
			Attributes Server `json:"attributes"`
		}
	}{}
	var servers []Server
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.data {
			servers = append(servers, v.Attributes)
		}
	}
	return servers, nil
}

func (this *Client) GetServerID(serverExternalID string) int {
	server, err := this.getServer(serverExternalID, true)
	if err != nil {
		return 0
	}
	return server.Id
}

func (this *Client) SuspendServer(serverExternalID string) error {
	serverID := this.GetServerID(serverExternalID)
	if serverID == 0 {
		return errors.New("suspend failed because server not found: " + strconv.Itoa(serverID))
	}
	_, err := this.api("", "servers/"+strconv.Itoa(serverID)+"/suspend", "POST")
	return err
}

func (this *Client) UnsuspendServer(serverExternalID string) error {
	serverID := this.GetServerID(serverExternalID)
	if serverID == 0 {
		return errors.New("unsuspend failed because server not found: " + strconv.Itoa(serverID))
	}
	_, err := this.api("", "servers/"+strconv.Itoa(serverID)+"/unsuspend", "POST")
	return err
}

func (this *Client) ReinstallServer(serverExternalID string) error {
	serverID := this.GetServerID(serverExternalID)
	if serverID == 0 {
		return errors.New("reinstall failed because server not found: " + strconv.Itoa(serverID))
	}
	_, err := this.api("", "servers/"+strconv.Itoa(serverID)+"/reinstall", "POST")
	return err
}

func (this *Client) DeleteServer(serverExternalID string) error {
	serverID := this.GetServerID(serverExternalID)
	if serverID == 0 {
		return errors.New("delete failed because server not found: " + strconv.Itoa(serverID))
	}
	_, err := this.api("", "servers/"+strconv.Itoa(serverID), "DELETE")
	return err
}

/*_ = PterodactylCreateUser(params, PostPteUser{
ExternalId: "aSTRING",
Username:   "aSTRING",
Email:      "user@example.com",
Language:   "en",
RootAdmin:  false,
Password:   "PASSwd",
FirstName:  "first",
LastName:   "last",
})*/

func (this *Client) CreateUser(userInfo interface{}) error {
	_, err := this.api(userInfo, "users", "POST")
	return err
}

func (this *Client) DeleteUser(externalID string) error {
	if user, err := this.getUser(externalID, true); err == nil {
		_, err2 := this.api("", "users/"+strconv.Itoa(user.Uid), "DELETE")
		return err2
	} else {
		return err
	}
}

func (this *Client) getEnv(nestID int, eggID int) (map[string]string, error) {
	ret := map[string]string{}
	body, err := this.api("", "nests/"+strconv.Itoa(nestID)+"/eggs/"+strconv.Itoa(eggID)+"?include=variables", "GET")
	if err != nil {
		return nil, err
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
	if err := json.Unmarshal(body, &dec); err == nil {
		// fmt.Print(dec.Attributes.Relationships.Variables.Data)
		for _, v := range dec.Attributes.Relationships.Variables.Data {
			keys := v["attributes"].(map[string]interface{})
			key := keys["env_variable"].(string)
			value := keys["default_value"].(string)
			if key != "" {
				ret[key] = value
			}
		}
	} else {
		fmt.Print(err.Error())
	}
	return ret, nil
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
Memory: 1024,
Swap:   -1,
Disk:   2048,
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

func (this *Client) CreateServer(serverInfo Server) error {
	eggInfo, err := this.getEgg(serverInfo.NestId, serverInfo.EggId)
	if err != nil {
		return err
	}
	envInfo, err := this.getEnv(serverInfo.NestId, serverInfo.EggId)
	if err != nil {
		return err
	}
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
	body, err := this.api(postData, "servers", "POST")
	if err != nil {
		return err
	}
	var dec struct {
		Server Server `json:"attributes"`
	}
	if err := json.Unmarshal(body, &dec); err == nil {
		fmt.Print("New server created: ", dec.Server)
	} else {
		return err
	}
	if dec.Server == (Server{}) {
		return errors.New("Pterodactyl API returns empty struct: " + string(body))
	}
	return nil
}

func (this *Client) UpdateServerDetail(externalID string, details PostUpdateDetails) error {
	serverID := this.GetServerID(externalID)
	patchData := map[string]interface{}{
		"user":        details.UserID,
		"description": details.Description,
		"name":        details.ServerName,
		"external_id": details.ExternalID,
	}
	_, err := this.api(patchData, "servers/"+strconv.Itoa(serverID)+"/details", "PATCH")
	return err
}

func (this *Client) UpdateServerBuild(externalID string, build PostUpdateBuild) error {
	serverID := this.GetServerID(externalID)
	patchData := map[string]interface{}{
		"allocation":   build.Allocation,
		"memory":       build.Memory,
		"io":           build.IO,
		"swap":         build.Swap,
		"cpu":          build.CPU,
		"disk":         build.Disk,
		"oom_disabled": build.OomDisabled,
		"feature_limits": map[string]interface{}{
			"databases":   build.Database,
			"allocations": build.Allocations,
		},
	}
	_, err := this.api(patchData, "servers/"+strconv.Itoa(serverID)+"/build", "PATCH")
	return err
}

func (this *Client) UpdateServerStartup(externalID string, packID int) error {
	server, err := this.getServer(externalID, true)
	if err != nil {
		return err
	}
	eggInfo, err := this.getEgg(server.NestId, server.EggId)
	if err != nil {
		return err
	}
	env, err := this.getEnv(server.NestId, server.EggId)
	if err != nil {
		return err
	}
	patchData := map[string]interface{}{
		"environment":  env,
		"startup":      eggInfo.StartUp,
		"egg":          server.EggId,
		"pack":         packID,
		"image":        eggInfo.DockerImage,
		"skip_scripts": false,
	}
	_, err = this.api(patchData, "servers/"+strconv.Itoa(server.Id)+"/startup", "PATCH")
	return err
}
