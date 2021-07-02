# Boucle while infinie :
# Creation d'un fichier flag pour manager la boucle while

# declarer une fonction en cas de signal SIGINT
catchsigint() {
  echo "Signal CTRL+C recu"
  rm ficlog.log
  exit 1
}

# Utilisation commande trap pour traiter le signal SIGINT (kill -2 ou CTRL+C)
trap catchsigint SIGINT


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