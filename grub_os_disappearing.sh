#!/bin/bash
# Résolution du problème lié à GRUB apparu avec mes dernières mises à jour
# Windows 10 n'apparaissait plus dans le menu de démarrage

sudo -i
echo GRUB_DISABLE_OS_PROBER=false >> /etc/default/grub
update-grub
