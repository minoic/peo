# 打包依赖阶段使用golang作为基础镜像
FROM golang:1.21.0-alpine as builder

WORKDIR /workspace

RUN apk update && apk add --no-cache upx tzdata && rm -rf /var/cache/apk/*

# 启用go module
ENV GO111MODULE=on GOPROXY=https://goproxy.cn,direct

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY go.mod go.mod
COPY go.sum go.sum
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download

COPY . .

# CGO_ENABLED禁用cgo 然后指定OS等，并go build
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -gcflags "all=-N -l" -ldflags "-s -w -X 'main.GO_VERSION=$(go version)' -X 'main.BUILD_TIME=`TZ=Asia/Shanghai date "+%F %T"`'" -o entry main.go \
    && upx -6 entry

FROM alpine

EXPOSE 8080
EXPOSE 8088
VOLUME ["/conf"]
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk --no-cache add tzdata ca-certificates libc6-compat libgcc libstdc++ curl

ENV TZ=Asia/Shanghai
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert
COPY --from=builder --chmod=777 /workspace/entry .

COPY static /static
COPY views /views

ENTRYPOINT ["/entry"]