## peo

🎮用于建立翼龙面板的自动售卖系统和附加控制系统，自动化你的翼龙面板出售。

目前已在 [demo](https://order.minoic.top) 稳定运行并跟进开发版本的部署

主要用于 **Minecraft** 服务器的出售管理，暂不支持其它种类服务器的状态的信息获取 

当前适配翼龙面板 v1.7.0

[minoic/peo - Docker Image | Docker Hub](https://hub.docker.com/r/minoic/peo)

#### 特性

- [x] 登录、注册（首个用户为管理员）、找回密码、修改密码、改绑邮箱
- [x] 主页商品展示、建立订单、支持余额支付或 KEY 支付
- [x] 用户控制台：展示用户服务器信息、跳转控制台、运行时间记录、用同种 KEY 或余额自助续费
- [x] 工单系统
- [x] 用户消息通知
- [x] 用户可分享的公共相册
- [x] 管理员控制台：添加商品、整合包（Nest.Egg）、处理工单、管理相册、批量添加 KEY、导出KEY
- [x] 周期任务：刷新缓存、检测服务器过期、检测 KEY 过期
- [x] 充值系统：支持 KEY 充值或支付宝扫码支付（基于支付宝当面付 API ）
- [x] 服务器到期自动邮件提醒用户、一定时间后在管理员控制台手动确认删除
- [x] 跟进 Pterodactyl 的新版本 API
- [ ] 优化模板复用，提高渲染效率
- [ ] 添加微信支付
- [ ] 详细使用文档
- [ ] 添加微信支付、支付方式集成到订单页
- [ ] 多语言国际化
- [ ] 跳转翼龙面板时自动登录
- [ ] 修改配置存储方式为环境变量与本地数据库


如有改进建议或需求欢迎发送 Issue 或 Pull Request

#### 部署

##### 发布版本

1. 从 [release](https://github.com/minoic/peo/releases) 下载对应系统的发布软件包，解压
2. 修改`app.conf`以及`settings.conf`中的配置，主要包含redis（必要）、mysql（必要）、网站地址（必要）、邮件服务器（可选）、翼龙面板API（必要）、支付宝当面付API（可选）、缓存方式（可选）。
3. 运行可执行文件

##### Docker

1. 安装 Docker、Docker Compose
2. 下载本目录下 `docker` 文件夹（包括`docker-compose.yml`和`conf`目录）
3. mysql、redis配置已填好，修改其它需要的配置
4. 在该文件夹内打开终端，运行

```bash
docker-compose up
```

或在后台运行

```bash
docker-compose up -d
```

5. 浏览器中访问目标机器 8080 端口，如 `http://localhost:8080`

##### 网关

使用 Nginx 等软件监听 80/443 端口，配置 SSL 后设置反向代理将根目录转发到 8080 端口
