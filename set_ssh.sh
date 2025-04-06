#!/bin/bash

source ./utils/print_message.sh

ssh_encryption_algoritm=$(jq -c '.ssh_encryption_algoritm' config.json | tr -d '"')
base_path=$(jq -c '.ssh_path' config.json | tr -d '"')

mkdir -p "$base_path"

if [ -f "${base_path}$4" ]; then
    print_message "Key ${base_path}$4 already exists, skipping key generation."
else
    ssh-keygen -t "$ssh_encryption_algoritm" -f "${base_path}$4" -N ""
fi

if ! grep -q "$1" "${base_path}known_hosts"; then
    ssh-keyscan -H "$1" >>"${base_path}known_hosts" 2>/dev/null
fi

sshpass -p "$3" ssh-copy-id -i "${base_path}$4.pub" "$2@$1" 2>/dev/null
if [ $? -ne 0 ]; then
    print_message "Error: Failed to copy SSH key to $2@$1"
    exit 1
fi

if [ ! -f "${base_path}config" ]; then
    touch "${base_path}config"
fi

if ! grep -q "Host $4" "${base_path}config"; then
    printf "Host %s\n   HostName %s\n   PreferredAuthentications publickey\n   IdentityFile %s%s\n" "$4" "$1" "$base_path" "$4" >>"${base_path}config"
fi

ssh -i "${base_path}$4" "$2@$1" "mkdir -p $5" </dev/null
