#/bin/bash
# Extraction des adresses IP qui se sont déjà connectées à un site spécifique à travers le Squid


SITE=simat # Changer le nom du site ici

cat /var/log/squid/access.log | grep $SITE | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u | more ### >> Résultat.txt
