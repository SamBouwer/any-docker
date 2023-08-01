#! /bin/bash

echo -= Build anytype-heart and anytype-clients =-

## BUILD ANYTYPE HEART LIBRARIES AND CLIENTS ##

workdir=${PWD}
workdir=${workdir:-/}

mkdir anytype-clients

cd /usr/lib/android-sdk
wget -N https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdtools.zip
unzip -qo cmdtools.zip
#rm cmdtools.zip
cd cmdline-tools
mkdir -p latest
mv -n bin/ latest/

cd
sudo mkdir -p /usr/lib/android-sdk/ndk-bundle
sudo sdkmanager --sdk_root=/usr/lib/android-sdk/cmdline-tools/latest/bin --install "ndk;23.2.8568313"
sudo mv -n /usr/lib/android-sdk/cmdline-tools/latest/bin/ndk/23.2.8568313/ /usr/lib/android-sdk/ndk-bundle/

# Build any-heart including protobuf files and test dependencies
cd $workdir/anytype-clients
if [ ! -d "anytype-heart" ] ; then
    git clone https://github.com/anyproto/anytype-heart anytype-heart
    cd anytype-heart
else
    cd "anytype-heart"
    git pull
fi
make test-deps
make test
make setup-protoc
make protos
mkdir -p $workdir/anytype-clients/anytype-ts
#mkdir ../anytype-ts/dist
#mkdir ../anytype-ts/dist/lib
make install-dev-js ANY_SYNC_NETWORK=$workdir/heart.yml
# I don't have a machine running MacOS so I cannot setup the deps for iOS
#make build-ios ANY_SYNC_NETWORK=/anytype/heart.yml
# I can't get the Android version to properly build
#make build-android ANY_SYNC_NETWORK=/anytype/heart.yml
make protos-java
