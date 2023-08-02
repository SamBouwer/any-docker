# any-docker

Community-maintained dockerized instance of an anytype node

> ⚠️ Note: this project is "work in progress" and is not yet ready for production use. It's actually not yet even ready for development use ;) (but I'm working on that!)

> ⚠️ Disclaimer: I've tried to write the instructions below in such a way that as many people as possible can run their own Anytype node. This means it might be too verbose for your taste. In the case it is not clear enough, feel free to submit an Issue or submit a pull request 💌.

Aim: provide a simple to use yet customizable docker solution that runs an Anytype node and required infrastructure for development and testing.

## Project Status

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
  - ✅ Android 
  - ❌ iOS (can only be built on MacOS, which I currently don't have)

⏳ Clients 
  - ⏳ Desktop
    - ⏳ Windows 
    - ⏳ Linux
    - ❌ MacOS (can only be built on MacOS, which I currently don't have)
  - ⏳ Android 
  - ❌ iOS (can only be built on MacOS, which I currently don't have)

## Prerequisites 
In order to follow this guide, you'll need to run a debian based linux distribution such as Debian or Ubuntu with `git` installed. You can install `git` running:

```bash
apt update && apt upgrade
apt-get install -y git
```

> ℹ️ Tip: install [portainer](https://www.portainer.io/) to easily manage your docker "stack" (portainer term for docker compose configuration) and see logs for troubleshooting.

## Run node in docker

To get started, clone this repository, enter the directory, and run your node including the required infrastructure in Docker compose using the `docker-compose.yml` and `.env` files:

```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
docker compose up -d
```

> ℹ️ Tip: run `git pull` when you want to pull the latest version of the repository to your local machine.

You should now see something similar to this:

```shell
[+] Running 9/9
 ✔ Network any-docker_any-network  Created
 ✔ Volume "any-docker_s3"          Created
 ✔ Volume "any-docker_db"          Created
 ✔ Container mongo_anytype         Started
 ✔ Container any-sync-coordinator  Started
 ✔ Container any-sync-node         Started
 ✔ Container any-sync-filenode     Started
 ✔ Container minio_anytype         Started
 ✔ Container redis_anytype         Started
```

Congratulations! 🎉 You are now running your own Anytype Node!

To stop the node again, run:

```bash
docker compose down
```

## Build clients

To actually use the node, we need to build Anytype clients that can connect to this node. In the current version, the connection configuration and middleware libraries are baked into the clients when the clients are built from source. To build the middleware libraries and Anytype clients, run: 

```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
make build-client-heart
make build-client-all
```

Clients will be in the "anytype" folder once done. 

## Build nodes

You can skip this step of you just want to run nodes as provided in the docker images without further customization. If you want to build the any-docker images yourself, clone this repo, enter the directory and `make` it!

```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
make build-node-all
```

> ℹ️ Tip: run `make help` to see all make options

This will build the following docker images:

- any-sync-coordinator
- any-sync-node
- any-sync-filenode

## Contribute

I'm building a Dockerfile and supporting scripts and files based on the instructions as posted here: https://tech.anytype.io/how-to/self-hosting

As building Anytype nodes and clients from source for selfhosting is new, and I am personally new to building docker images, any help is welcome!

⚠️ Note: You will find many Id's and Keys in this repo, but those are often changing and only exposed locally on my machine, so its of little use to you :)

## Disclaimer

I am not part of the Anytype team.