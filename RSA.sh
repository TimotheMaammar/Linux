#!/bin/sh
# Script permettant de récupérer une clé publique RSA à l'aide d'une requête HTTP GET puis de chiffrer un texte avec cette clé.
# C'est surtout une somme de quelques lignes pratiques créées et utilisées individuellement mais que je souhaite garder de côté.



# Variables à modifier.
#
URL_CLE="http://site/dossier/key"
TEXTE="XXX"



# Récupération de la clé et épuration des mauvais caractères.
# L'option '-s' permet de ne renvoyer que le contenu utile, donc dans ce cas la clé au format PEM.
#
CLE=`curl -s $URL_CLE | sed 's/"-----BEGIN PUBLIC KEY-----"//g' | sed 's/"-----END PUBLIC KEY-----"//g' | sed 's/[][\"\,]//g' | tr -d " "`
echo "Clé : \n $CLE \n"



# Conversion de la clé en hexadécimal.
# Il est très important de dégager les retours à la ligne.
#
CLE_HEXA=`echo $CLE | tr -d "\n" | xxd -p`
echo "Clé convertie en hexadécimal : \n $CLE_HEXA \n"



# Chiffrement du texte avec la clé publique.
# Il est très important de dégager les retours à la ligne.
#
echo -n "TEXTE" | openssl dgst -sha256 -mac HMAC -macopt hexkey:$CLE_HEXA
