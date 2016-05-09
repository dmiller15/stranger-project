#!/bin/bash

duck_list() {
  path=$1
  access=$2
  secret=$3
  duck --list cdis://$path --username $2 --password $3
}

duck_list_keys() {
  bucket=$1
  duck --list cdis://$bucket/ --username $2 --password $3
}
duck_path=$(which duck)

access=$1
secret=$2

if [ ! -n "$access" ]
then
  echo "Please input your access key"
  read access
  echo "Please input your secret key"
  read secret
fi

#echo "Please type one of the following commands, or CTRL-c to exit:"
#echo "1. List buckets \n2. List files in specified bucket\ne. Exit"
#read entry

while :
do
  echo "Please type one of the following commands, or CTRL-c to exit:"
  echo "1. List buckets \n2. List files in specified bucket\ne. Exit"
  read entry
  case $entry in
    #1) echo "listing buckets";;
    1) duck_list ''~'' $access $secret;;
    2) echo "Which bucket?"; read bucket; duck_list_keys $bucket $access $secret;;
    e) echo "Exiting";break;;
    *) echo "Invalid argument";;
  esac
done
