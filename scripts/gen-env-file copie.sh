#!/bin/bash

echo "=== Saisie ton env de taff ==="
echo "1) stage"
echo "2) dev"
echo "3) main"

# Demander le choix à l'utilisateur
read -p "Veuillez sélectionner un env (1, 2 ou 3) : " choix

# Gérer le choix avec une structure case
case $choix in
    1)
        cp file_config_env/stage/Info.plist ../CFQ/Utils/Plist/
        cp file_config_env/stage/GoogleService-Info.plist ../CFQ/Utils/Plist/
        ;;
    2)
        cp file_config_env/dev/Info.plist ../CFQ/Utils/Plist/
        cp file_config_env/dev/GoogleService-Info.plist ../CFQ/Utils/Plist/
        ;;
    3)
        cp file_config_env/main/Info.plist ../CFQ/Utils/Plist/
        cp file_config_env/main/GoogleService-Info.plist ../CFQ/Utils/Plist/
        ;;
    *)
        echo "Choix invalide. Veuillez relancer le script et entrer 1, 2 ou 3."
        ;;
esac
