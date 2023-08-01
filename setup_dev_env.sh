#! /bin/bash
# This script installs all packages and dependencies required to build Anytype nodes and clients. 
# Run this script at least once before using the scripts or make commands to build your own nodes and/or clients.

wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz

tar -C /usr/local -xzf /home/bouwers/go1.19.11.linux-amd64.tar.gz

#Add directories to variables

export GOPATH=$HOME/go >> ~/.bashrc
export GOROOT=/usr/local/go >> ~/.bashrc
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin >> ~/.bashrc
export ANDROID_SDK_ROOT=/usr/lib/android-sdk >> ~/.bashrc
export ANDROID_HOME=/usr/lib/android-sdk >> ~/.bashrc
export PATH=$ANDROID_HOME/cmdline-tools/bin:$PATH >> ~/.bashrc

. ~/.bashrc

go version

echo "go version should return 'go version go1.19.11 linux/amd64'"

dpkg --add-architecture i386 

set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                git \
                openssl \
                protobuf-compiler \
                libprotoc-dev \
                android-sdk \
                unzip \
                npm \
                libsecret-1-dev \
                jq \
                wine \
                wine32 \
        ; \
        rm -rf /var/lib/apt/lists/*
