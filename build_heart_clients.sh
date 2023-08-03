#! /bin/bash
echo ""
echo "-=[ Building Anytype middleware and clients ]=-"
echo ""

workdir=${PWD}
workdir=${workdir:-/}

## BUILD ANYTYPE HEART LIBRARIES AND CLIENTS ##

# Install Android SDK and cmdtools with ndk-bundle
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
    echo "Cloning anytype-heart repository..."
    git clone https://github.com/anyproto/anytype-heart
    cd anytype-heart
else
    echo "Pulling latest anytype-heart repository..."
    cd "anytype-heart"
    git pull
fi

# Build Desktop client
cd $workdir/anytype-clients
if [ ! -d "anytype-ts" ] ; then
    echo "Cloning anytype-ts repository..."
    git clone https://github.com/anyproto/anytype-ts
    cd anytype-ts
else
    echo "Pulling latest anytype-ts repository..."
    cd "anytype-ts"
    git pull
fi
npm install -D

# Rebuild protobuf generated files
# Build middleware library from source for Desktop client
cd $workdir/anytype-clients
mkdir -p $workdir/anytype-clients/anytype-ts
make install-dev-js ANY_SYNC_NETWORK=$workdir/heart.yml

# temp fix to resolve error when installing 
go get github.com/pseudomuto/protoc-gen-doc/extensions/google_api_http@v1.5.1
make setup-protoc
make protos

# Run client build
npm run dist:win
npm run dist:linux
#npm run dist:mac

#Run
SERVER_PORT=1443 ANYPROF=:1444 npm run start:dev
#SERVER_PORT=1443 ANYPROF=:1444 npm run start:dev-win

# Build Android
cd $workdir/anytype-clients
if [ ! -d "anytype-kotlin" ] ; then
    echo "Cloning anytype-kotlin repository..."
    git clone https://github.com/anyproto/anytype-kotlin
    cd anytype-kotlin
else
    echo "Pulling latest anytype-kotlin repository..."
    cd "anytype-kotlin"
    git pull
fi

cd $workdir/anytype-clients/anytype-kotlin
if [ ! -f "github.properties" ] ; then
    read -p "Github User Id: " GITHUBUSERNAME
    echo "Looking up github Id for $GITHUBUSERNAME"
    GITHUB_USER_ID=$(wget -O - "https://api.github.com/users/${GITHUBUSERNAME}" | grep -Po '"id": \K[[:digit:]]+')
    echo "You github user Id is $GITHUB_USER_ID"
    read -p "Github PAT: " GITHUB_PERSONAL_ACCESS_TOKEN
    touch github.properties
    echo "gpr.usr=${GITHUB_USER_ID}" >> github.properties
    echo "gpr.key=${GITHUB_PERSONAL_ACCESS_TOKEN}" >> github.properties
else
    echo "github.properties file already present. Delete the file and run this script again to replace it, or edit the file manually"
fi

if [ ! -f "apikeys.properties" ] ; then
    touch apikeys.properties
    echo 'amplitude.debug="AMPLITUDE_DEBUG_KEY"' >> apikeys.properties
    echo 'amplitude.release="AMPLITUDE_RELEASE_KEY"' >> apikeys.properties
    echo 'sentry_dsn="SENTRY_DSN_KEY"' >> apikeys.properties
else
    echo "apikeys.properties file already present. Delete the file and run this script again to replace it, or edit the file manually"
fi

gradle build

# Build middleware library for Android client
cd $workdir/anytype-clients/anytype-kotlin
mkdir -p $workdir/anytype-clients/anytype-kotlin/dist/android/pb
make build-android ANY_SYNC_NETWORK=$workdir/heart.yml
make protos-java

# Build middleware library for iOS client, which cannot be done one Linux, see https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile
#mkdir -p $workdir/anytype-clients/dist/ios/pb
#make build-ios ANY_SYNC_NETWORK=$workdir/heart.yml
#make protos-swift
