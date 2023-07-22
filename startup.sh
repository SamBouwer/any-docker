#! /bin/bash
any-sync-network create
./any-sync-coordinator -c coordinator.yml
go run /anytype/any-sync-node/bin/any-sync-node -c sync_1.yml
go run /anytype/any-sync-filenode/bin/any-sync-filenode -c file_1.yml

read -p "Press Enter to continue" </dev/tty
