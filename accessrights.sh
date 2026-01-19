#!/bin/bash

chemin_liste="/home/florian/Téléchargements/Shell_Userlist.csv"

{
    read   # ignore l'en-tête

    while IFS=',' read -r id prenom nom mdp role || [[ -n "$id" ]]; do
        [[ "$id" =~ ^[0-9]+$ ]] || continue

        id=$(echo "$id" | tr -d '\r' | xargs)
        prenom=$(echo "$prenom" | tr -d '\r' | xargs)
        nom=$(echo "$nom" | tr -d '\r' | xargs)
        mdp=$(echo "$mdp" | tr -d '\r' | xargs)
        role=$(echo "$role" | tr -d '\r' | xargs)

        username="${prenom,,}.${nom,,}"

        if id "$username" &>/dev/null; then
            echo "Utilisateur déjà existant : $username"
        else
            useradd -m "$username"
            echo "$username:$mdp" | chpasswd
            echo "Utilisateur créé : $username"
        fi

        if [[ "${role,,}" == "admin" ]]; then
            usermod -aG sudo "$username"
        fi

    done
} < "$chemin_liste"
