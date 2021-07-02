PS3="Votre choix : "
select item in "- Sauvegarde -" "- Restauration -" "- Fin -"
do
  echo "Vous avez choisi l'item $REPLY : $item"
  case $REPLY in
    1)
      echo "sauve"
      ;;
    2)
      echo "restaure"
      ;;
    3)
      echo "Fin du script"
      exit 0
      ;;
    *)
      echo "Choix incorrect"
      ;;
   esac
done