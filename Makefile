#Dockerfile vars
GOLANG_VER=1.20.7
ANYTYPE_VER=0.33.3
ANY_DOCKER_VER=1

#vars
IMAGENAME_COORDINATOR=any-sync-coordinator
IMAGENAME_NODE=any-sync-node
IMAGENAME_FILENODE=any-sync-filenode

REPO=sambouwer
IMAGEFULLNAME_COORDINATOR=${REPO}/${IMAGENAME_COORDINATOR}:${ANYTYPE_VER}-${ANY_DOCKER_VER}
IMAGEFULLNAME_NODE=${REPO}/${IMAGENAME_NODE}:${ANYTYPE_VER}-${ANY_DOCKER_VER}
IMAGEFULLNAME_FILENODE=${REPO}/${IMAGENAME_FILENODE}:${ANYTYPE_VER}-${ANY_DOCKER_VER}

.PHONY: help pull build-coordinator build-node build-filenode push all all-push

help:
	    @echo ""
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "GOLANG_VER                    Go version (default: 1.19)"
	    @echo "ANYTYPE_VER                   Anytype version (default: 0.33.3)"
	    @echo "ANY_DOCKER_VER                Any-docker version (default: 1)"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo ""
	    @echo "pull                          Pull latest from repository"
	    @echo "setup-dev-env                 Setup development environent (install packages and dependencies), only needs to be run once"
	    @echo "create-network-conf           Create yml configuration files needed for Anytype nodes and clients. If you don't run this step, the default configuration will be used"
	    @echo "build-node-all                Build all node images"
	    @echo "build-node-coordinator        Build coordinator only"
	    @echo "build-node-syncnode           Build sync node only"
	    @echo "build-node-filenode           Build filenode only"
	    @echo "build-client-win              Build Windows middleware and client"
	    @echo "build-client-linux            Build Linux client"
	    @echo "build-client-macos            Build MacOS client"
	    @echo "build-client-all              Build all clients"
	    @echo "push                          Build image and push to docker.io (requires login)"
	    @echo "all                           [default] Build all images and clients"
	    @echo "all-push                      Build and push all images and clients"
	    @echo "clean                         Clean all repositories. You'll need to run the \`make build-*\` commands again"

.DEFAULT_GOAL := all

version:
		curl https://raw.githubusercontent.com/anyproto/anytype-ts/main/package.json | jq -r '.version'

pull:
	    @git pull

setup-dev-env:
	    ./scripts/setup_dev_env.sh -v ${GOLANG_VER}

create-network-conf:
	    ./scripts/create_network_conf.sh

build-node-coordinator:
	    @docker build -f any-node/Dockerfile --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_COORDINATOR} --target ${IMAGENAME_COORDINATOR} .

build-node-syncnode:
	    @docker build -f any-node/Dockerfile --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_NODE} --target ${IMAGENAME_NODE} .

build-node-filenode:
	    @docker build -f any-node/Dockerfile --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_FILENODE} --target ${IMAGENAME_FILENODE} .

build-node-all: build-node-coordinator build-node-syncnode build-node-filenode


build-client-win:
	    ./scripts/build_heart_client_win.sh

build-client-linux:
	    @echo not implemented yet

build-client-macos:
	    @echo not implemented yet

build-client-android:
	    @echo not implemented yet

build-client-ios:
	    @echo not implemented yet

build-client-all: build-client-win build-client-linux build-client-macos build-client-android build-client-ios

push:
	    @docker login
	    @docker push ${IMAGEFULLNAME_COORDINATOR}
	    @docker push ${IMAGEFULLNAME_NODE}
	    @docker push ${IMAGEFULLNAME_FILENODE}

all: pull build-node-all build-client-all

all-push: pull build-node-all build-client-all push

clean:
	    rm -r anytype-clients/
