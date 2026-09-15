# AGENTS.md

面向 AI 助手与新贡献者的开发指南。修改代码前请先读完本文件。

## 1. 项目主题

**peo** 是 [翼龙面板（Pterodactyl Panel）](https://github.com/pterodactyl/panel) 的**自动售卖与控制前端**：
在翼龙之上叠加一层面向终端用户的商品展示、下单、支付、续费、工单、消息与相册系统，管理员可在后台管理商品与服务器生命周期。

- 目前只面向 **Minecraft** 服务器（`internal/status` 通过 MC 协议 ping 获取在线人数/版本，其它游戏类型不支持）。
- 适配翼龙面板 **v1.11.2**。
- 模块名 `github.com/minoic/peo`，Go 1.21（Docker 构建镜像 `golang:1.21.0-alpine`）。
- README 已声明：当前代码可维护性较差，后续会用 Gin + Vue/Flutter 重构并以 v1 发布，**在此之前不新增功能**。因此改动应以修复与小范围维护为主，避免大重构。

## 2. 技术栈

| 领域 | 选型 |
|---|---|
| Web 框架 | Beego v2（`beego/v2` v2.1.3，MVC + 自带模板引擎） |
| 国际化 | `beego/i18n`（ini 文件，模板函数 `i18n`） |
| ORM | `jinzhu/gorm` v1.9.16（仅 MySQL，无 `context`，用 `RecordNotFound()`） |
| 缓存/会话 | Redis（`redis/go-redis/v9`）；Beego session provider = redis |
| 配置 | `spf13/viper` + TOML（`conf/settings.toml`） |
| 定时任务 | `robfig/cron/v3` |
| 邮件 | `xhit/go-simple-mail` + `matcornic/hermes/v2` 模板 |
| 支付 | `smartwalle/alipay/v3`（支付宝当面付）+ `skip2/go-qrcode` |
| 其它 | `minoic/glgf`（日志）、`robbert229/jwt`、`mholt/archiver`（导出 KEY 压缩包）、`bluele/gcache`（翼龙 API 结果缓存）、`gofrs/uuid/v5`、`hako/durafmt`、`spf13/cast` |

## 3. 目录结构

```
main.go                    入口：注入构建信息 → 注册路由 → 启动定时任务 → web.Run()
api/router.go              全部路由 + Beego 全局配置 + 模板函数注册
conf/
  app.conf                 Beego 基础配置（appname/runmode/session）
  settings.toml            全部业务配置（数据库、翼龙、SMTP、支付宝等）
  locale/{en-US,zh-CN,de-DE}.ini   i18n 文案
  embed.go                 go:embed 内嵌上述文件，供首次运行时落盘
internal/
  configure/               viper 配置加载、默认配置生成、支付宝客户端、i18n 初始化
  database/                连接管理（MySQL/Redis）+ 全部 GORM 模型
  session/                 会话登录态校验（session.go）与 JWT 签发校验（auth_jwt.go）
  controllers/             所有 HTTP 控制器，一页一文件
  cron/                    定时任务注册
  pterodactyl/             翼龙 Application API 客户端 + 数据模型 + 服务器巡检
  orderform/               下单、KEY/余额支付、创建翼龙服务器
  cryptoo/                 KEY/充值码生成与过期清理
  email/                   SMTP 发信与邮件模板
  message/                 站内信
  status/                  Minecraft 服务器状态探测（原生 TCP 协议）
views/                     页面模板（.html），tpls/ 为公共片段
static/                    前端静态资源（css/js/fonts/perfect 主题）
build/  dist/  tmp/        构建/部署产物，已在 .gitignore 中
```

## 4. 架构与关键机制

### 启动顺序

`main.go` → `api.InitRouter()` → `go cron.LoopTasksManager()` → `web.Run()`。

`internal/configure` 与 `internal/database` 的 `init()` 会在导入时执行，因此：**配置先于数据库**，`database.Mysql()` 在首次调用时才会阻塞式重连。新增包若依赖配置或 DB，直接用 `configure.Viper()` / `database.Mysql()` 即可，无需自己初始化。

### 配置

- `configure.init()`：`conf/app.conf` 缺失则写入内嵌默认值并 **`os.Exit(1)`**（要求重启）；`conf/settings.toml` 缺失则生成；检测到旧版 `conf/settings.conf` 会自动转换；随后 `initLocalefile()` 把内嵌的 `conf/locale/*.ini` 落盘并 `i18n.SetMessage`。
- `ReloadConfig()` 每次都会去掉 `WebHostName`/`PterodactylHostname` 末尾斜杠并 **`WriteConfig()` 回写**文件。管理员保存设置后调用它，同时调用 `database.Reset()` 让连接重建。
- 配置项路径为**相对路径**（`conf/...`、`views/`、`static/`），因此程序**必须在仓库根目录下运行**，否则配置与模板都找不到。
- 读取一律通过 `configure.Viper().GetString/GetBool/GetInt(...)`；新增配置项需同步三处：`conf/settings.toml`、`internal/controllers/admin_settings_controller.go`（`Post()` 写入 + `getSettings()` 表单描述）。

### 路由与控制器

- `api/router.go` 中每个页面注册一个控制器类型，附加动作注册为 `"get:Method"` / `"post:Method"`。
- 控制器统一模式：`Prepare()` 里设置 `TplName`、调用 `handleNavbar(&this.Controller)`（需要侧边栏时再加 `handleSidebar`）、做登录/管理员校验（失败用 `this.Abort("401")`）。
- 导航/侧边栏高亮靠 `this.Data["u"]` 与 `this.Data["i"]`：`u` 为 0 无 / 1 商品 / 2 消息 / 3 用户控制台 / 4 管理后台 / 5 相册；`i` 为 1 控制台 / 2 设置 / 3 充值 / 4 工单。新增页面必须设置它们。
- 模板函数：`{{i18n Lang "key"}}`，`Lang` 返回配置中的 `Language`。Go 代码里用 `controllers.tr(key)`。
- 页面跳转统一走 `DelayRedirect(DelayInfo{...}, &this.Controller)` → 302 到 `/delay/` 展示提示再跳转；错误页 `ErrorController` 同样如此。AJAX 接口则直接 `this.Ctx.ResponseWriter.Write([]byte("..."))` 返回纯文本，前端比对固定字符串。
- **注意**：模板中的 `{{.xsrfData}}` 是历史遗留，Beego `EnableXSRF` 默认关闭，该变量实际为空（不会报错）。不要依赖 CSRF token，也不必“顺手修复”。

### 数据层

- 模型集中在 `internal/database/gorm_models.go`，共 14 个表，`init()` 里设置统一表名前缀（`SqlTablePrefix`，默认 `pe_`）并执行 `AutoMigrate`。**新增模型必须加入 `AutoMigrate` 列表**，字段变更会自动迁移（不支持删除列）。
- 连接：`database.Mysql()` 在失败时循环 sleep 3s 重连；`database.Redis()` 惰性创建（超时 3s）；`database.Reset()` 置空句柄以支持设置变更后重连。
- Redis 除缓存外还承担**限流**：`RENEW<entityID>`、`REINSTALL<userName>`、`WORKORDER<userName>` 等键。
- 表名/字段名遵循 GORM 默认蛇形命名，查询直接用 `Where("key_string = ?", ...)`。

### 认证与鉴权

- 会话键：`LST`（JWT）、`UN`（用户名）、`ID`（用户主键）。
- `session.Logged()` 同时校验 JWT 与用户存在性；`session.IsAdmin()`、`session.GetUser()` 供控制器使用。
- 密码为 `md5(明文 + DatabaseSalt)` 的十六进制（`login_controller.go`），注册同理。
- JWT 密钥**硬编码在 `internal/session/auth_jwt.go`**（历史遗留）。修改该文件时不要顺手改动密钥，否则所有用户会掉线。
- 翼龙侧：`/delay/login` 用 `pterodactyl.ClientFromConf().Login(email, ptePassword)` 拿到 `pterodactyl_session` 并写入 cookie（作用域 `.<WebHostName 首个点之后的部分>`），再跳转翼龙登录页，实现免登录。该功能要求站点与翼龙面板同父域且启用 HTTPS。翼龙用户密码存在 `PterodactylPassword` 表，默认等于用户名。

### 业务主流程

1. **注册**：验证码（`beego/captcha`，内存缓存，`/captcha/` 过滤器）→ 校验用户名 `[a-zA-Z0-9_]` → 建用户，**首个用户自动成为管理员**；同时创建同名翼龙用户（密码 = 用户名），成功与否写入 `PteUserCreated`。邮件确认链路 `/reg/confirm/:key`（`email.ConfirmKey`）仍存在，但**当前没有任何代码调用 `email.ConfirmRegister` 去发送确认邮件**，即注册后不会发信。
2. **下单**：`/new-order?specID=` → `orderform.SellCreate` 计算原价/折后价（支持试用 3 天、月、季、年；`TotalDiscount` 关闭时强制不打折）→ 302 到 `/order/:orderID`。
3. **支付**：`orderform.SellPaymentCheck`（KEY 支付）或 `SellPaymentCheckByBalance`（余额支付）→ 调翼龙 `CreateServer` → 若失败则回滚已写数据 → 写 `WareEntity`（含 `ValidDate`、`HostName`）→ 标记订单 `paid/confirmed` → 删除已用 KEY。
4. **续费**：`/user-console/renew/:entityID/:key`（KEY）与 `/user-console/renew2/:entity`（余额），续期基点取 `max(当前到期时间, now)`；`/user-console/reinstall/:entityID/:eggID` 重装。
5. **到期处理**：`cron` 每 5 分钟跑 `pterodactyl.CheckServers`——过期即暂停并邮件提醒；过期满 10 天写入 `DeleteConfirm` 并置 `DeleteStatus=1`；管理员在后台确认（`DeleteStatus=2`）后才真正删除服务器。续费会自动解除暂停并清理删除确认。
6. **充值**：KEY 充值（`RechargeKey`）或支付宝当面付（`/user-recharge/create-zfb` 预下单返回二维码 base64，异步通知 `/alipay` 回调加余额）。
7. **定时任务**（`internal/cron/cron.go`）：1m 刷新商品缓存、5s 刷新服务器状态、5m 巡检服务器与缓存 Nest/Egg、30m 清理过期 KEY、30s 累加用户在线时长。

### 缓存约定

- **翼龙 API 层**：`internal/pterodactyl/api_manager.go` 用 `gcache`（ARC，128 项，1~3 分钟过期）缓存 Nest/Egg/Server 查询结果，键形如 `NEST<id>`、`NEST<id>EGG<id>`、`ALLEGGS<nestID>`、`SERVER<id>`；并用容量 4 的 channel 信号量 `pool` 限制并发请求。改动翼龙数据后若发现读到的仍是旧值，先考虑这层缓存。
- **控制器层**：`WareSellerController` 的 `wares1/2/3`（按月/季/年分桶）、`UserConsoleController` 的 `entityMap`、`EggsMap` 都是**包级变量**，由 `RefreshWareInfo()` / `RefreshServerInfo()` / `CacheNeededEggs()` 定时或启动时重建。**不要在请求处理路径上直接修改这些变量**，需要刷新就调用对应函数。

## 5. 开发指南

### 环境与运行

```bash
go build ./...                 # 编译校验（当前无任何测试文件）
go run main.go                 # 本地运行，需在仓库根目录
make linux-amd64               # 交叉编译到 build/
docker-compose up -d           # 完整环境（mysql:5.7 + redis + peo）
docker-compose -f docker-compose-debug.yml up -d   # 调试：映射 8091 并暴露 8088 管理端口
```

- 首次运行会在 `conf/` 下生成默认配置；**必须修改 `conf/settings.toml` 里的 MySQL / Redis 连接信息**后再启动。
- 管理员后台（Beego Admin）监听 `8088`，`api/router.go` 中硬编码开启。
- 生产构建注入版本信息：`-ldflags "-s -w -X 'main.GO_VERSION=$(go version)' -X 'main.BUILD_TIME=..."`，最终显示在设置页。

### 修改代码时的检查清单

- **新增页面**：控制器 + `views/Xxx.html` + `api/router.go` 注册 + 在控制器里设置 `TplName` / `u` / `i` + 文案加进三个 `conf/locale/*.ini`（键名风格：`navbar.*`、`ware.*`、`auth.*`、`renew_limit` 等）。
- **新增字段/模型**：先改 `gorm_models.go` 并加入 `AutoMigrate`；`WareSpec` 的字段若需要表单可配置，还要同步 `internal/controllers/new_ware_controller.go` 的 `wareInfo`（`InputField` 列表）与 `NewWare.html`。
- **新增配置项**：同步 `conf/settings.toml`、`admin_settings_controller.go`（`Post()` 与 `getSettings()`），必要时同步 `conf/embed.go` 内嵌文件。
- **新增定时逻辑**：加到 `internal/cron/cron.go` 的 `LoopTasksManager()`，并注意与已有任务的重入/耗时。
- **文案**：所有面向用户的字符串走 i18n；现有代码中仍有少量硬编码中文（如 `user_settings_controller.go`、`email` 包），修改到相关位置时优先改为 `tr(...)`。
- **样式/资源**：模板引用路径为相对路径（如 `../static/...`），主题是 `static/perfect`（Bootstrap + Perfect 后台模板）；公共片段放 `views/tpls/`。

### 约定与雷区

- 采用 `gofmt` 标准格式；无 lint/CI 检查，CI 只构建 Docker 镜像并推送到仓库。
- 提交信息风格：`add: ...` / `update: ...` / `remove: ...` / `fix` 描述，或直接版本号（如 `v0.2.6`）。当前分支为 `master`。
- `jinzhu/gorm` 的 `RecordNotFound()` 是主要判空手段，新增查询请保持风格一致。
- `pterodactyl.NewClient` 里对 `strings.TrimRight` 的返回值未赋值（URL 末尾斜杠不会真正被去掉），调用方应自行保证 `PterodactylHostname` 无尾斜杠——`ReloadConfig()` 已经处理。
- `internal/cryptoo.DeleteOutdatedKeys()` 的充值 KEY 清理循环错误地复用了 `keys` 变量，属于已知缺陷。
- `internal/email/mail_confirm.go` 的 `ConfirmKey()` 用 `keyInfo.ID`（却是 `RegConfirmKey` 自身主键）去查用户，应用 `keyInfo.UserID`，属于已知缺陷。
- `sendConfirmMail`/`SendCaptcha` 连接 SMTP 失败时会 `panic`（`sendConfirmMail`），或忽略发送错误（`SendCaptcha`），改动邮件逻辑时留意。
- 妥善处理金额与时间：价格字段（`PricePerMonth`/`Balance`/`FinalPrice`）是无单位的整数 `uint`，折扣按 `0.01 * (100-Discount) * Price` 的百分比方式计算，不做货币换算；时长字段是 `time.Duration`，价格只在 `ValidDuration` 为 3/30/90/365 天时被计算（3 天试用价硬编码为 1，其它值下单价格为 0），而首页商品缓存 `RefreshWareInfo()` 只按 30/90/365 天分桶，因此 3 天试用商品不会出现在商品列表中，只能通过 `/new-order?specID=` 直接下单。
- 模板与 `static` 会被复制进镜像；修改后需重新构建镜像或在本地确保工作目录正确。
