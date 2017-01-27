#!/bin/bash
IP_ADDRESS=$1
SERVER_DOMAIN=$2
ssh-keygen -R $IP_ADDRESS
ssh-keygen -R $SERVER_DOMAIN
./ssh-copy-id.sh -i ~/.ssh/id_rsa.pub root@$IP_ADDRESS
./ssh-copy-id.sh -i ~/.ssh/id_rsa.pub root@$SERVER_DOMAIN
