# any-docker

⚠️ Note: this project is "work in progress" and is not yet ready for production use. It's actually not yet even ready for development use ;)

Community-maintained dockerized all-in-one instance of an anytype node.

Aim: provide a simple to use all-in-one docker image that runs a Anytype node and required infrastructure for development and testing.

* mongodb
* minio (s3 storage)
* redis
* any-sync-tool
* any-sync-coordinator
* any-sync-node
* any-sync-filenode

Secondly, we want to offer a simple to use yet customizable option with just the Anytype "any-sync" infrastructure while running your own supporting infrastructure (mongodb, s3, redis).

* any-sync-tool
* any-sync-coordinator
* any-sync-node
* any-sync-filenode

## Build node
```
git clone https://github.com/SamBouwer/any-docker
cd any-docker
make
```

## Run node

You can run the nodes using the `docker run` command:

```
docker run ...
```

Alternatively, you can run the node along with the required infrastructure in Docker compose using the `docker-compose-example.yaml` and `.evn.example` files.

## Build clients

## Contribute

I'm building a Dockerfile based on the instructions as posted here: https://tech.anytype.io/how-to/self-hosting

As building Anytype nodes and clients from source for selfhosting is new, and I am personally new to building docker images, any help is welcome!

## Disclaimer

I am not part of the Anytype team.

## TODO

* Improve documentation how to build and run a node
* Add docker run and docker-compose.yaml examples 
* How to build, distribute and run clients (Windows, Android)
* Split monolith Docker image to allow BYOI (bring your own infra; s3, mongodo, redis)
