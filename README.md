# Formation Linux

## Matériel

- Carte mère : 

```$ sudo dmidecode```

- CPU :

```
$ sudo uname -p
$ cat /proc/cpuinfo
```

- Memoire :

```
$ free -h
```

- Périphériques :

```
$ lspci
$ lspci -v
$ lspci -n
```

- Disques

```
$ sudo fdisk -l
$ ls -l /dev/sd*
$ lsblk
```

- USB

```
$ lsusb
```

- NOYAU

```
$ uname -a
```


## Démarrage du systeme 

> SystemV

- RUNLEVEL : 7
    - 0 : arrêt du system
    - 1 : mode mono-utilisateur mode rescue (pas socket réseau, peu de processus) sans service réseau
    - 2 : Mode multi-users, systèmes de fichier monté, réseau
    - 3 : Mode multi-user, par défaut (sur-ensemble niveau 2), service partage à distance
    - 4 : Mode multi-user (spécifique, custom)
    - 5 : Mode multi-user + server graphique
    - 6 : reboot

- Voir son runlevel 
  ```
  $ runlevel
  ```
- Changer de runlevel
  ```
  $ telinit [numero]
  ```

> SystemdD

- RUNLEVEL

  Run level 0 => poweroff.target

  Run level 1 => rescue.target

  Run level 3 => multi-user.target

  Run level 5 => graphical.target

  Run level 6 => reboot.target

- Interroger runlevel

    ```
    $ systemctl get-default
    ```

- Définir le run level par défaut

    ```
    $ systemctl set-default multi-user.target
    ```

- Changer de runlevel

   ```
   systemctl isolate rescue.target
   ```

## Services

> SYSTEMD

- Interroger un service :

    ```
    $ systemctl status ssh
    ```

- Activer ou désactiver un service au boot :

   ```
   $ systemctl enable [service]
   $ systemctl disable [service]
   ```

   > Anciennement : chkconfig chez systemv

- On peut *masquer* un service : ne sera plus visible donc plus activable même manuellement

   ```
   $ systemctl mask [service]
   ```

- Creation de service 

    - Deux arbos : 
        -   /etc/systemd/system/ => services custom
        -   /lib/systemd/system/ => services système

https://access.redhat.com/documentation/fr-fr/red_hat_enterprise_linux/7/html/system_administrators_guide/sect-managing_services_with_systemd-unit_files

https://doc.ubuntu-fr.org/creer_un_service_avec_systemd


> SYSTEMV (va être abandonné)

 - Arbo qui contient tous les scripts de service à exécuter 

    ```
    $ ls -l /etc/init.d
    ```

 - Arbos correspondant aux runlevels qui contiennent des liens pour arrêter ou démarrer les services
   ```
   # ls -l /etc/rc
   rc0.d/ rc1.d/ rc2.d/ rc3.d/ rc4.d/ rc5.d/ rc6.d/ rcS.d/ 
   ```

 - Comande pour activer:desactiver les services :
   ```
   chkconfig
   ```


## Partitionnement LVM

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/index

https://doc.ubuntu-fr.org/lvm

- LVM est un ensemble d’outils de l’espace utilisateur Linux pour fournir des commodités de gestion du stockage (volumes).

- LVM (Logical Volume Manager) répond principalement aux besoins :

    - d’évolutivité des capacités de stockage
    - tout en assurant la disponibilité du service.


1. PV
2. VG
3. LV
4. FS
5. MOUNT


Ex commandes LVM2 :

```bash
# Physical volumes
$ pvdisplay
$ pvs
# Volume group
vgdisplay
vgs
# Logical volumes
lvdisplay
lvs
# Commande management lv
lvchange --help
lvextend --help
lvresize --help
lvresize -L+2G /dev/debian-vg/root
lvextend -L5G /dev/debian-vg/root 
lvextend -L5G /dev/debian-vg/home 
lvextend -L3G /dev/debian-vg/home 
# Commande FS (pour synchroniser la taille avec le LV)
resize2fs /dev/mapper/debian--vg-home
resize2fs /dev/mapper/debian--vg-root
# Commande interrogation montage FS -> pt de montage
df -hT

# Commande de création d'un LV
lvcreate --help
lvcreate -n data -L2G debian-vg 
lvs
# Commande de création d'un FS sur un LV
mkfs.ext4 /dev/debian-vg/data 
# Création du point de montage (répertoire)
mkdir /mydata
# Montage du FS sur le point de montage
mount /dev/debian-vg/data /mydata
# Persistence du montage pour reboot
ls -l /etc/fstab 
vi /etc/fstab 
/dev/mapper/debian--vg-data   /mydata    ext4   defaults  0 2
# /!\ Penser à vérifier la syntaxe du fichier /etc/fstab 
mount -a
# Démontage d'un FS
umount /mydata 

# Commande affichage FS / LV /montage
$ lsblk
$ df -hT
```


## SHELL - COMMANDES UNIX

 - Shell : interface en mode texte entre le noyau Linux et les utilisateurs
  - Plusieurs shell :
    - sh
    - ksh
    - bash (standard Linux Server)
    - zsh

