# any-docker

⚠️ Note: this project is "work in progress" and is not yet ready for production use. It's actually not yet even ready for development use ;)

Community-maintained dockerized all-in-one instance of an anytype node.

Aim: provide a simple to use all-in-one docker image that runs an Anytype node and required infrastructure for development and testing.

* mongodb
* minio (s3 storage)
* redis
* any-heart
* any-sync-coordinator
* any-sync-node
* any-sync-filenode

Secondly, we want to offer a simple to use yet customizable option with just the Anytype "any-sync" and middleware infrastructure while running your own supporting infrastructure (mongodb, s3 storage, redis).

* any-heart
* any-sync-coordinator
* any-sync-node
* any-sync-filenode

## Build nodes
```
git clone https://github.com/SamBouwer/any-docker
cd any-docker
make
```

## Run nodes

Before you run your anytype node container, make sure you have mongo, s3 storage, and redis running in a docker network, and connect your anytype node container to that same network. For example:

`docker network create anytype-node_default`

You can run the nodes using the `docker run` command:

```
docker run --name any-docker --network=anytype-node_default any-sync-docker:0.33.3
```

Alternatively, you can run the node along with the required infrastructure in Docker compose using the `docker-compose-example.yaml` and `.evn.example` files.

## Build clients

## Contribute

I'm building a Dockerfile based on the instructions as posted here: https://tech.anytype.io/how-to/self-hosting

As building Anytype nodes and clients from source for selfhosting is new, and I am personally new to building docker images, any help is welcome!

⚠️ Note: You will find many Id's and Keys in this repo, but those are often changing and only exposed locally on my machine, so its of little use to you :)

### Prepare dev environment (to be scripted in `setup_dev_env.sh`

- Download and install go-1.19
  
  `wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz`
  
  `tar -C /usr/local -xzf /home/bouwers/go1.19.11.linux-amd64.tar.gz`

- Add GOPATH and GOROOT to PATH
  
  `nano ~/.bashrc`
  
  Add the following lines:
  ```
  export GOPATH=$HOME/go
  export GOROOT=/usr/local/go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
  ```
  And then run:
  `. ~/.bashrc`
- Test with `go version` which should return
  
  `go version go1.19.11 linux/amd64`

- Install Android SDK

  `apt install android-sdk`

  Add install path
  
  `nano ~/.bashrc`

  Add the following line:
  `export ANDROID_SDK_ROOT=/usr/lib/android-sdk`
  And then run:
  `. ~/.bashrc`
  
- Clone this repo
  
  `git clone https://github.com/SamBouwer/any-docker`
  
  `cd any-docker`
  
- Run `make` to build the docker images for all four
- 

## Disclaimer

I am not part of the Anytype team.

## TODO

* Improve documentation how to build and run a node
* Add docker run and docker-compose.yaml examples
* Take anytype-heart out of Dockerimage and make it part of the client building steps
* How to build, distribute and run clients (Windows, Android)
* Split monolith Docker image to allow BYOI (bring your own infra; s3, mongodo, redis)
