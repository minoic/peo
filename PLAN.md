# PEO 控制台接入 Panel 2.0 官方扩展

## 1. 已确定的架构

- 使用官方 Panel 2.0 扩展机制，不维护 Panel fork、不修改核心源码。
- 参考源码位于 `D:\code\panel`；扩展放在 `pterodactyl/peo-panel-extension`，部署配置沿用 `pterodactyl/deploy/docker-compose.yml`。
- 本地联调目标为 `http://localhost:8088`，Compose 当前固定 `v2.0.0-beta.2`；构建和测试需固定同版本源码。
- 仅使用一个管理员 **Application API Token**，复用 PEO 的 `PterodactylToken` 配置。Token 只保存在 Go 后端，不下发浏览器。
- PEO 校验登录、管理员身份和实例归属，再调用扩展。取消签名委派、用户 Client Key 和面板会话依赖。
- 普通用户不再获得 PEO 中的面板入口；Panel 自身的登录能力保持原样，管理员可以继续访问。

## 2. Panel 扩展

### 认证与接口

使用官方 Application 扩展路由，前缀为：

`/api/application/extensions/peo-bridge/v1`

沿用 Panel 管理员 Token 验证。根据本地源码，该类扩展路由要求 Application Key 对全部资源具有相应读写权限，部署文档和连接自检明确检查这一条件。

提供以下接口组：

- `capabilities`：扩展版本、协议版本和支持能力。
- `servers/{uuid}`、`resources`：实例详情、状态和资源限额。
- `power`、`command`、`websocket`：电源、命令及实例级 Wings 凭证。
- `files/...`：文件操作和上传下载地址。
- `backups/...`：备份全流程。
- `startup/...`：变量、启动命令及允许的镜像。

扩展只暴露明确的操作白名单，不接受任意上游 URL、控制器名称或 API 路径。

### 业务边界

- 复用 Panel 的操作服务、校验和状态限制；扩展负责适配管理员调用场景，不通过简单调用控制器来绕过其请求验证。
- Startup 仍只允许修改用户可见、可编辑的 Egg 变量，以及 Egg 允许的镜像；不暴露管理员任意修改启动命令和资源限额的能力。
- 文件和备份资源必须属于路径指定的服务器，暂停、安装、恢复、锁定和配额限制继续生效。
- Wings 凭证绑定单个实例；WebSocket 权限取服务器所有者权限并排除管理员专用能力，不把管理员权限凭证交给浏览器。
- 扩展提供后端包、自动化测试和 `.pteroext` 发行包；不需要 Panel 前端页面。

## 3. PEO 后端与前端

### 授权和传输

每个新接口均先复用实例归属校验：普通用户只操作自己的实例，PEO 管理员沿用跨实例权限。Panel UUID 由后端根据现有实例映射取得，不由浏览器决定。

在 `/api/v1/servers/:id/` 下新增控制台元数据、资源、电源、命令、文件、备份和 Startup 接口，保持现有详情响应兼容。

- 浏览器只连接 PEO，文件流和 WebSocket 由 Go 转发。
- WebSocket 使用认证 POST 获取的 30 秒单次票据，校验 Origin；支持上游凭证续期、断线重连和退出释放。
- 管理员 Token、Wings 凭证及带签名地址不得进入前端响应或日志。
- 上传下载流式处理，支持进度与取消；传输目标仅允许来自可信 Panel 的节点或备份存储地址。
- 上游失败映射为明确错误，不将连接失败误报为服务器停止。

### 页面范围

保留现有服务器列表，将 `/servers/:id` 扩展为可深链接的标签页：

| 标签 | 功能 |
|---|---|
| 控制台 | ANSI 日志、命令历史、启动、停止、重启、强停和资源监控 |
| 文件 | 浏览、上传下载、新建、文本编辑、移动、复制、删除、压缩解压和权限修改 |
| 备份 | 列表、创建、进度、下载、锁定、删除和恢复 |
| 启动配置 | 启动命令预览、环境变量及允许的运行镜像 |
| 实例管理 | 原有续费、重装、删除申请及只读套餐资源 |

复用项目主题、PeoApi、模型生成和 Cubit 分层。文本编辑默认上限 2 MiB，图表保存当前会话最近 5 分钟数据；破坏性操作确认后执行，恢复备份要求先停止实例。

### 关闭普通用户面板交接

- 移除导航、账号页等普通用户入口。
- 关闭普通用户调用 `/user/pterodactyl-session` 的能力，不能只隐藏按钮。
- 管理员使用独立面板链接和 Panel 自身登录，不依赖旧会话 Cookie 交接。
- 不在本次实现中禁止用户直接登录 Panel，也不删除现存 Panel 账号或密码数据。

## 4. 2.0 兼容与统一部署

