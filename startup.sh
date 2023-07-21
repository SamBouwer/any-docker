#! /bin/bash
any-sync-network create
any-sync-coordinator -c /anytype/any-sync-tools/any-sync-coordinator.yml
any-sync-node -c /anytype/any-sync-tools/any-sync-node.yml
any-sync-filenode -c /anytype/any-sync-tools/any-sync-filenode.yml
