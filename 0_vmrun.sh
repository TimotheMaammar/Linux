#!/bin/bash

########################################
# Nom : vmrun_menu.sh
# Utilité : Menu pour les VM
# Usage : ./vmrun_menu.sh
# Auteur : SGT MAAMMAR 
# Dernière mise à jour le : 04/03/2020
########################################

choix=$(whiptail --title "Choix" --menu "vmrun_menu.sh" 15 60 4 \
"1" "Afficher les machines" \
"2" "Redémarrer une machine" \
"3" "Démarrer une machine" \
"4" "Quitter"  3>&1 1>&2 2>&3)
# Menu whiptail classique dont on stocke le résultat dans la variable $choix
 
exitstatus=$?

if [ $exitstatus = 0 ] # Si tout s'est bien passé
then
	case $choix in
	"1")
	liste_machines=`sudo vmrun -T ws list`
	whiptail --title "Liste des machines" --msgbox "$liste_machines" 50 50
	sudo /home/supervision/Scripts_E4/Machines_virtuelles/vmrun_menu.sh
	# On affiche la liste des VM puis on revient sur le menu
	;;
	"2")
	sudo /home/supervision/Scripts_E4/Machines_virtuelles/reboot_machine.sh
	;;
	"3")
	sudo /home/supervision/Scripts_E4/Machines_virtuelles/démarrer_machine.sh
	;;
	"4")
	exit 0
	;;
esac

else # Si annulation
    exit 0
fi
