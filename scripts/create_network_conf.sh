#! /bin/bash

echo "Running this configuration creation tool will overwrite the *.yml configuration files in ../../any-sync!"

read -p "Do you want to continue? [y/N] " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

git clone https://github.com/anyproto/any-sync-tools.git
cd any-sync-tools || exit
go install ./any-sync-network
cd ../../any-sync || exit
any-sync-network create
