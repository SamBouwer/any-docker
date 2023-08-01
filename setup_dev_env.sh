#! /bin/bash
# This script installs all packages and dependencies required to build Anytype nodes and clients. 
# Run this script at least once before using the scripts or make commands to build your own nodes and/or clients.

while getopts v: flag
do
    case "${flag}" in
        v) GOLANG_VER=${OPTARG};;
    esac
done
echo "GOLANG VERSION: $GOLANG_VER";

wget -N https://go.dev/dl/go${GOLANG_VER}.linux-amd64.tar.gz

if [ -d "go1.19.11.linux-amd64.tar.gz" ] ; then
  tar -C /usr/local -xzf /home/bouwers/go${GOLANG_VER}.linux-amd64.tar.gz
fi

#Add directories to variables

export GOPATH=$HOME/go >> ~/.bashrc
export GOROOT=/usr/local/go >> ~/.bashrc
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin >> ~/.bashrc
export ANDROID_SDK_ROOT=/usr/lib/android-sdk >> ~/.bashrc
export ANDROID_HOME=/usr/lib/android-sdk >> ~/.bashrc
export PATH=$ANDROID_HOME/cmdline-tools/bin:$PATH >> ~/.bashrc

source ~/.bashrc

go version
echo $'\U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191 \U2191'
echo "go version printed above should return 'go version go${GOLANG_VER} linux/amd64'"
read -p "Press Enter if the go version is correct or CTRL+C to cancel" </dev/tty

sudo dpkg --add-architecture i386 

set -eux; \
        sudo apt-get update; \
        sudo apt-get install -y --no-install-recommends \
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
                docker-ce \
                docker-ce-cli \
                containerd.io \
                docker-buildx-plugin \
                docker-compose-plugin \
        ; \
        sudo rm -rf /var/lib/apt/lists/*
