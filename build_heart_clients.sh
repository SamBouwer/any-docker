#! /bin/bash
echo ""
echo "-=[ Building Anytype middleware and clients ]=-"
echo ""

workdir=${PWD}
workdir=${workdir:-/}

## BUILD ANYTYPE HEART LIBRARIES AND CLIENTS ##

mkdir -p anytype-clients

# Install Android SDK and cmdtools
cd /usr/lib/android-sdk
if [ ! -d "cmdline-tools" ] ; then
    sudo wget -N https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    echo "unzipping cmdtools"
    sudo unzip -qo commandlinetools-linux-9477386_latest.zip
    sudo rm commandlinetools-linux-9477386_latest.zip
    cd cmdline-tools
    sudo mkdir -p latest
    sudo mv -n bin/ latest/
else
    echo "'cmdline-tools' already installed. Skipping..."
fi
if [ ! -d "/usr/lib/android-sdk/ndk-bundle/meta" ] ; then
    echo "Installing ndk-bundle"
    sudo mkdir -p /usr/lib/android-sdk/ndk-bundle
    sudo sdkmanager --sdk_root=/usr/lib/android-sdk/cmdline-tools/latest/bin --install "ndk;23.2.8568313"
    sudo mv -n /opt/android-sdk/ndk/23.2.8568313/* /usr/lib/android-sdk/ndk-bundle/
else
    echo "ndk-bundle already installed. Skipping..."
fi

# Build any-heart including protobuf files and test dependencies
cd $workdir/anytype-clients
if [ ! -d "anytype-heart" ] ; then
    git clone https://github.com/anyproto/anytype-heart
    cd anytype-heart
else
    cd "anytype-heart"
    git pull
fi

# Rebuild protobuf generated files
# temp fix to resolve error when installing 
go get github.com/pseudomuto/protoc-gen-doc/extensions/google_api_http@v1.5.1
make setup-protoc
make protos

# Build middleware library for Desktop client
mkdir -p $workdir/anytype-clients/anytype-ts
make install-dev-js ANY_SYNC_NETWORK=$workdir/heart.yml

# Build middleware library for Android client
mkdir -p $workdir/anytype-clients/dist/android/pb
make build-android ANY_SYNC_NETWORK=$workdir/heart.yml
make protos-java

# Build middleware library for iOS client, which cannot be done one Linux, see https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile
#mkdir -p $workdir/anytype-clients/dist/ios/pb
#make build-ios ANY_SYNC_NETWORK=$workdir/heart.yml
#make protos-swift

# Run tests
#make test-deps
#make test

#export ANYTYPE_TEST_GRPC_PORT=31088
#docker compose up -d
#make test-integration

# Build Desktop client
cd $workdir/anytype-clients
git clone https://github.com/anyproto/anytype-ts
cd anytype-ts
npm install -D
npm run dist:win
npm run dist:linux
SERVER_PORT=1443 ANYPROF=:1444 npm run start:dev-win
