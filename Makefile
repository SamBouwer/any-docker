#Dockerfile vars
GOLANG_VER=1.19
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
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "GOLANG_VER		Go version (default: 1.19)"
	    @echo "ANYTYPE_VER		Anytype version (default: 0.33.3)"
	    @echo "ANY_DOCKER_VER	Any-docker version (default: 1)"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "pull			Pull latest from repo"
	    @echo "build-coordinator 	Build coordinator only"
	    @echo "build-node		Build node only"
	    @echo "build-filenode 		Build filenode only"
	    @echo "build-win		Build Windows client"
	    @echo "build-linux		Build Linux client"
	    @echo "build-macos		Build MacOS client"
	    @echo "push			Build image and push to docker.io (requires login)"
	    @echo "all			[default] Build all images"
	    @echo "all-push		Build and push all images"

.DEFAULT_GOAL := all 

pull:
	    @git pull

build-coordinator:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_COORDINATOR} --target ${IMAGENAME_COORDINATOR} .

build-node:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_NODE} --target ${IMAGENAME_NODE} .

build-filenode:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_FILENODE} --target ${IMAGENAME_FILENODE} .

build-heart:
	    #@chmod -R 700 ./build_heart_clients.sh
	    ./build_heart_clients.sh
build-win:
	    @docker 

build-linux:
	    @docker

build-macos:
	    @docker

push:
	    @docker login
	    @docker push ${IMAGEFULLNAME_COORDINATOR}
	    @docker push ${IMAGEFULLNAME_NODE}
	    @docker push ${IMAGEFULLNAME_FILENODE}

all: pull build-coordinator build-node build-filenode

all-push: pull build-coordinator build-node build-filenode push
