#! /bin/bash
# commented out the line below because docker is not designed to run scripts interactively inside a container. The configuration yml files need to be created in advance.
# any-sync-network create
# echo -e "\r"
# echo -e "mongodb://mongorootuser:mongorootpassword@mongo:27017\r"
# echo -e "\r"
# echo -e "\r"
# echo -e "192.168.1.175:9000\r"
# echo -e "\r"
# echo -e "\r"
# echo -e "\r"
# echo -e "redis://redis:6379/?dial_timeout=3&db=1&read_timeout=6s&max_retries=2\r"

echo ""
echo "-=[ starting any-sync-coordinator... ]=-"
echo ""
/anytype/any-sync-coordinator/bin/any-sync-coordinator -c coordinator.yml &
echo any-sync-coordinator is running

read -p "Press Enter to continue" </dev/tty
