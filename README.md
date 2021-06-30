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

## SUDO