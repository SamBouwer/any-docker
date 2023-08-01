#! /bin/bash
# This script installs all packages and dependencies required to build Anytype nodes and clients. 
# Run this script at least once before using the scripts or make commands to build your own nodes and/or clients.

echo ""
echo "-=[ Setting up development environment for building anytype nodes and clients ]=-"
echo ""

while getopts v: flag
do
    case "${flag}" in
        v) GOLANG_VER=${OPTARG};;
    esac
done

GOLANG_VER_INSTALLED=$(go version)
if [ GOLANG_VER_INSTALLED = "go version go${GOLANG_VER} linux/amd64" ] then
  echo "Go is already installed, skipping"
fi

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

sudo dpkg --add-architecture i386 

set -eux; \
        sudo apt-get update; \
        sudo apt-get install -y --no-install-recommends \
                git \ # needed for downloading dependencies from git repositories
                openssl \ # needed to create certificates to communicate securely with remote servers to download files
                protobuf-compiler \ # needed for building middleware libraries
                libprotoc-dev \ # needed for building middleware libraries
                android-sdk \ # needed for building middleware libraries for Android
                unzip \ # needed for unzipping downloads
                npm \ # needed for building the desktop client
                libsecret-1-dev \ # needed for ...
                jq \ # needed for ...
                wine \ # needed for building the desktop client for Windows
                wine32 \ # needed for building the desktop client for Windows
                docker-ce \ # needed for building and running docker images
                docker-ce-cli \ # needed for building and running docker images
                containerd.io \ # needed for building and running docker images
                docker-buildx-plugin \ # needed for building and running docker images
                docker-compose-plugin \ # needed for building and running docker images
        ; \
        sudo rm -rf /var/lib/apt/lists/*
