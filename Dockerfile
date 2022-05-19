FROM alpine

VOLUME ["/log","/conf"]
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add tzdata \
    && apk add ca-certificates \
    && update-ca-certificates
ENV TZ=Asia/Shanghai
COPY conf /conf
COPY static /static
COPY log /log
COPY views /views
COPY build/peo_linux_amd64_linux .
EXPOSE 8080

ENTRYPOINT ["/peo_linux_amd64_linux"]