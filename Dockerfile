FROM golang:alpine as builder
RUN apk update && apk add git \
    && git clone https://github.com/BalazsGyarmati/echo-ip /go/src/echo-ip
WORKDIR /go/src/echo-ip
RUN CGO_ENABLED=0 go build -a -v -installsuffix cgo -o /go/bin/echo-ip

FROM alpine:latest
COPY --from=builder /go/bin/echo-ip /echo-ip
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
EXPOSE 8080
ENTRYPOINT ["/echo-ip"]
CMD ["-p", "8080"]
