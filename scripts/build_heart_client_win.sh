#! /bin/bash
echo ""
echo "-=[ Building Anytype middleware and client for Windows ]=-"
echo ""

workdir=${PWD}
workdir=${workdir:-/}

# Build any-heart including protobuf files
cd "$workdir/anytype-clients" || exit
if [ ! -d "anytype-heart" ] ; then
    echo "Cloning anytype-heart repository..."
    git clone https://github.com/anyproto/anytype-heart
    cd anytype-heart || exit
else
    echo "Pulling latest anytype-heart repository..."
    cd "anytype-heart" || exit
    git pull
fi

# Build Desktop client
cd "$workdir/anytype-clients" || exit
if [ ! -e "anytype-ts/package.json" ] ; then
    echo "Cloning anytype-ts repository..."
    rm -r anytype-ts
    git clone https://github.com/anyproto/anytype-ts
    cd anytype-ts || exit
else
    echo "Pulling latest anytype-ts repository..."
    cd "anytype-ts" || exit
    git pull
fi
echo "Cleaning up..."
rm -f dist/*
echo "Starting npm install..."
npm install -D

./update.sh windows-latest

# Rebuild protobuf generated files by uild middleware library from source for Desktop client
cd "$workdir/anytype-clients/anytype-heart" || exit
make install-dev-js ANY_SYNC_NETWORK=$workdir/any-sync/heart.yml

# temp fix to resolve errors when installing. protoc-gen-grpc-web and protoc-gen-doc should be installed automatically, but they are not...
#echo "Downloading dependencies..."
npm install --save-dev webpack-cli --legacy-peer-deps
#npm install -g protoc-gen-grpc-web
#go get github.com/pseudomuto/protoc-gen-doc/extensions/google_api_http@v1.5.1
#echo "Overriding protobuf binary file..."
##make setup-protoc
#echo "Regenerating protobuf files..."
#make protos

# Optionally, build and run tests
#echo "Installing test dependencies..."
#make test-deps
#echo "Start test procedure..."
#make test

# Integration tests (run local 
#echo "Starting local gRPC server..."

#read -p "Github Login: " GITHUB_LOGIN_PROMPT
#read -s -p "Github Token: " GITHUB_TOKEN_PROMPT

#sudo ANYTYPE_TEST_GRPC_PORT=31088 GITHUB_LOGIN=$GITHUB_LOGIN_PROMPT GITHUB_TOKEN=$GITHUB_TOKEN_PROMPT docker compose up -d
#make test-integration

# Run local gRPC server to debug on default port 9999
#make build-server

# Run client build
echo "Building Windows client..."
cd "$workdir/anytype-clients/anytype-ts" || exit
# Temp fix to skip AzureSignTool step (see also here: https://github.com/anyproto/anytype-ts/issues/156)
jq 'del(.build.win.sign)' package.json >> package_new.json
rm package.json
mv package_new.json package.json

# Second fix to install specific issue with "keytar.node is not a valid Win32 application" when running the client
npm exec electron-builder@24.6.3 install-app-deps --platform=win32 --arch=x64

# Another fix to prevent issue described here: https://github.com/anyproto/anytype-ts/issues/159
npm run update:locale

# Make sure deps are installed
npm run build:deps

# Actual build (wskip signing as mentioned here: https://github.com/anyproto/anytype-ts/issues/159#issuecomment-1666595258)
ELECTRON_SKIP_NOTARIZE=1 ELECTRON_SKIP_SENTRY=1 npm run dist:win

#Run
#echo "Running local server..."
#SERVER_PORT=1443 ANYPROF=:1444 npm run start:dev-win
