#! /bin/bash
any-sync-network create
go run /anytype/any-sync-coordinator -c coordinator.yml
go run /anytype/any-sync-node/any-sync-node -c sync_1.yml
go run /anytype/any-sync-filenode -c file_1.yml

read -p "Press Enter to continue" </dev/tty
