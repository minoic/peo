## v1.0.0

The rewrite. Business behaviour is unchanged from v0.2.7; the transport, the
storage engine and the rendering layer are new.

### 更改

- **后端框架由 Beego 更换为 Gin**，仅提供 REST/JSON 接口，不再服务端渲染。
- **存储由 gorm + MySQL 更换为 MongoDB**（官方 `mongo-driver`）。共 13 个集合；
  v0.2.x 的 `gorm.Model`、自增主键、软删除、`template.HTML` 列均被替换，详见
  [`docs/CONTRACT-DATA.md`](docs/CONTRACT-DATA.md)。
- **前端由 30 个 Beego 模板更换为 Flutter Web (WASM) 单页应用**，通过 REST API
  通信。
- **接口标识符由整数改为 24 位十六进制 ObjectID 字符串**；所有路径参数与 DTO 中
  的 id 均为字符串。
- **认证由 Beego 加密 cookie 更换为 JWT**：`POST /api/v1/auth/login` 返回
  `accessToken`，请求使用 `Authorization: Bearer <token>`；登出会将令牌 id 写入
  Redis 的 `JWTBLACKLIST:<jti>`。`X-Auth-*` 头已移除。
- 服务端单进程同时提供 API 与前端静态资源，**同源部署，无需 CORS**。
- 新增 `GET /healthz` 存活探针，检查 Mongo、Redis 与翼龙面板连通性。
- 管理员设置项以 JSON schema 下发，前端据此通用渲染，无需重复维护字段定义。
- `RechargeLog.Status` 由渲染后的 Bootstrap 标签改为枚举
  `pending` / `success` / `failed` / `invalid`。
- 「修改邮箱」的确认接口由 `{code}` 改为 `{email, code}`：邮件验证码按邮箱地址
  存储（与旧版一致），而匿名/无状态调用需要显式提供地址。

### 移除

- 多语言（`beego/i18n`，原 zh-CN / en-US / de-DE）。接口仅返回英文。
- 图形验证码（`beego/captcha`）。改由 Redis 计数限流承担，键族见
  [`docs/ARCHITECTURE.md` §6](docs/ARCHITECTURE.md)。
- 旧的 Beego 管理服务端口 8088。
- `PEAdminSetting` 模型（旧版中从未被读写）。

### 保持不变的

- 支付渠道与流程（支付宝当面付 + 扫码），包括 `OutTradeNo` / `Code` 幂等约定。
- 翼龙面板 API 端点、请求体，以及面板侧密码初始化方式。
- 删除状态机：到期 → 暂停并邮件通知 → +10 天 → 用户确认 → 管理员批准删除。
- 折扣算法、试用商品路径（3 天，定价 1，不对外展示）。
- 除上述验证码替换外，全部 Redis 键族与限流语义。
- 邮件触发时机与模板。

### 修复

- 充值 KEY 清理时复用了错误的切片变量。
- 邮件确认按自身主键而非 `UserID` 查询用户。
- 翼龙客户端未使用 `strings.TrimRight` 的结果，导致 URL 残留结尾 `/`。
- 发送确认邮件失败时发生 panic，现改为返回错误。
- 验证码邮件发送失败时不再残留限流键：旧版吞掉发送错误后仍写下键，导致该地址
  在键的整个存活期内无法重试（`redis.Release` 回收刚写入的键）。
- 通知类邮件不再被方括号包裹：旧版对切片调用 `fmt.Sprint`，渲染为 `[a b c]`，
  现按调用方的片段拼接。
- 控制器层缓存无同步写入造成的竞态，现由带 `sync.RWMutex` 的服务层缓存持有。
- 面板账号识别：由数据库 id 改为用户名，与旧版一致（包含 `RootAdmin`、
  `ExternalId`、面板服务器命名与 `OOMDisabled` 等）。
- **修改站点密码时同步轮换翼龙面板密码**：旧版会调用
  `pterodactyl.ChangePassword` 并更新缓存的 `pterodactylPasswords`，端口此前遗漏
  了该步骤，导致面板上仍可使用旧密码。面板账号尚未创建时跳过该调用，而不是在
  站点密码已写库后返回一个永远无法消除的错误（见 `docs/ARCHITECTURE.md` §11 (s)）。
- **补回丢失的通知**：注册成功与面板账号创建结果、管理员提示、修改密码、修改邮箱、
  续费时面板描述同步失败，以及确认注册时的面板账号结果，均恢复为旧版的触发时机
  与文案（见 `docs/ARCHITECTURE.md` §11 (t)）。

> **破坏性更改**：v1 不读取旧 MySQL 数据库，也不提供迁移路径，部署后从空库开始。

## v0.2.7

### 功能

- 管理员用户列表页
- 管理员已完成订单列表页

### 更改

- 在设置中指定 Redis DB 编号 #31
- 在设置中指定 Redis 密码 #30

## v0.2.6

### 修复

- api调用过于频繁问题，添加缓存
- 已使用 fonts.loli.net 替换 fonts.googleapis.com
- 获取无效服务器信息崩溃问题 #22

## v0.2.5

### 修复

- 设置修改页面支付宝开关未能更改问题
- 订单支付时，服务器创建失败问题

### 更改

- 首页标题处显示管理员设置页面设置的标题和描述

## v0.2.4

### 修复

- 多语言模板渲染失败问题
- 找回、更新邮箱、注册确认的验证问题 #19
- 邮箱用户名无法设置问题

## v0.2.3

### 功能

- 多语言功能，目前支持 zh-CN, en-US, de-DE，且默认语言改为 en-US‘

### 修复

- 二进制文件运行时无法找到配置文件问题 #20

## v0.2.2

### 修复

- XSRF检测

## v0.2.1

### 功能

- 跳转翼龙面板时自动登录。

### 更改

- 支持自定义社区链接与标题

### 修复

- 频繁 API 调用导致翼龙面板占用高。
- 自动去除配置文件结尾的'/'

## v0.2.0

### 功能

- 主页显示备份数量。
- 添加管理员设置页面，可在 web ui 更改设置与查看编译信息。

### 移除

- 翼龙 API 缓存系统。
- 本地日志文件支持。
- 对除 redis、mysql 以外的数据库的支持。

### 更改

- 延长 minecraft 信息获取超时时间。
- 跳转页面不再显示 URL。
- **破坏性更改**：配置文件字段更改，系统尝试自动转换，更新失败代价为重新填写配置，对数据库无任何影响。

### 修复

- 修复：管理员页面大图标显示。

