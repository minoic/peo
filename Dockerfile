# 打包依赖阶段使用golang作为基础镜像
FROM golang:1.20-alpine as builder

WORKDIR /workspace
# 启用go module
ENV GO111MODULE=on GOPROXY=https://goproxy.cn,direct

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY . .

# CGO_ENABLED禁用cgo 然后指定OS等，并go build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -gcflags "all=-N -l" -ldflags "-X 'main.GO_VERSION=$(go version)' -X 'main.BUILD_TIME=`TZ=Asia/Shanghai date "+%F %T"`'" -o entry .


FROM alpine

EXPOSE 8080
EXPOSE 8088
VOLUME ["/conf"]
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add tzdata \
    && apk add ca-certificates \
    && update-ca-certificates
ENV TZ=Asia/Shanghai
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert
COPY --from=builder /workspace/entry .

COPY static /static
COPY views /views

ENTRYPOINT ["/entry"]