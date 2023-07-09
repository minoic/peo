package pterodactyl

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/bluele/gcache"
	"github.com/minoic/glgf"
	"github.com/spf13/cast"
	"io"
	"net/http"
	"net/http/cookiejar"
	"strconv"
	"strings"
	"time"
)

var (
	gc   = gcache.New(128).ARC().Build()
	pool = make(chan struct{}, 4)
)

// Client Pterodactyl API client
type Client struct {
	/* ServerHostname = "http://xxx.example.com" */
	url string
	/* your application API */
	token string
}

// NewClient initial a new client instance
func NewClient(url string, token string) *Client {
	strings.TrimRight(url, "/")
	return &Client{url: url, token: token}
}

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
		var buf bytes.Buffer
		err := json.NewEncoder(&buf).Encode(data)
		if err != nil {
			fmt.Print("cant marshal data:" + err.Error())
		}
		req, err = http.NewRequest(method, url, &buf)
		if err != nil {
			return nil, err
		}
		req.Header.Set("Authorization", "Bearer "+this.token)
		req.Header.Set("Accept", "Application/vnd.pterodactyl.v1+json")
		req.ContentLength = int64(buf.Len())
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
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	if resp.StatusCode >= 400 {
		return nil, errors.New(strconv.Itoa(resp.StatusCode) + ":" + string(body))
	}
	return body, nil
}

func (this *Client) Login(Email string, Password string) (string, error) {
	jar, _ := cookiejar.New(nil)
	cli := http.Client{Jar: jar}
	get, err := cli.Get(this.url + "/sanctum/csrf-cookie")
	if err != nil {
		return "", err
	}
	buf := bytes.Buffer{}
	err = json.NewEncoder(&buf).Encode(map[string]interface{}{
		"user":                 Email,
		"password":             Password,
		"g-recaptcha-response": "",
	})
	if err != nil {
		return "", err
	}
	req, err := http.NewRequest("POST", this.url+"/auth/login", &buf)
	if err != nil {
		return "", err
	}
	for _, c := range get.Cookies() {
		if c.Name == "XSRF-TOKEN" {
			glgf.Debug("xsrf found", c.Value)
			req.Header.Set("x-xsrf-token", strings.ReplaceAll(c.Value, "%3D", "="))
			req.Header.Set("origin", this.url)
			req.Header.Set("accept", "application/json")
			req.Header.Set("accept-encoding", "gzip, deflate, br")
			req.Header.Set("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.69")
			req.Header.Set("content-type", "application/json")
		}
	}
	resp, err := cli.Do(req)
	if err != nil {
		return "", err
	}
	for _, c := range resp.Cookies() {
		if c.Name == "pterodactyl_session" {
			return c.Value, nil
		}
	}
	return "", errors.New("cant find pterodactyl_session in header")
}

func (this *Client) TestConnection() error {
	test, err := this.api("", "nodes", "GET")
	fmt.Print("PterodactylAPI returns: ", string(test))
	return err
}

