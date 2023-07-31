echo Build anytype-heart and anytype-clients

## BUILD ANYTYPE HEART LIBRARIES AND CLIENTS ##

makedir anytype
cd anytype

set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                git \
                openssl \
                protobuf-compiler \
                libprotoc-dev \
                android-sdk \
                unzip \
        ; \
        rm -rf /var/lib/apt/lists/*

cd /usr/lib/android-sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdtools.zip
unzip -q cmdtools.zip
cd cmdline-tools
mkdir latest
mv  bin/ latest/
export ANDROID_HOME=/usr/lib/android-sdk
export ANDROID_SDK_ROOT=/usr/lib/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
sdkmanager --sdk_root=/usr/lib/android-sdk/cmdline-tools/bin --install "ndk;23.2.8568313"
mkdir /usr/lib/android-sdk/ndk-bundle
mv /opt/android-sdk/ndk/23.2.8568313/ /usr/lib/android-sdk/ndk-bundle/

# Build any-heart including protobuf files and test dependencies
cd anytype
git clone https://github.com/anyproto/anytype-heart
heart.yml .
cd anytype/any-heart
make test-deps
make test
make setup-protoc
make protos
mkdir ../anytype-ts
#mkdir ../anytype-ts/dist
#mkdir ../anytype-ts/dist/lib
make install-dev-js ANY_SYNC_NETWORK=/anytype/heart.yml
# I don't have a machine running MacOS so I cannot setup the deps for iOS
#make build-ios ANY_SYNC_NETWORK=/anytype/heart.yml
# I can't get the Android version to properly build
#make build-android ANY_SYNC_NETWORK=/anytype/heart.yml
make protos-java

cd anytype/any-heart/anytype-ts
chmod +x any-heart
