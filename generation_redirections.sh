#!/bin/bash

numberOfFiles=10

for ((i=1; i<=numberOfFiles; i++)); do
    nextFile=$(( (i % numberOfFiles) + 1 ))
    fileName="redirection_$i.php"

    content="<?php\nheader(\"Location: redirection_$nextFile.php\");\nexit;\n?>"

    echo -e "$content" > "$fileName"
    echo "Fichier généré : $fileName pointe vers redirection_$nextFile.php"
done
