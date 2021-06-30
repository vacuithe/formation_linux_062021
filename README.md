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
```

## SUDO