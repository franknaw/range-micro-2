# Multi-stage dockerfile
# golang alpine 1.18.3-alpine as base image
FROM golang:1.18.3-alpine AS builder
# create appuser
RUN adduser -D -g '' appuser
# create workspace
WORKDIR /opt/app/
COPY go.mod go.sum ./
# fetch dependancies
RUN go mod download && \
    go mod verify

COPY . .
# build binary
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/range-micro-2 ./cmd/rest


# build a small image
FROM alpine:3.16
LABEL language="golang"
LABEL version="0.0.1"
LABEL description="Range Micro 2"

ENV PORT=8080
# import the user and group files from the builder
COPY --from=builder /etc/passwd /etc/passwd
# copy the static executable
COPY --from=builder --chown=appuser:1000 /go/bin/range-micro-2 /range-micro-2
# use a non-root user
USER appuser
EXPOSE $PORT
# run app
ENTRYPOINT ["./range-micro-2"]


