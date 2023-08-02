#Dockerfile vars
GOLANG_VER=1.19.11
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
	    @echo "GOLANG_VER		Go version (default: 1.19)"
	    @echo "ANYTYPE_VER		Anytype version (default: 0.33.3)"
	    @echo "ANY_DOCKER_VER		Any-docker version (default: 1)"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo ""
	    @echo "pull				Pull latest from repository"
	    @echo "setup-dev-env 			Setup development environent (install packages and dependencies), only needs to be run once"
	    @echo "build-node-all			Build all node images"
	    @echo "build-node-coordinator 		Build coordinator only"
	    @echo "build-node-syncnode		Build sync node only"
	    @echo "build-node-filenode 		Build filenode only"
	    @echo "build-heart			Build middleware and clients"
	    @echo "build-client-win		Build Windows client"
	    @echo "build-client-linux		Build Linux client"
	    @echo "build-client-macos		Build MacOS client"
	    @echo "build-client-all		Build all clients"
	    @echo "push				Build image and push to docker.io (requires login)"
	    @echo "all				[default] Build all images and clients"
	    @echo "all-push			Build and push all images and clients"

.DEFAULT_GOAL := all

pull:
	    @git pull

setup-dev-env:
	    ./setup_dev_env.sh -v ${GOLANG_VER}

build-node-coordinator:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_COORDINATOR} --target ${IMAGENAME_COORDINATOR} .

build-node-syncnode:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_NODE} --target ${IMAGENAME_NODE} .

build-node-filenode:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_FILENODE} --target ${IMAGENAME_FILENODE} .

build-node-all: build-node-coordinator build-node-syncnode build-node-filenode

build-heart:
	    ./build_heart_clients.sh

build-client-win:
	    @docker 

build-client-linux:
	    @docker

build-client-macos:
	    @docker

build-client-all: build-client-win build-client-linux build-client-macos

push:
	    @docker login
	    @docker push ${IMAGEFULLNAME_COORDINATOR}
	    @docker push ${IMAGEFULLNAME_NODE}
	    @docker push ${IMAGEFULLNAME_FILENODE}

all: pull build-node-all build-client-all

all-push: pull build-node-all build-client-all push
