# any-docker

Community-maintained dockerized instance of an anytype node

> ⚠️ Note: this project is "work in progress" and is not yet ready for production use. It's actually not yet even ready for development use ;) (but I'm working on that!)

> ⚠️ Disclaimer: I've tried to write the instructions below in such a way that as many people as possible can run their own Anytype node. This means it might be too verbose for your taste. In the case it is not clear enough, feel free to submit an Issue or submit a pull request 💌.

Aim: provide a simple to use yet customizable docker solution that runs an Anytype node and required infrastructure for development and testing.

## Status

✅ Infrastructure
  - ✅ mongodb (database)
  - ✅ mongo_express (optional)
  - ✅ minio (s3 file storage)
  - ✅ redis (file cache)

✅ Any-sync
  - ✅ any-sync-coordinator
  - ✅ any-sync-node
  - ✅ any-sync-filenode

✅ Middleware libraries
  - ✅ Desktop
  - ⏳ Android 
  - ⏳ iOS

- ⏳ Clients 
  - ⏳ Desktop
    - ✅ Windows 
    - ✅ Linux
    - ⏳ MacOS
  - ⏳ Android 
  - ⏳ iOS

## Prerequisites

* In order to follow this guide, you'll need to run a debian based linux distribution such as Debian or Ubuntu.
* You need to have the following packages installed:
  * git
  * docker
  * docker-compose

You can do so by running:

```bash
apt update
apt upgrade
apt-get install -y git docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

> ℹ️ Tip: install [portainer](https://www.portainer.io/) to easily manage your docker "stack" (portainer term for docker compose configuration) and see logs for troubleshooting.

## Run node in docker

To get started, clone this repository, enter the directory, and run your node including the required infrastructure in Docker compose using the `docker-compose-example.yml` and `.env.example` files:

```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
docker-compose up -d
```

> ℹ️ Tip: run `git pull` when you want to pull the latest version of the repository to your local machine.

Congratulations! 🎉 You are now running your own Anytype Node!

To actually use the mode, we need to build Anytype clients that can connect to this node, as the connection configuration is baked into the clients when the clients are built from source.

```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
make
```

## Build clients

Run `make build-heart` to build the middleware libraries and Anytype clients. Clients will be in the "anytype" folder once done. 

## Build nodes

You can skip this step of you just want to run nodes as provided in the docker images without further customization. If you want to build the any-docker images yourself, clone this repo, enter the directory and `make` it!

```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
make
```

This will build the following docker images:

- any-sync-coordinator
- any-sync-node
- any-sync-filenode

## Contribute

I'm building a Dockerfile based on the instructions as posted here: https://tech.anytype.io/how-to/self-hosting

As building Anytype nodes and clients from source for selfhosting is new, and I am personally new to building docker images, any help is welcome!

⚠️ Note: You will find many Id's and Keys in this repo, but those are often changing and only exposed locally on my machine, so its of little use to you :)

### Prepare dev environment (to be scripted in `setup_dev_env.sh`)

- Download and install go-1.19
  
  `wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz`
  
  `tar -C /usr/local -xzf /home/bouwers/go1.19.11.linux-amd64.tar.gz`

- Add GOPATH and GOROOT to PATH
  
  `nano ~/.bashrc`
  
  Add the following lines:
  
  ```bash
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
  
  ```
  export ANDROID_SDK_ROOT=/usr/lib/android-sdk
  export ANDROID_HOME=/usr/lib/android-sdk/
  ```
  
  And then run:
  
  `. ~/.bashrc`

- Install npm

  `apt install npm`

- Install libsecret-1

  `apt-get install libsecret-1-dev`

- Install jq
  
  `apt install jq`
  
- Install wine (for building Windows app on Linux)
  
  `apt install wine`
  `sudo dpkg --add-architecture i386 && sudo apt-get update &&
  sudo apt-get install wine32`
  
- Clone this repo
  
  `git clone https://github.com/SamBouwer/any-docker`
  
  `cd any-docker`
  
- Run `make` to build the docker images for all four
- 

## Disclaimer

I am not part of the Anytype team.

## TODO

* Improve documentation how to build and run a node
* Take anytype-heart out of Dockerimage and make it part of the client building steps
* How to build, distribute and run clients (Windows, Android)
* Split monolith Docker image to allow BYOI (bring your own infra; s3, mongodo, redis)
