#!/bin/bash
#
# Combinaison de plusieurs scans pour ne louper aucun port
# On ne peut pas se reposer que sur AutoRecon parce qu'il est souvent extrêmement long
# Et le fait de croiser les outils limite considérablement les chances de louper un port
# Les scans sont lancés en parallèle mais les affichages peuvent se chevaucher un peu



if [[ $# -ne 1 ]] ; then
    echo "Utilisation : ./Reconnaissance_OSCP.sh [IP]"
    exit 1
fi



NOM=`echo $1 | cut -d . -f 4`

mkdir $NOM

cd $NOM

# nc -z -n -vv -w 1 $1 1-65535 >> nc.txt 2>&1 &

sudo nmap -p- -sV -T4 -sC $1 -oN nmap.txt &

sudo masscan -p1-65535,U:1-65535 $1 -e tun0 -oG masscan.txt &

sudo /home/timothe/.local/bin/autorecon $1

wait

exit 0
