#!/bin/bash

read -p "Voulez-vous continuer ? (yes/no)" reponse

case $reponse in
  yes|y|Y)
    echo "Ok on continue"
    ;;
  no)
    echo "STOP !!"
    exit 0
    ;;
  *) 
    echo "Autre choix invalide"
    exit 1
    ;;
esac

echo "fin du script"