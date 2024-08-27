FROM golang:1.22.2 AS builder
WORKDIR /go/src/app
# Static compilation
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/daveshanley/vacuum@v0.9.16
RUN CGO_ENABLED=0 go install -ldflags '-extldflags "-static"' github.com/tufin/oasdiff@v1.10.15


FROM alpine:3
RUN apk --no-cache add bash

COPY --from=builder /go/bin/oasdiff /usr/local/bin/oasdiff
COPY --from=builder /go/bin/vacuum /usr/local/bin/vacuum
