#!/bin/bash

# Résolution du problème des connexions SSH qui plantent dès qu'on envoie une commande un peu trop lourde.
# C'est une simple ligne mais ce problème m'a terriblement emmerdé pour beaucoup de CTF alors je souhaite le garder précieusement.
# Si le problème persiste, diminuer encore plus la valeur et réessayer.

sudo ifconfig tun0 mtu 1000 up  
