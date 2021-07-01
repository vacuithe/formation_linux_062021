# TP1

1. Créer un LV myapp de 2Go

    ```bash
    $ lvcreate -L2G -n myapp debian-vg
    ```
2. Créer un FS sur ce nouveau LV, le monter sur /myapp
   ```bash
   $ mkfs.ext4 /dev/mapper/debian--vg-myapp
   $ mkdir /myapp
   $ mount /dev/mapper/debian--vg-myapp /myapp
   ```
3. Persister le montage au boot dans /etc/fstab
   ```bash
   $ cat /etc/fstab
     drwxrwsr-x+   3 root myapp  4096 juil.  1 14:09 myapp
   $ mount -a
4. Créer un groupe myapp (groupadd)
   ```bash
   groupadd myapp
   ```

5. Créer deux users:
    - dev01 appartenant au groupe myapp
    - dev02 appartenant au groupe myapp
    ```bash
    $ useradd -G myapp -m -s /bin/bash dev01
    $ useradd -G myapp -m -s /bin/bash dev02
    ```
6. Positionner les droits et proriétaire sur /myapp
    ```bash
    drwxrwsr-x   3 root myapp  4096 juil.  1 14:09 myapp
    ```
    ```bash
    chmod 2755 /myapp
    ```

7. ACL 