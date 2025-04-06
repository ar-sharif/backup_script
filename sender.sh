#!/bin/bash

target_user="$1"
target_ip="$2"
target_path="$3"
path="$4"
name="$5"
project_path="$6"

# exec >"/home/sharif/BashProjects/backup/logs/${5}_$(date +'%Y-%m-%d_%H-%M-%S').log" 2>&1

tmp_dir="$project_path/.tmp/$name"
mkdir -p "$tmp_dir" || {
    echo "Error: Failed to create $tmp_dir"
    exit 1
}

date_time=$(date +"%Y-%m-%d_%H-%M-%S")
backup_file="$tmp_dir/${name}_${date_time}.tar.gz"
tar -czf "$backup_file" -C "$path" . || {
    echo "Error: Failed to create $backup_file"
    exit 1
}

backup_files_count=$(ls -1 "$tmp_dir"/*.tar.gz 2>/dev/null | wc -l)
if [ "$backup_files_count" -gt 10 ]; then
    oldest_file=$(ls -1 "$tmp_dir"/*.tar.gz | sort | head -n 1)
    rm -f "$oldest_file" || echo "Warning: Failed to remove $oldest_file"
fi

remote_cmd="/bin/ssh $name"
remote_scp="/bin/scp"

echo "Running SCP: $remote_scp $backup_file $name:$target_path"
$remote_scp "$backup_file" "$name:$target_path" || {
    echo "Error: Failed to send $backup_file to $name"
    exit 1
}
echo "Backup file $backup_file sent to $name:$target_path"

echo "Removing remote file: $remote_cmd rm -f $target_path/$(basename "$backup_file")"
$remote_cmd "rm -f $target_path/$(basename "$backup_file")" || echo "Warning: Failed to remove $backup_file from $name"

backup_files_count_on_server=$($remote_cmd "ls -1 $target_path/*.tar.gz 2>/dev/null | wc -l")
echo "Remote backup files count: $backup_files_count_on_server"
if [ "$backup_files_count_on_server" -gt 10 ]; then
    oldest_file_on_server=$($remote_cmd "ls -1 $target_path/*.tar.gz | sort | head -n 1")
    echo "Removing oldest file on server: $oldest_file_on_server"
    $remote_cmd "rm -f $oldest_file_on_server" || echo "Warning: Failed to remove $oldest_file_on_server from $name"
fi

echo "Backup for $name completed at $(date)"
