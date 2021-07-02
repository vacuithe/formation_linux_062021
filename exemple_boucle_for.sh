#!/bin/bash
for ((i=0 ; i<=6 ; i++))
do 
  echo $i
done


for rep_home in $(cat /etc/passwd | cut -d ':' -f 6)
do
  echo "Contenu de $rep_home" && ls -l $rep_home
done