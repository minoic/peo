# peo 架构与开发约定

本文说明当前系统的组成，以及新增或修改功能时应遵循的边界。它描述代码现状，不是迁移计划。具体接口和数据字段以对应代码与 `docs/` 中的契约文档为准。

除非任务明确要求，不要修改本仓库目录以外的文件，也不要执行有破坏性的命令或操作。

## 项目组成

peo 为 Pterodactyl Panel 提供 Minecraft 主机销售和管理功能。系统由 Go 服务、Flutter Web 单页应用和外部依赖组成：

- `server/`：Go 模块 `github.com/minoic/peo/server`。使用 Gin 提供 REST API，并在生产构建中提供 Flutter Web 静态资源。
- `flutter/`：Flutter Web 应用，编译为 WASM，在浏览器中运行。
- `docs/`：系统架构、REST API、路由和数据契约。
- MongoDB：保存用户、商品、订单、服务器实例、消息等业务数据。
- Redis：保存短期状态，例如访问限流、邮件验证码及 JWT 注销黑名单；业务主数据保存在 MongoDB。
- Pterodactyl：外部面板 API，用于商品资源查询和服务器实例管理。
- SMTP、Alipay：分别用于邮件通知和充值支付。

浏览器与 API 在生产环境中由同一 Go 服务、同一来源提供。服务监听 `:8080`；`/api/v1/...` 是 REST API，`/healthz` 是健康检查，其余前端路径由 Flutter SPA 处理。静态资源优先从 `server/web` 嵌入的构建产物提供，开发环境可从磁盘读取。

## 服务启动与生命周期

`server/cmd/peo/main.go` 负责组装和关闭进程：

1. `config.Init()` loads embedded defaults and MongoDB environment variables. `store.Init()` connects to MongoDB, then the process loads or seeds the business settings document before starting cron or HTTP.
2. MongoDB indexes are ensured, and the Redis client is created lazily.
3. 注册并启动 `cron` 周期任务，执行启动所需的缓存预热。
4. 创建 API/静态资源路由并启动 HTTP 服务。
5. 收到关闭信号后停止接收 HTTP 请求、等待任务结束并释放存储连接。

新增后台任务应放在 `server/internal/cron`，使用有界的 context，并纳入调度器的启动和关闭生命周期。

## Go 后端结构与依赖方向

```text
server/
├── cmd/peo/                 进程入口和依赖组装
├── web/                     Flutter Web 嵌入资源
└── internal/
    ├── api/                 Gin 路由、处理器、DTO、SPA 静态资源
    ├── apierr/              API 错误类型和 JSON 响应封装
    ├── auth/                JWT 签发与解析
    ├── buildinfo/           构建版本信息
    +-- config/              embedded defaults, MongoDB business settings, Alipay client
    ├── cron/                周期任务
    ├── middleware/          认证、管理员校验、CORS、日志和 panic 恢复
    ├── models/              MongoDB 文档类型和集合名
    ├── redis/               Redis 客户端及短期键操作
    ├── service/             业务逻辑及其外部服务客户端
    └── store/               MongoDB 连接、索引和数据访问
```

请求处理遵循以下方向：

```text
Gin router → handler / DTO → service → store / models
                              ├── Redis
                              ├── Pterodactyl
                              ├── SMTP
                              └── Alipay
```

- `api` 负责 HTTP 边界：解析和校验输入、取得中间件提供的身份、调用 service、编码响应。业务规则不放在 handler 中；handler 不直接访问 `store` 或 MongoDB 驱动。
- 请求和响应结构放在 `server/internal/api/dto`。部分共享响应数据类型由 service 定义；修改响应前先检查现有类型及 `docs/API.md`。
- `service` 接受普通参数并返回普通结果，不直接依赖 Gin 或请求上下文。用 `apierr` 的类型表达可返回给客户端的错误；不要在 service 中写 HTTP 响应。
- `store` 负责 MongoDB 操作，返回 `models` 类型和可识别的错误。Mongo 查询细节及 BSON 临时结构留在此层，不向 handler 暴露。
- `models` 定义文档和集合名。Mongo `_id` 与关联 ID 使用 ObjectID；HTTP 边界上的 ID 使用 24 位十六进制字符串，并在边界解析。
- `middleware` 是读取传入 `Authorization` 头和建立请求用户身份的地方。处理器通过 middleware 的访问方法取得当前用户；管理员路由必须同时应用认证和管理员校验。
- Business settings are loaded from and saved to MongoDB. Mongo connection settings come from environment variables; a save rebuilds dependent clients such as Redis.

