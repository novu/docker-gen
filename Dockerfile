FROM golang:latest as builder
RUN go get github.com/robfig/glock
COPY GLOCKFILE ./
RUN glock sync -n < GLOCKFILE
COPY . ./
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-X main.buildVersion=novu"  -o docker-gen ./cmd/docker-gen
FROM scratch
COPY --from=builder /go/docker-gen ./docker-gen
ENTRYPOINT ["./docker-gen"]
