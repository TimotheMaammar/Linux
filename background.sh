#!/bin/bash
# Changement de fond d'écran

if [[ $# -ne 1 ]]
then
    echo "Utilisation : ./background.sh /path/to/file.png"
    exit 2
fi

sudo cp $1 /usr/share/desktop-base/kali-theme/login/background