标准 API 成功响应为 `{ "ok": true, "data": ... }`，失败响应为 `{ "ok": false, "error": { "code": ..., "message": ... } }`。健康检查、Alipay 回调和文件下载等特殊响应按 `docs/API.md` 及现有处理器实现。新增错误使用 `apierr` 中的错误码和响应流程。

## 身份验证、数据和共享状态

- 客户端发送 `Authorization: Bearer <token>`。JWT 的签发和解析由 `internal/auth` 负责；强制认证中间件校验令牌、注销黑名单并重新读取关联用户，可选认证中间件允许匿名访问；授权依据是用户文档中的当前权限。
- `/api/v1` 路由按公开、已登录和管理员访问范围分组。Alipay 通知由支付服务校验签名；新增公开写操作时应明确其认证和校验边界。
- MongoDB 文档基类 `models.Doc` 持有 ObjectID、`createdAt` 和 `updatedAt`。数据访问层负责写入时间戳；新增集合或查询模式时，同步维护 `store.EnsureIndexes()` 所需的索引定义。
- Redis 用于有过期时间的短期状态。新增或调整 Redis 键时，应统一键名、TTL、写入和读取位置，并确认对限流、支付幂等或注销行为的影响。
- 商品目录、实例状态和面板响应使用缓存。缓存读写应遵循各自 service 的锁和更新入口；不要绕过 `sync.RWMutex`、`sync.Map` 等已有同步机制直接改共享状态。
- 订单、支付、续费、实例生命周期、邮件触发和限流都属于已有业务规则。扩展相关功能时沿用现有 service 的计算、状态流转和幂等处理；只有任务明确要求时才改变已有行为。

## Flutter Web 结构

```text
flutter/lib/
├── api/       Dio 客户端、令牌存储、错误映射和 PeoApi 端点封装
├── models/    API DTO 的 Freezed / JSON 序列化类型
├── pages/     公共、用户和管理员页面
├── router/    go_router 路由和访问守卫
├── state/     按功能划分的 Cubit 状态管理
└── widgets/   页面共享组件及浏览器能力封装
```

页面通过 Cubit/Bloc 调用 `PeoApi`；端点路径和响应解码集中在 `flutter/lib/api/peo_api.dart`，通用 Dio、Bearer 令牌、响应 envelope 和 `401` 处理位于 `api_client.dart`。页面不应自行拼接 API URL 或重复实现令牌逻辑。登录状态由 session Cubit 管理，令牌通过 `shared_preferences` 持久化，路由守卫依据登录状态和管理员状态控制访问。

模型由 Freezed 和 `json_serializable` 生成。修改模型定义后重新生成对应代码，不要手动编辑 `.freezed.dart` 或 `.g.dart` 文件。

## 新增或修改功能时

1. 从相邻功能找到对应的 handler、service、store、model、Cubit 和页面，沿用项目已有结构，不要在单层堆放跨层职责。
2. 若功能改变接口，同步更新 `server/internal/api/router.go`、DTO/处理器、`docs/API.md`、`docs/CONTRACT-ROUTES.md`，以及 Flutter 的 `PeoApi`、模型和状态层。
3. 若功能改变数据结构，同步更新 `models`、store 操作、必要的索引、API 序列化和 Flutter 模型；配置项还需检查管理设置界面使用的配置 schema。
4. 保持既有响应格式、身份权限边界和业务行为；需要改变它们时，明确更新两端实现和对应契约。
5. 修改已有测试或为新行为补充与其相邻的测试，并让接口、路由、数据契约文档与实现保持一致。

详细接口以 [`docs/API.md`](docs/API.md) 为准；路由和访问控制见 [`docs/CONTRACT-ROUTES.md`](docs/CONTRACT-ROUTES.md)；MongoDB 文档与索引见 [`docs/CONTRACT-DATA.md`](docs/CONTRACT-DATA.md)；整体设计见 [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)。
