#Dockerfile vars
GOLANG_VER=1.19
ANYTYPE_VER=0.33.3

#vars
IMAGENAME=any-sync-docker
REPO=sambouwer
IMAGEFULLNAME=${REPO}/${IMAGENAME}:${ANYTYPE_VER}

.PHONY: help build push all

help:
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "GOLANG_VER - Go version"
	    @echo "ANYTYPE_VER - Anytype version"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "build"
	    @echo "push"
	    @echo "all"

.DEFAULT_GOAL := build

build:
	    @docker build --pull --build-arg GOLANG_VER=${GOLANG_VER} -t ${IMAGEFULLNAME} .

push:
	    @docker login
	    @docker push ${IMAGEFULLNAME}

all: build push