- Invite de commande :
  
  ```
  $ : pas de pouvoir particulier
  # : root (admin)
  ~ : home directory
  clear : clean ecran
  ```

- Commandes usuels voir pdf

- commandes de comparaisons 

   - diff
   - sdiff
   - vimdiff

- Editeur vim 
  - On peut créer un fichier *.vimrc* dans sa home pour customiser l'éditeur
  - Voir pdf memento

- Recherche :
  - find
    ```
    $ find / -user stagiaire -type d -name "appli1*"
    $ find / -type f -size +30M
    $ find /home/pierre -type f -name "p*" -exec ls -l {} \;
    $ find /home/pierre -type f -name "p*" -exec rm {} \;
    $ find / -perm 777 -type f
    ```

- Sortie output et redirection
  - stdin : clavier (0)
  - stdout : sortie standard (1)
  - stderr : sortie d'erreur (2)

  - redirection : 
    ```
    > : redirige dans un fichier (écrasement)
    >> : redirige en fin fin de fichier (pas d'écrasement)
    < : stdind
    ---
    2> /dev/null : rediriger la sortie d'erreur dans une poubelle
    1> /root/output 2>&1 : rediriger la sortie d'erreur avec la sortie standard
    wc -l < fichier  : injecter fichier comme stdin dans la commande wc
    ---
    tee : affiche les output ET redirige dans un fichier
    # find / -perm 755 -type f 2>&1 | tee -a /monfichier.log
    ```

- Pipe, tube : | 

  - Traiter l'output d'une premiere commande dans une seconde commande
  ```bash
  $ ps -ef | grep pierre | awk '{ print $2}'
  $ cat /etc/passwd | awk -F ':' '{ print "Home utilisateur : " $6}'
  $ cat /etc/passwd | cut -d ':' -f 6
  $ cat /etc/passwd | cut -d ':' -f 1,6
  ```