- 当前 PEO 依赖 Nest 接口，必须同步适配 2.0 的 Egg/Tag 接口，覆盖商品模板、购买开服和重装。
- 商品配置增加 Tag slug，保留旧 Nest 字段用于迁移；依据 `legacy_nest_id` 生成映射，无唯一映射时要求管理员重新选择，不自动猜测。
- Tag 只作为模板分类，重装继续限制在商品允许的 Egg 范围内。
- 发布官方固定版本 Panel 加扩展的配套镜像，并在 Compose 中使用明确的版本标签。
- 使用 2.0 镜像自带的队列、调度能力，避免重复启动；数据库迁移作为明确部署步骤执行。
- 保留现有扩展数据卷，安装流程必须在卷已存在和全新部署两种情况下均能安装、启用正确版本，不能只在镜像中复制文件。
- 不兼容或未启用扩展时，新控制台显示配置错误和重试入口；普通用户不回退到面板跳转。

## 5. 实施顺序与验收

1. **先完成扩展与最小联调**：管理员 Token 认证、实例状态、电源、终端、一次上传下载和一个 Startup 变量。
2. **完成 2.0 业务适配**：商品模板读取、购买开服、重装范围和旧 Nest 映射。
3. **完成全部页面与备份**：接入完整功能及危险操作确认。
4. **完善发行与契约**：扩展包、镜像、Compose、配置自检及 API/路由/数据文档。

实现与相关测试按项目要求委派给 `development_assistant`，主代理负责审查和联合验证。

验收包括：

- 未登录、跨用户实例和跨实例文件/备份访问被拒绝；普通用户无法取得面板会话。
- 管理员 Token 不泄露；无效 Token、权限不足和扩展禁用有明确错误。
- 暂停、安装、变量只读、备份配额与锁定限制有效。
- 终端续期重连、上传取消、备份恢复、注销及页面退出正确释放连接。
- 现有续费、购买、开服、重装和删除申请回归通过。
- 完成 Panel 扩展测试、Go 测试、Flutter 分析、相关测试及 WASM 构建，并用真实 Wings 测试实例验证核心流程。

## 实施与验证状态（2026-10-19）

- 已完成 Go Panel 2 Egg/Tag 与 legacy Nest 映射、商品 `allowedEggIds`、控制台 API/文件/备份/Startup/终端代理，以及配置自检和契约文档实现。扩展契约测试覆盖空文件、缺失/非字符串内容和 Panel 2 备份列表响应；本地扩展包/doctor 检查通过。
- 已通过 `server` 下 `go test ./...`、`go vet ./...`，以及 Flutter `dart analyze` 和 WASM 构建。终端票据、授权、Origin、注销、文件路径及代理行为有模拟/单元测试覆盖。
- 已在本地 Panel 2 + WSL Wings 和真实 Flutter Web 完成匿名/跨 owner 拒绝、console 深链接刷新、文件 CRUD/复制/权限/压缩、空文本保存回读、Startup allowlist、备份列表/配额/锁定及恢复。8 MiB 上传下载 SHA 一致；API取消上传不留半文件、取消下载后连接可完成；262.5 MiB 备份的UI下载取消后控件恢复且Refresh成功。64 MiB UI上传在自动取消操作前已完成，因此UI上传取消未验证。
- 样例 `PEO Console Demo` 属于现有 `demo_admin`，PEO entity `6ad476adf409be01f1bc1979` / Panel server ID 1。Egg 15 的本地 Shell installer 使用 Alpine `ash` 写入 `/mnt/server`，启动后提供持续运行的 `help`、`version`、`status`、`say`、`stop` 命令循环。通过 PEO 商品重装接口成功重装并读回生成文件；清除了样例自己的 Paper/UI测试残留。850B Shell 备份恢复真实回滚了 `sample.txt` 修改，旧275MB测试备份已删除。修正Egg停止命令为 `stop` 后，真实 stop、start、restart 均完成，当前实例处于 running。真实浏览器已验证日志换行、`help`/`version`/`say` 回显、断线重连、离页关闭连接与注销后旧JWT拒绝，详见 `docs/CONSOLE-ACCEPTANCE.md`。
- 本地 Panel APP_URL 与 PEO 主机地址统一为 `http://192.168.2.208:8088`，以匹配 WSL Wings 的 remote；本地 health 与 Panel URL 返回200。扩展为owner签发明确且最小的 `websocket.connect`，真实终端101和日志已验证；同一连接跨十分钟凭证周期后仍收到命令输出。详细UI/API边界及运行恢复说明见 `docs/CONSOLE-ACCEPTANCE.md`。
- 用户确认配套镜像已发布为 `minoic/peo:panel-2.0.0-beta.2-peo.1`；Compose 默认使用该标签，也可通过 `PEO_PANEL_IMAGE` 选择其他标签。按用户决定不固定 digest。此已发布镜像不含此次本地空文件、备份列表与owner终端权限修复；本地配套镜像和扩展包已更新，未推送新镜像。构建/发布新标签的命令见验收记录。
