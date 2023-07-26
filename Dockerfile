# Note: this Dockerfile installs all dependencies, including packages like Android SDK to be able to build the docker images.
# TODO
# * Use any-sync-tool with Dockerfile ARG's from ENV file to create any-sync-network yaml configuration files

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
                protobuf-compiler \
                libprotoc-dev \
                android-sdk \
        ; \
        rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:$PATH

ENV GOPATH /go

ENV PATH $GOPATH/bin:$PATH

RUN export ANDROID_HOME=/usr/lib/android-sdk
RUN export PATH=$ANDROID_HOME/cmdline-tools/latest/tools/bin:$PATH
RUN sdkmanager --install "ndk;23.2.8568313"
RUN mkdir /usr/lib/android-sdk/ndk-bundle
RUN mv /opt/android-sdk/ndk/23.2.8568313/ /usr/lib/android-sdk/ndk-bundle/

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

# Create config with any-sync-tool
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-tools
WORKDIR /anytype/any-sync-tools
RUN go install ./any-sync-network
# Instead of running "any-sync-network create" in startup script, just copy the files that should be created in advance
WORKDIR /anytype
COPY coordinator.yml .

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
COPY startup_coordinator.sh .
RUN chmod -R 700 ./startup_coordinator.sh
CMD ["/bin/bash","-c","./startup_coordinator.sh"]

FROM golang:$GOLANG_VER-bullseye as any-sync-node

# Build any-sync-node
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-node
WORKDIR /anytype/any-sync-node
RUN make deps
RUN make build
WORKDIR /anytype/any-sync-node/bin
RUN chmod +x any-sync-node

WORKDIR /anytype
COPY sync_1.yml .

# Run startup script
WORKDIR /anytype
COPY startup_node.sh .
RUN chmod -R 700 ./startup_node.sh
CMD ["/bin/bash","-c","./startup_node.sh"]

FROM golang:$GOLANG_VER-bullseye as any-sync-filenode

# Build any-sync-filenode
WORKDIR /anytype
RUN git clone https://github.com/anyproto/any-sync-filenode
WORKDIR /anytype/any-sync-filenode
RUN make deps
RUN make build
WORKDIR /anytype/any-sync-filenode/bin
RUN chmod +x any-sync-filenode

WORKDIR /anytype
COPY file_1.yml .

# Run startup script
WORKDIR /anytype
COPY startup_filenode.sh .
RUN chmod -R 700 ./startup_filenode.sh
CMD ["/bin/bash","-c","./startup_filenode.sh"]

FROM golang:$GOLANG_VER-bullseye as any-heart

# Build any-heart inlcuding protobuf files and test dependencies
WORKDIR /anytype
RUN git clone https://github.com/anyproto/anytype-heart
COPY heart.yml .
WORKDIR /anytype/any-heart
RUN make test-deps
RUN make test
RUN make setup-protoc
RUN make protos
RUN mkdir ../anytype-ts
# RUN mkdir ../anytype-ts/dist
# RUN mkdir ../anytype-ts/dist/lib
RUN make install-dev-js ANY_SYNC_NETWORK=/anytype/heart.yml
# I don't have a machine running MacOS so I cannot setup the deps for iOS
#RUN make build-ios ANY_SYNC_NETWORK=/anytype/heart.yml
# I can't get the Android version to properly build
#RUN make build-android ANY_SYNC_NETWORK=/anytype/heart.yml
RUN make protos-java

WORKDIR /anytype/any-heart/anytype-ts
RUN chmod +x any-heart

# Run startup script
WORKDIR /anytype
COPY startup_heart.sh .
RUN chmod -R 700 ./startup_heart.sh
CMD ["/bin/bash","-c","./startup_heart.sh"]
