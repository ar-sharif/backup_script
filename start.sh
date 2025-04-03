#!/bin/bash

source ./utils/print_message.sh
source ./utils/char_remover.sh

echo 'script starting ...'
chmod +x set_ssh.sh set_cronjobs.sh

if [ ! -f "config.json" ]; then
    echo "Error: config.json not found!"
    exit 1
fi

jq -c '.projects[]' config.json | while read -r i; do
    name=$(char_remover "$(echo "$i" | jq -c '.name')" '"')
    path=$(char_remover "$(echo "$i" | jq -c '.path')" '"')
    timing=$(char_remover "$(echo "$i" | jq -c '.timing')" '"')
    target_path=$(char_remover "$(echo "$i" | jq -c '.target_path')" '"')
    target_ip=$(char_remover "$(echo "$i" | jq -c '.target_ip')" '"')
    target_user=$(char_remover "$(echo "$i" | jq -c '.target_user')" '"')
    target_password=$(char_remover "$(echo "$i" | jq -c '.target_password')" '"')

    print_message "Setting SSH for backup process $name (IP: $target_ip)"

    ./set_ssh.sh "$target_ip" "$target_user" "$target_password" "$name" "$target_path"

    if [ $? -eq 0 ]; then
        print_message "SSH setting done for backup process $name"
    else
        print_message "Error: SSH setup failed for $name"
    fi

done

if [ $? -ne 0 ]; then
    print_message "Error: Failed to create ssh"
    exit 1
fi

echo 'Script completed.'
