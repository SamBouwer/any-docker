#! /bin/bash
any-sync-network create
go run any-sync-coordinator -c coordinator.yml
any-sync-node/any-sync-node -c sync_1.yml
bin/any-sync-filenode -c file_1.yml

read -p "Press Enter to continue" </dev/tty
