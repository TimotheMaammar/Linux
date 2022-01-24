#!/bin/bash
# Ajout de ".txt" à la fin du nom de chaque fichier trouvé dans le répertoire courant

find . -type f -exec bash -c 'mv "$0" "$0.txt"' {} \; 
