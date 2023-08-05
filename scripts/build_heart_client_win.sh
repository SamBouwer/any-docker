#! /bin/bash
echo ""
echo "-=[ Building Anytype middleware and client for Windows ]=-"
echo ""

workdir=${PWD}
workdir=${workdir:-/}

# Build any-heart including protobuf files
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
if [ ! -e "anytype-ts/package.json" ] ; then
    echo "Cloning anytype-ts repository..."
    rm -r anytype-ts
    git clone https://github.com/anyproto/anytype-ts
    cd anytype-ts
else
    echo "Pulling latest anytype-ts repository..."
    cd "anytype-ts"
    git pull
fi
echo "Starting npm install..."
npm install -D

# Rebuild protobuf generated files by uild middleware library from source for Desktop client
cd $workdir/anytype-clients/anytype-heart
make install-dev-js ANY_SYNC_NETWORK=$workdir/any-sync/heart.yml

# temp fix to resolve errors when installing. protoc-gen-grpc-web and protoc-gen-doc should be installed automatically, but they are not...
echo "Downloading dependencies..."
npm install -g protoc-gen-grpc-web
go get github.com/pseudomuto/protoc-gen-doc/extensions/google_api_http@v1.5.1
echo "Overriding protobuf binary file..."
make setup-protoc
ech "Regenerating protobuf files..."
make protos

# Optionally, build and run tests
make test-deps
make test

# Integration tests (run local 
export ANYTYPE_TEST_GRPC_PORT=31088
docker compose up -d
make test-integration

# Run local gRPC server to debug on default port 9999
make build-server

# Run client build
cd $workdir/anytype-clients/anytype-ts
npm run dist:win

#Run
SERVER_PORT=1443 ANYPROF=:1444 npm run start:dev-win
