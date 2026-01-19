#!/bin/bash
user="laplateforme"
date=$(date +"%d-%m-%Y-%Hh%M")

dossier_backup="$HOME/Backup"
nom_fichier="number_connection $date"
nom_archive="$nom_fichier.tar"

mkdir -p "$dossier_backup"

nb_connections=$(last "$user" | grep -w "$user" | wc -l)
echo "le nombre de connexion d'utilisateur est de : $nb_connexions connexions " > "$nom_fichier"

tar -cf "$nom_archive" "$nom_fichier"

mv "$nom_archive" "$dossier_backup"

rm "$nom_fichier"

