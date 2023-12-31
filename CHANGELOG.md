# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.4] - 2023-08-01

### Added
* Added startup_dev_env.sh script to easily install all required dependencies for building your nodes and clients

### Improved
* Migrated as much logic to the startup_dev_env.sh script to have all dependencies installed from there, leaving less room for depencency issues when running the other individual scripts

## [0.0.3] - 2023-07-29

### Added
* Static IPs for docker (testing), also in yaml config files
* Building anytype-heart middleware libraries and anytype-ts client app (Windows and Linux for now, MacOS to be added)
* Make a start with building Android app (iOS to be added)

### Improved
* Makefile improvements (includes git pull)
* Readme.md improvements

## [0.0.2] - 2023-07-22

### Fixed
* Made the go binaries (any-sync-coordnator, any-sync-node, any-sync-filenode) executable in Dockerfile
* Fixed the startup script to run the go binaries (any-sync-coordnator, any-sync-node, any-sync-filenode) in the correct way

### Added
* Split whole build process into three separate images to make it easier to analyze docker logs

## [0.0.2] - 2023-07-21

### Added
* Added docker-compose-example.yaml with minio, mongodb, and redis
* Added .env.example and replaced environment variables in docker-compose-example.yaml with reference to .env.example file
* Added CHANGELOG.md as separate file

## [0.0.1] - 2023-07-20

### Added
* golang:1.19-bullseye as base image (golang:1.19 is currently supported by Anytype)
* Additional dependencies to git clone Anytype repos
* Clone and install any-sync-tool
* Clone and build any-sync-coordinator
