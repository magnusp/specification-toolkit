FROM alpine:3 AS builder
WORKDIR /go/src/app

ARG OASDIFF_VERSION=1.10.23
ARG VACUUM_VERSION=0.12.1

RUN apk --no-cache add bash wget tar

RUN mkdir -p /tmp/oasdiff && \
    wget -qO- https://github.com/Tufin/oasdiff/releases/download/v${OASDIFF_VERSION}/oasdiff_${OASDIFF_VERSION}_linux_amd64.tar.gz | tar xvz --directory /tmp/oasdiff && \
    mv /tmp/oasdiff/oasdiff /usr/local/bin/oasdiff && \
    chmod +x /usr/local/bin/oasdiff && \
    rm -rf /tmp/oasdiff

RUN mkdir -p /tmp/vacuum && \
    wget -qO- https://github.com/daveshanley/vacuum/releases/download/v${VACUUM_VERSION}/vacuum_${VACUUM_VERSION}_linux_x86_64.tar.gz | tar xvz --directory /tmp/vacuum && \
    mv /tmp/vacuum/vacuum /usr/local/bin/vacuum && \
    chmod +x /usr/local/bin/vacuum && \
    rm -rf /tmp/vacuum


FROM alpine:3
RUN apk --no-cache add bash

COPY --from=builder /usr/local/bin/oasdiff /usr/local/bin/oasdiff
COPY --from=builder /usr/local/bin/vacuum /usr/local/bin/vacuum
