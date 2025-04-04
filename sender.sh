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
