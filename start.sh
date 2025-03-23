#!/bin/bash

source ./utils/print_message.sh
source ./utils/char_remover.sh

echo 'script starting ...'
chmod +x set_ssh.sh set_cronjobs.sh

jq -c '.projects[]' config.json | while read -r i; do
    name=$(char_remover "$(echo "$i" | jq -c '.name')" '"')
    path=$(char_remover "$(echo "$i" | jq -c '.path')" '"')
    timing=$(char_remover "$(echo "$i" | jq -c '.timing')" '"')
    target_path=$(char_remover "$(echo "$i" | jq -c '.target_path')" '"')
    target_ip=$(char_remover "$(echo "$i" | jq -c '.target_ip')" '"')
    target_user=$(char_remover "$(echo "$i" | jq -c '.target_user')" '"')
    target_password=$(char_remover "$(echo "$i" | jq -c '.target_password')" '"')

    print_message "setting ssh for backup process $name"

    ./set_ssh.sh $target_ip $target_user $target_password $name
done
