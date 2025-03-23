#!/bin/bash
source ./utils/print_message.sh

ssh_encryption_algoritm=$(jq -c '.ssh_encryption_algoritm' config.json | tr -d '"')

ssh-keygen -t "$ssh_encryption_algoritm" -f "/home/root/.ssh/$4_$ssh_encryption_algoritm"

sshpass -p "$3" ssh-copy-id -i /home/root/.ssh/"$4"_"$ssh_encryption_algoritm".pub "$2"@"$1"
