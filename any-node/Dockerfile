# Note: this Dockerfile installs all dependencies to build the docker images required to run an Anytype node
# TODO
# * Use any-sync-tool with Dockerfile ARG's from ENV file to create any-sync-network yaml configuration files

ARG GOLANG_VER

## BUILD COORDINATOR ##

FROM golang:$GOLANG_VER-bullseye as any-sync-coordinator
MAINTAINER Sam Bouwer (bouwer.it)

# ENV vars for any-sync-tools to create a new network with 'any-syc-network create'

ENV any-sync-coordinator-node-address=172.18.0.2:4830
ENV mongo-connect-uri=mongodb://mongorootuser:mongorootpassword@172.18.0.6:27017
ENV mongo-database-name=coordinator
ENV any-sync-node-address=172.18.0.3:4430
ENV any-sync-file-node-address=172.18.0.4:4730
ENV s3-endpoint=http://172.18.0.5:9000
ENV s3-region=eu-central-1
ENV s3-profile=default
ENV s3-bucket=any-sync-files
ENV redis-url=redis://172.18.0.8:6379/?dial_timeout=3&db=1&read_timeout=6s&max_retries=2
ENV is-cluster=false

# Install dependencies

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                git \
                openssl \
                protobuf-compiler \
                libprotoc-dev \
                unzip \
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
COPY ../any-sync/coordinator.yml .

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
COPY ../any-sync/startup_coordinator.sh .
RUN chmod -R 700 ./startup_coordinator.sh
EXPOSE 4830
CMD ["/bin/bash","-c","./startup_coordinator.sh"]


## BUILD SYNC NODE ##

FROM golang:$GOLANG_VER-bullseye as any-sync-node
MAINTAINER Sam Bouwer (bouwer.it)

# Build any-sync-node
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-node
WORKDIR /anytype/any-sync-node
RUN make deps
RUN make build
WORKDIR /anytype/any-sync-node/bin
RUN chmod +x any-sync-node

WORKDIR /anytype
COPY ../any-sync/sync_1.yml .
RUN mkdir -p /anytype/db

# Run startup script
WORKDIR /anytype
COPY ../scripts/startup_node.sh .
RUN chmod -R 700 ./startup_node.sh
EXPOSE 4430
CMD ["/bin/bash","-c","./startup_node.sh"]


## BUILD SYNC FILENODE ##

FROM golang:$GOLANG_VER-bullseye as any-sync-filenode
MAINTAINER Sam Bouwer (bouwer.it)

# Build any-sync-filenode
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-filenode
WORKDIR /anytype/any-sync-filenode
RUN make deps
RUN make build
WORKDIR /anytype/any-sync-filenode/bin
RUN chmod +x any-sync-filenode

WORKDIR /anytype
COPY ../any-sync/file_1.yml .

# Run startup script
WORKDIR /anytype
COPY ../scripts/startup_filenode.sh .
RUN chmod -R 700 ./startup_filenode.sh
EXPOSE 4730
CMD ["/bin/bash","-c","./startup_filenode.sh"]
