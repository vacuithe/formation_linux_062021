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