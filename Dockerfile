# TODO
# * Use any-sync-tool with Dockerfile ARG's from ENV file to create any-sync-network yaml configuration files
# * Build any-sync-node
# * Build any-sync-filenode

ARG GOLANG_VER

FROM golang:$GOLANG_VER-bullseye as any-sync-coordinator

ENV any-sync-coordinator-node-address=127.0.0.1:4830
ENV mongo-connect-uri=mongodb://localhost:27017
ENV mongo-database-name=coordinator
ENV any-sync-node-address=127.0.0.1:4430
ENV any-sync-file-node-address=127.0.0.1:4730
ENV s3-endpoint=http://127.0.0.1:9000
ENV s3-region=eu-central-1
ENV s3-profile=default
ENV s3-bucket=any-sync-files
ENV redis-url=redis://127.0.0.1:6379/?dial_timeout=3&db=1&read_timeout=6s&max_retries=2
ENV is-cluster=false

MAINTAINER Sam Bouwer

# Install dependencies

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                git \
                openssl \
        ; \
        rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:$PATH

ENV GOPATH /go

ENV PATH $GOPATH/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

# Create config with any-sync-tool
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-tools
WORKDIR /anytype/any-sync-tools
RUN go install ./any-sync-network
# Instead of running "any-sync-network create" in startup script, just copy the files that should be created in advance
WORKDIR /anytype
COPY coordinator.yml sync_1.yml file_1.yml heart.yml .

# Build any-sync-coordinator
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-coordinator
WORKDIR /anytype/any-sync-coordinator
RUN make deps
RUN make build
WORKDIR /anytype/any-sync-coordinator/bin
RUN chmod +x any-sync-coordinator

# Run startup script
WORKDIR /anytype
COPY startup.sh .
RUN chmod -R 700 ./startup.sh
CMD ["/bin/bash","-c","./startup.sh"]

FROM golang:$GOLANG_VER-bullseye as any-sync-node

# Build any-sync-node
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-node
WORKDIR /anytype/any-sync-node
RUN make deps
RUN make build
WORKDIR /anytype/any-sync-node/bin
RUN chmod +x any-sync-node

# Run startup script
WORKDIR /anytype
COPY startup.sh .
RUN chmod -R 700 ./startup.sh
CMD ["/bin/bash","-c","./startup.sh"]

FROM golang:$GOLANG_VER-bullseye as any-sync-filenode

# Build any-sync-filenode
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-filenode
WORKDIR /anytype/any-sync-filenode
RUN make deps
RUN make build
WORKDIR /anytype/any-sync-filenode/bin
RUN chmod +x any-sync-filenode

# Run startup script
WORKDIR /anytype
COPY startup.sh .
RUN chmod -R 700 ./startup.sh
CMD ["/bin/bash","-c","./startup.sh"]
