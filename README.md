⚠️This project is nog longer being maintained⚠️
As I'm no longer actively using Anytype, I'm no longer maintaining this project. Feel free to fork! 

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
- ⏳ reverse proxy

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
  - ⏳ Windows (build succeeds, but client won't run properly yet)
  - ❌ Linux (snapcraft error: snapcraft does not currently support building arm64 on amd64)
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
```

Now enter the directory you just pulled from Github

```bash
cd any-docker/any-node/
```

Fire up 🔥 docker compose!
```bash
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

To stop the node again, navigate to the any-node folder and bring the stack down:

```bash
docker compose down
```

## Build clients

> ℹ️ You can create your own network configuration using the `any-sync-network` tool as provided by Anytype. For the click-to-run experience I want to offer, you don't need to run this command and the default network addresses and configuration will be used. If you do want to setup your own network: `make create-network-conf`. Warning: this will break the docker setup!

To actually use the node, we need to build Anytype clients that can connect to this node. In the current version, the connection configuration and middleware libraries are baked into the clients when the clients are built from source. To build the middleware libraries and Anytype clients, run the following commands, where teh `make build-client-all` step can be replaced to only build a specific client. Checkout `make help` to find out the commands for the specific clients.

> ⚠️ Don't forget to navigate back to the folder where you already have cloned `any-docker` or where you want to clone the repo if not cloned yet!

You only need to run this part if you did not pull the any-docker repository in a previous step
```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
```

Now setup the development environment by installing all required dependencies
```bash
make setup-dev-env
```

Finally, build the clients.
```bash
make build-client-all
```

> ℹ️ Note: you only need to run `make setup-dev-env` once to install dependencies and create the required folder structure. If you (accidently) deleted or moved a folder or uninstalled packages required for building Anytype clients, you need to run this command again. You can always run it just to make sure everything is setup properly

> ℹ️ Note: if you are running this in WSL, make sure to add the following lines to `/etc/wsl.conf` to ensure snap can be installed:
> ```
> [boot]
> systemd=true
> ```
> Then run `wsl.exe --shutdown`

Clients will be in the "anytype" folder once done.

## Build nodes

You can skip this step of you just want to run nodes as provided in the docker images without further customization. If you want to build the any-docker images yourself, clone this repo, enter the directory and `make` it!

```bash
git clone https://github.com/SamBouwer/any-docker
cd any-docker
make build-node-all
```

> ℹ️ Tip: run `make help` to see all make options, for example to build individual nodes or clients only

This will build the following docker images:

- any-sync-coordinator
- any-sync-node
- any-sync-filenode

## Troubleshooting

In the case you run into an error, please remove the `any-docker` folder and start from scratch. There might be some leftover file from a previous run that is not compatible with a newer version of this repo, or a newer version of the Anytype source files. Either way, please submit a Github Issue so I can improve the script :).

## Contribute

I'm building a Dockerfile and supporting scripts and files based on the instructions as posted here: https://tech.anytype.io/how-to/self-hosting

As building Anytype nodes and clients from source for selfhosting is new, and I am personally new to building docker images, any help is welcome!

⚠️ Note: You will find many Id's and Keys in this repo, but those are often changing and only exposed locally on my machine, so its of little use to you :)

## Disclaimer

I am not part of the Anytype team.
