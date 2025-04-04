#!/bin/bash
target_user=$1
target_ip=$2
target_path=$3
path=$4
name=$5
project_path=$6

mkdir "$project_path/.tmp/${name}"

date_time=$(date +"%Y-%m-%d_%H-%M-%S")
tar -czvf "$project_path/.tmp/${name}/${name}_${date_time}.tar.gz" -C "$path" .

backup_files_count=$(ls -1 $project_path/.tmp/$name/*.tar.gz | wc -l)

if [ $backup_files_count -gt 10 ]; then
    OLDEST_FILE=$(ls $project_path/.tmp/$name/*.tar.gz | sort | head -n 1)
    rm -rf "$OLDEST_FILE"
fi
