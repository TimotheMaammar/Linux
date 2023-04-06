#!/bin/bash
# Récupération de la clé publique d'OffSec puis chiffrement d'un fichier avec GPG

FICHIER=/home/timothe/Passeport.jpg	# À MODIFIER
FINAL="${FICHIER}.gpg"



curl -O https://www.offsec.com/registrar.asc --compressed
gpg --import registrar.asc
gpg --recipient registrar@offensive-security.com --encrypt $FICHIER



if [ $? -eq 0 -a $FINAL ]
then
    echo "Fichier chiffré généré avec succès :"
    ls $FINAL
else
    echo "Fail !"
fi