func (this *Client) GetUser(ID interface{}, isExternal bool) (*User, error) {
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

func (this *Client) GetAllUsers() ([]User, error) {
	body, err := this.api("", "users/", "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Data []struct {
			Attributes User `json:"attributes"`
		} `json:"data"`
	}{}
	var users []User
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.Data {
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

func (this *Client) GetNest(nestID int) (*Nest, error) {
	key := "NEST" + cast.ToString(nestID)
	if !gc.Has(key) {
		pool <- struct{}{}
		defer func() {
			<-pool
		}()
	}
	if get, err := gc.Get(key); err == nil {
		return get.(*Nest), nil
	}
	ret, err := this.getNest(nestID)
	if err != nil {
		return nil, err
	}
	err = gc.SetWithExpire(key, ret, 3*time.Minute)
	if err != nil {
		glgf.Error(err)
	}
	return ret, err
}

func (this *Client) GetAllNests() ([]Nest, error) {
	body, err := this.api("", "nests/", "GET")
	if err != nil {
		return nil, err
	}
	var ret []Nest
	dec := struct {
		Data []struct {
			Attributes Nest `json:"attributes"`
		} `json:"data"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.Data {
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

func (this *Client) GetEgg(nestID int, eggID int) (*Egg, error) {
	key := "NEST" + cast.ToString(nestID) + "EGG" + cast.ToString(eggID)
	if !gc.Has(key) {
		pool <- struct{}{}
		defer func() {
			<-pool
		}()
	}
	if get, err := gc.Get(key); err == nil {
		return get.(*Egg), nil
	}
	ret, err := this.getEgg(nestID, eggID)
	if err != nil {
		return nil, err
	}
	err = gc.SetWithExpire(key, ret, time.Minute)
	if err != nil {
		glgf.Error(err)
	}
	return ret, err
}

func (this *Client) getAllEggs(nestID int) ([]Egg, error) {
	body, err := this.api("", "nests/"+strconv.Itoa(nestID)+"/eggs/", "GET")
	if err != nil {
		return nil, err
	}
	var ret []Egg
	dec := struct {
		Data []struct {
			Attributes Egg `json:"attributes"`
		} `json:"data"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.Data {
			ret = append(ret, v.Attributes)
		}
		return ret, err
	}
	return nil, err
}

func (this *Client) GetAllEggs(nestID int) ([]Egg, error) {
	key := "ALLEGGS" + cast.ToString(nestID)
	if !gc.Has(key) {
		pool <- struct{}{}
		defer func() {
			<-pool
		}()
	}
	if get, err := gc.Get(key); err == nil {
		return get.([]Egg), nil
	}
	ret, err := this.getAllEggs(nestID)
	if err != nil {
		return nil, err
	}
	err = gc.SetWithExpire(key, ret, 3*time.Minute)
	if err != nil {
		glgf.Error(err)
	}
	return ret, err
}

func (this *Client) GetAllNodes() ([]Node, error) {
	body, err := this.api("", "nodes", "GET")
	if err != nil {
		return nil, err
	}
	var ret []Node
	dec := struct {
		Data []struct {
			Attributes Node `json:"attributes"`
		} `json:"data"`
	}{}
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.Data {
			ret = append(ret, v.Attributes)
		}
		return ret, err
	}
	return nil, err
}

func (this *Client) GetNode(nodeID int) (*Node, error) {
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

func (this *Client) GetAllocations(nodeID int) ([]Allocation, error) {
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

func (this *Client) GetServer(ID interface{}, isExternal bool) (*Server, error) {
	key := "SERVER" + cast.ToString(ID)
	if !gc.Has(key) {
		pool <- struct{}{}
		defer func() {
			<-pool
		}()
	}
	if get, err := gc.Get(key); err == nil {
		return get.(*Server), nil
	}
	ret, err := this.getServer(ID, isExternal)
	if err != nil {
		return nil, err
	}
	err = gc.SetWithExpire(key, ret, time.Minute)
	if err != nil {
		glgf.Error(err)
	}
	return ret, err
}

func (this *Client) GetAllServers() ([]Server, error) {
	body, err := this.api("", "servers", "GET")
	if err != nil {
		return nil, err
	}
	dec := struct {
		Data []struct {
			Attributes Server `json:"attributes"`
		} `json:"data"`
	}{}
	var servers []Server
	if err := json.Unmarshal(body, &dec); err == nil {
		for _, v := range dec.Data {
			servers = append(servers, v.Attributes)
		}
	}
	return servers, nil
}

func (this *Client) GetServerID(serverExternalID string) int {
	server, err := this.GetServer(serverExternalID, true)
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
	if user, err := this.GetUser(externalID, true); err == nil {
		_, err2 := this.api("", "users/"+strconv.Itoa(user.Uid), "DELETE")
		return err2
	} else {
		return err
	}
}

func (this *Client) GetEnv(nestID int, eggID int) (map[string]string, error) {
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

func (this *Client) ChangePassword(externalID string, pwd string) error {
	user, err := this.GetUser(externalID, true)
	if err != nil {
		return err
	}
	_, err = this.api(map[string]interface{}{
		"password":   pwd,
		"email":      user.Email,
		"username":   user.UserName,
		"first_name": user.FirstName,
		"last_name":  user.LastName,
		"language":   user.Language,
	}, "users/"+strconv.Itoa(user.Uid), "PATCH")
	return err
}

func (this *Client) CreateServer(serverInfo Server) error {
	eggInfo, err := this.GetEgg(serverInfo.NestId, serverInfo.EggId)
	if err != nil {
		return err
	}
	envInfo, err := this.GetEnv(serverInfo.NestId, serverInfo.EggId)
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
		"limits": map[string]interface{}{
			"memory":       serverInfo.Limits.Memory,
			"swap":         serverInfo.Limits.Swap,
			"io":           serverInfo.Limits.IO,
			"cpu":          serverInfo.Limits.CPU,
			"disk":         serverInfo.Limits.Disk,
			"oom_disabled": serverInfo.Limits.OOMDisabled,
		},
		"feature_limits": map[string]interface{}{
			"databases":   serverInfo.FeatureLimits.Databases,
			"allocations": serverInfo.FeatureLimits.Allocations,
			"backups":     serverInfo.FeatureLimits.Backups,
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
	server, err := this.GetServer(externalID, true)
	if err != nil {
		return err
	}
	eggInfo, err := this.GetEgg(server.NestId, server.EggId)
	if err != nil {
		return err
	}
	env, err := this.GetEnv(server.NestId, server.EggId)
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
