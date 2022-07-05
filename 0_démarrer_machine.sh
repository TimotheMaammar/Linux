#!/bin/bash

########################################
# Nom : d�marrer_machine.sh
# Utilit� : d�marrage d'une VM � distance
# Usage : ./d�marrer_machine.sh
# Auteur : SGT MAAMMAR
# Derni�re mise � jour le : 04/03/2020
########################################

folder="/vm"
# Dossier des trois VM

var=`find $folder -mindepth 1 -maxdepth 1 -type d \! -newermt 2020-02-28 -group adminbri4 -exec basename {} \; | grep -vi Trash`
# On cherche tous les dossiers qui sont seulement dans le dossier /vm, qui ont �t� cr��s avant le 28 f�vrier et qui appartiennent au groupe adminbri4
# 'basename' extrait le nom du dossier lui-m�me, ce qui permet de retirer le '/vm' g�nant
# 'grep -vi Trash' sert � virer les dossiers '.Trash' qui sont des corbeilles et non des VM

array=($var)
# On met la variable obtenue dans un tableau pour pouvoir s�parer les trois VM et les s�lectionner avec 'array[x]'

VM_1="/vm/${array[0]}/Windows Server 2012/Windows Server 2012.vmx"
VM_2="/vm/${array[1]}/Windows Server 2012/Windows Server 2012.vmx"
VM_3="/vm/${array[2]}/Windows Server 2012/Windows Server 2012.vmx"
# Notre structure est la m�me partout donc facile d'avoir les trois chemins pseudo-dynamiquement

machine=$(whiptail --title "Choix de la machine" --menu "Quelle machine d�marrer ?" 15 60 4 \
"${array[0]}" "${array[0]}" \
"${array[1]}" "${array[1]}" \
"${array[2]}" "${array[2]}" \
"quitter" "Quitter"  3>&1 1>&2 2>&3)
# Menu Whiptail avec les trois cases du tableau + 'Quitter'

exitstatus=$?

if [ $exitstatus = 0 ] # Si tout s'est bien pass�
then
	case $machine in 
	"${array[0]}")
    	machine_to_start=$VM_1
	;;
	"${array[1]}")
	machine_to_start=$VM_2
	;;
	"${array[2]}")
	machine_to_start=$VM_3
	;;
	"quitter")
	exit 0
	;;
	esac
# En fonction du choix de l'utilisateur on met l'une des trois VM dans la variable 'machine_to_start'
	
	sudo rm -r /vm/$machine/Windows\ Server\ 2012/*.lck 2>> Logs.txt
	# Suppression des �ventuels .lck qui bloquent souvent le d�marrage
	# On retrouve le dossier dynamiquement donc on ne supprime que les .lck li�s � la machine que l'on veut red�marrer

	echo $machine_to_start
	sudo vmrun -T ws start "$machine_to_start" nogui 2>> Logs.txt
	# On d�marre la machine s�lectionn�e

else # Retour au menu principal en cas d'annulation de l'utilisateur
   sudo /home/supervision/Scripts_E4/Machines_virtuelles/vmrun.sh
fi

