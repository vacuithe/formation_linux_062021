# Boucle while infinie :
# Creation d'un fichier flag pour manager la boucle while
touch run.lock
while true
do
  # Test presence fichier run.lock
  if [[ -e run.lock ]]
  then
    date >> ficlog.log
    echo "Ca tourne !" >> ficlog.log
    sleep 1
  else
    echo "run.lock inexistant"
    echo "Sortie..."
    exit 1 # sortie de la boucle ET du script
    # break  : utile pour sortie de la boucle mais continuer le script
  fi
done