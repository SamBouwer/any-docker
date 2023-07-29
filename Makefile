#Dockerfile vars
GOLANG_VER=1.19
ANYTYPE_VER=0.33.3

#vars
IMAGENAME_COORDINATOR=any-sync-coordinator
IMAGENAME_NODE=any-sync-node
IMAGENAME_FILENODE=any-sync-filenode

REPO=sambouwer
IMAGEFULLNAME_COORDINATOR=${REPO}/${IMAGENAME_COORDINATOR}:${ANYTYPE_VER}
IMAGEFULLNAME_NODE=${REPO}/${IMAGENAME_NODE}:${ANYTYPE_VER}
IMAGEFULLNAME_FILENODE=${REPO}/${IMAGENAME_FILENODE}:${ANYTYPE_VER}

.PHONY: help build push all

help:
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "GOLANG_VER - Go version (default: 1.19)"
	    @echo "ANYTYPE_VER - Anytype version (default: 0.33.3)"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "pull to pull latest from repo"
	    @echo "build-coordinator to  build coordinator only"
	    @echo "build-node to build node only"
	    @echo "build-filenode to build filenode only"
	    @echo "push to push all buit images to docker"
	    @echo "all to build all images"
	    @echo "all-push to build and push all images"

.DEFAULT_GOAL := all 

pull:
	    @git pull

build-coordinator:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_COORDINATOR} --target ${IMAGENAME_COORDINATOR} .

build-node:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_NODE} --target ${IMAGENAME_NODE} .

build-filenode:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME_FILENODE} --target ${IMAGENAME_FILENODE} .

push:
	    @docker login
	    @docker push ${IMAGEFULLNAME_COORDINATOR}
	    @docker push ${IMAGEFULLNAME_NODE}
	    @docker push ${IMAGEFULLNAME_FILENODE}

all: pull build-coordinator build-node build-filenode

all-push: pull build-coordinator build-node build-filenode push
