#!/bin/bash

## Enable IP blacklist to reject traffic from specific countries
## Inspired by https://www.linode.com/community/questions/11143/top-tip-firewalld-and-ipset-country-blacklist

## prerequisite: wget, firewalld


echo "Create the blacklist ipset"
  firewall-cmd --permanent --new-ipset=blacklist --type=hash:net --option=family=inet --option=hashsize=4096 --option=maxelem=200000

# this is where we'll keep the ip lists
BLACKLIST_DIR=/opt/blacklist 

echo "Make sure our source directory is clear"
  rm -rf $BLACKLIST_DIR 2> /dev/null

echo "Creating a source directory"
  mkdir -p /opt/blacklist
  pushd /opt/blacklist > /dev/null

printf "Obtain latest IP blocks from ipdeny.com" 
  wget -q http://www.ipdeny.com/ipblocks/data/countries/all-zones.tar.gz
  tar -xzf all-zones.tar.gz 

printf "Blocking specific countries one by one: "
  completed=0
  countries=( bd bg cn in ua ro ru )
  for country in "${countries[@]}"
    do
    : 
     printf "${country} "
     firewall-cmd --permanent --ipset=blacklist --add-entries-from-file=./${country}.zone
    completed=$((completed+1))
    done
  printf "\n .. ${completed} countries blocked\n" 

echo "Redirecting blacklist traffic to the drop zone"
  firewall-cmd --permanent --zone=drop --add-source=ipset:blacklist

echo "Reloading firewall rules"
  firewall-cmd --reload > /dev/null

TODAY=$(date '+%Y-%m-%d')

echo "Blacklist updated as of ${TODAY}" > readme.txt

  popd > /dev/null

echo All done!