- Environnement utilisateur :

  - Un ensemble de fichiers d'environnements sont chargé par automatiquement
    - /etc/profile (fichier d'environnement commun à tous les users) => au login-shell
    - ~/.profile => chargé au login-shell
    - ~/.bashrc => chargé au non-login shell

  - On peut créer des fichiers d'environnement qu'il faut sourcer manuellement
    ```bash
    $ source .monenv
    $ . ~/.monenv
    ```

  - env : lister ses variables d'environnement
  - echo $PATH : voir le contenu d'une variable 
  - créer une variable : debug=test
  - creer une variable d'environnement : export DEBUG=test

    > Penser à les créer dans les fichier de profile pour persister l'info

    > /!\ Modification de la variable PATH : export PATH=$PATH:/tmp:/home/formation (bien mettre le premier contenu $PATH)


## Utilisateur et droits

- 3 fichiers : 
  - /etc/passwd
  - /etc/group
  - /etc/shadow

- UID utilisateur : 0 à 999 réservé systeme

- useradd, usermod, userdell (/!\ : attention avec usermod et ajout de groupe :  usermod -aG)
- groupadd, groupmod, groupdel
- passwd

- Droits :

  - rwx => 7
    - r = 4
    - w = 2
    - x = 1
  - chmod => commande de changement des droits
    ```bash
    # chmod 754 fichier
    ```
  - Setgid: 2000 (héritage du groupe proprietaire pour tous les éléments créés sous le répertoire)
  - Setuid: 4000 (donne les droits du owner du fichier/binaire/script le temps de l'exécution)
  - Stickybit : 1000 (positionné sur un répertoire, les users qui peuvent accèder à ce répertoire ne pourront supprimer que les éléments leur appartenant)


  - umask : positionne les droits par défaut à la création d'un fichier/repertoire
    - Pour un fichier : on part des droits max 666 et on retranche le umask 
      - 0666 - 0022 = 0644
    - Pour répertoire : on part des droits max 777 et on retranche le umask
      - 0777 - 0022 = 0755
    - Les umask doivent être créés dans des fichiers d'environnement pour être chargé automatiquement sinon perte à la deconnexion.


## Protocole SSH

  - Serveur : 
    - openssh-server
    - systemctl status sshd
    - conf : /etc/ssh/sshd_config

  - Clés ssh :
    - client : ~/.ssh/id_ed22519
               ~/.ssh/id_ed22519.pub
               ~/.ssg/config (sauvegarde de connexion ssh)

    - Serveur : ~/.ssh/authorized_keys (/!\ au proprietaire et aux droits)

  - X forwarding => deport d'affichage
  - SSH socks proxy


## Gestionnaire packages:

- Gestionnaire de package :
  - Debian : apt
    - conf : /etc/apt => fichiers contenant les clés gpgp et les url des sources des repos à suivre
  - RedHat : yum et maintenant dnf (successeur => lié à python3)
    - conf : /etc/yum.repo.d

- Package :
  - Debian : .deb  => dpkg

    - On peut interroger le contenu d'un package ou connaitre la package associé à un package :
      ```bash
      $ dpkg -S /usr/bin/ssh
      $ dpkg -L openssh-client
      ```

  - RedHat : .rpm  => rpm

- En entreprise, on dispoe d'un serveur repo à l'intérieur du réseau. 
  - Les serveurs se synchronisent sur celui-ci plutôt que directement vers internet


## Archives 

- Grouper un ensemble de fichier :
  - améliore les perf pour transfert réseau
  - garantie l'intégrité des sources
  
- tar 
  - creation : tar cvf archive.tar dossier
  - visualisation : tar tvf archive.tar
  - extraction : tar xvf archive.tar

- compression : en plus de l'archivage
  - plusieurs type de compression : gz, bzip2, xz
    - tar czvf
    - tar cJvf

- /!\ au chemin dans l'archive (par défaut "/" est enlevé)


## Gestion des processus

 - Chaque commande shell, binaire, script ouvre un processus
 - On peut envoyer des signaux aux processus

 ```bash
 $ kill -l
 ```

 - Lister les process : ps 
 
 ```bash
 $ ps -f -U pierre
 ```

 - Priorité des processus : nice

 - Foreground / Background
   - par défaut un processus est lancé en foregrond => ne rend pas la main : 
      - CRTL+C pour quitter
      - CTRL+Z pour le stopper (sans le killer)
      - jobs pour afficher les processus stoppés oiu lancés en background
      - fg [id] => reprise du processus en foreground
      - bg [id] => reprise du processus en background

   - Déclenchement d'un processus en background : & et nohup
      - ./monscript & => /!\ le programme peut être killer en cas de perte de session
      - nohup ./monscript & => processus complètement détaché du processus parent utilisateur (pas de kill si perte de session)

## Analyse systeme

- top/htop
- vmstat (global)
- netstat
- nc
- iostat
- iperf
- lsof

## Logs système

- Outils par défaut : rsyslog
  - config : /etc/rsyslog.conf
  - custom config log : /etc/rsyslog.d/*.conf
  - Gestion des logs systeme via facility.priority
  - Commande logger pour entrer des outputs dans rsyslog

- Rotation des logs : logrotate

  - /usr/sbin/logrotate /etc/logrotate.conf => lancé par cron.daily
  - repertoire de conf : /etc/logrotate.d/*


- Mécanique de log implémentée par systemd : journald
  - Se marie bien avec les logs de services
  - /etc/systemd/journald.conf
  - commande : journalctl

     ```bash
     $ journalctl --since "2021-07-02 12:00:00" --until "2021-07-02 12:30:00" -u apache2
    ``` 

## Elevation de privilèges

- SUDO
  - audit des commandes lancé via sudo
  - ne pas divulguer les mots de passe
  - configuration par user, group, type de commandes
  - /!\ utiliser visudo pour l'édition pour éviter les erreur de syntaxe

  - /etc/sudoers
  - /etc/sudoers.d/*

  ```ini
  # User alias specification
  User_Alias DEVELOP = dev01, dev02

  # Cmnd alias specification
  Cmnd_Alias DEVELOP_CMD = /usr/bin/bash /home/pierre/formation/case.sh
  Cmnd_Alias DEVELOP_CMD2 =  /usr/bin/systemctl * apache2

  # User privilege specification
  root	ALL=(ALL:ALL) ALL

  # Allow members of group sudo to execute any command
  %sudo	ALL=(ALL:ALL) ALL

  DEVELOP ALL=(pierre:pierre) DEVELOP_CMD
  DEVELOP ALL=(root:root) DEVELOP_CMD2
  ```

## Expression regulières

- Utilisation dans les outils  : grep, awk, sed, bash

- Elements syntaxique des expressions régulière

    - grep -n --color "[bB][ao]b" exp.txt (affiche toutes les lignes contenant b et un numéro de ligne dans le fichier exp.txt)

    - grep -n --color "v[0-9]\{2,8\}:" exp.txt (affiche tous les mo)
    - grep -i --color "bab$" exp.txt   (affiche les lignes strictement contenan 'bab')
    - grep -c -v "." exp.txt (affiche les lignes vide)
    - grep -c "." exp.txt (affiche les lignes non vide)

    - "^$" (les lignes vide)
    - "^bab$" (les lignes strictement contenant bab)
    - "." (ligne qui contient au moins 1 caractère)

grep -E --color "bon(jour|soir)" exp.txt (trouver bonojour et bonsoir dans le fichier exp.txt)
grep -E --color "(t[aeioué])\1" exp.txt (voir en référence arrière)

---------------Consigne pour les expressions régulières---------------

-> Extraire d'un fichier les lignes ne contenant qu'une valeur entière positive

    ```
    grep  "^[0-9]\{1,\}$" tp
    grep -E "^[0-9]{1,}$" tp
    grep -E "^[0-9]+$" tp.txt
    ```
    
-> Extraire d'un fichier les lignes ne contenant qu'une valeur entière (positive ou négative)
  
  ```
  grep -E "^-?[0-9]+$" tp.txt
  ```

-> Extraire d'un fichier les lignes ne contenant qu'une valeur numérique (entière, décimale, positive ou négative)                                     
  
  ```
  grep -E "^-?[0-9]+([,.][0-9]+)?$" tp.txt
  ```
  
-> Représenter une valeur numérique de 0 à 255

  ```
  grep -E "^([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$" tp.txt
  ```