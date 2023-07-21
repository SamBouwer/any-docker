Version: 0.0.1

CHANGELOG

## [Unreleased]

[0.0.2] - 2023-07-21

### Added
* Added docker-compose-example.yaml with minio, mongodb, and redis
* Added .env.example and replaced environment variables in docker-compose-example.yaml with reference to .env.example file
* Added CHANGELOG.md as separate file

[0.0.1] - 2023-07-20

### Added
* golang:1.19-bullseye as base image (golang:1.19 is currently supported by Anytype)
* Additional dependencies to git clone Anytype repos
* Clone and install any-sync-tool
* Clone and build any-sync-coordinator
