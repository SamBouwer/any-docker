#! /bin/bash
any-sync-network create
/anytype/any-sync-coordinator/bin/any-sync-coordinator -c coordinator.yml
/anytype/any-sync-node/bin/any-sync-node -c sync_1.yml
/anytype/any-sync-filenode/bin/any-sync-filenode -c file_1.yml
