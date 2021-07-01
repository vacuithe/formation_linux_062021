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

- Sortie output et redicection
  - stdin : clavier
  - stdout : sortie standard (1)
  - stderr : sortie d'erreur (2)

  - redirection : 
    ```
    > : redirige dans un fichier (écrasement)
    >> : redirige en fin fin de fichier (pas d'écrasement)

