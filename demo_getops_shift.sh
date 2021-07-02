#!/bin/bash

# Presentation de la fonction getopts pour gérer et différencier les options des arguments

# Fonction usage pour l'aide utilisateur
usage()
{
  echo "Usage : ${0} [-v]"
  echo "   -v : mode verbose on"
  exit 1
}

while getopts ":vf:" option
do
  echo "getopts a trouvé l'option : ${option}"
  case ${option} in 
    v)
      echo "Option v :"
      echo "OPTIND : ${OPTIND}"
      ;;
    f)
      echo "Option f avec argument ${OPTARG}"
      file=${OPTARG}
      ;;
    \?)
      echo "Option invalide : ${OPTARG}"
      usage
      ;;
    :)
      echo "L'option ${OPTARG} requiert un argument"
      usage
      ;;
  esac
done

echo "Nbre d'incides : ${OPTIND}"
echo "Analyse des options terminée"

echo "Fichier passé en option : ${file}"

echo "Nombre de paramètre : $#"
echo " Paramètre 1 : $1"
echo " Paramètre 1 : $2"

shift "$(( OPTIND - 1 ))"

echo "Nombre de paramètres après le shift : $#"
echo "Paramètre 1 : $1"