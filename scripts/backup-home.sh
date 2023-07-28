#!/bin/bash

# Backup ausgewählter Verzeichnisse
# das Backup soll archiviert und komprimiert werden (tar, bzip2)
# die Backup-Datei soll einen Zeitstempel im Dateinamen haben
# Überpüfung der Berechtigungen beim Aufruf des Skripts (root-Rechte nötig)
# Je nach Aufruf soll das Skript komplett automatisch ablaufen oder nach bestimmten Angaben (zu sichernde Verzeichnisse etc.) fragen
# Opt1: Übertragung der Backupdateien auf anderen Server

# TODO:
# [x] Verzeichnis /root/backups erstellen
# [ ] $USER ändern (bei Aufruf Skript von root)

# Check if user has root privileges
# TODO: Check if this still works if scripts is executed with sudo
if [ $EUID -ne 0 ]; then
  echo Zur Ausführung des Skripts sind root-Rechte nötig.
  echo Skript wird beendet.
  exit 1
fi

# [ $EUID -ne 0 ] || echo Zur Ausführung des Skripts sind root-Rechte nötig ;  echo Skript wird beendet ; exit 1

# [ $EUID -ne 0 ] && exit 1

#dirs_to_backup="/home/$USER /etc /var/mail /var/log"
dirs_to_backup="/home"
backup_dest="/root/backups"
backup_file="backup_home_$(date +%Y%m%d_%H%M).tar.bz2"

mkdir -p $backup_dest

## TODO: check if dir is present

# Möglichkeit 2
#if [ ! -d $backup_dest ]
#then	
#  echo Create backup dir: $backup_dest
#  mkdir $backup_dest
#fi

# Möglichkeit 3
# [ -d $backup_dest ] || mkdir $backup_dest


# Create the backup
tar -cvjf $backup_dest/$backup_file $dirs_to_backup
