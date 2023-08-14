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
#dirs_to_backup="/home" 
backup_destination="/root/backups"
backup_file="backup_home_$(date +%Y%m%d_%H%M).tar.bz2"

# Backup-Zielverzeichnis
backup_destination="/root/backups/"

# check if dir is present

# Möglichkeit 1
if [ ! -d $backup_destination ]
then	
  echo Create backup dir: $backup_destination
  mkdir $backup_destination
fi

# Möglichkeit 2
# [ -d $backup_destination ] || mkdir $backup_destination

# Create the backup

# Möglichkeit 1
#tar -cvjf $backup_destination/$backup_file $dirs_to_backup #nur Input per Variable

# Möglichkeit 2 (mit vorheriger Auswahl)
# Auszuwählende Verzeichnisse

ask_for_dirs () {
        echo "Bitte Verzeichnis aussuchen: "
        #auswahl=$(find /home/* -maxdepth 0 -type d -exec echo -e  {}\n \; | nl)
        find /home/* -maxdepth 0 -type d | nl
        read -p "Bitte Verzeichnisnummer auswählen: " selection
        directory=$(find /home/* -maxdepth 0 -type d | nl | grep $selection | cut -f2)
}

# Backup ausgewählter Verzeichnisse
backup_selected_directories() {
    # Hier gewünschte Verzeichnisse hinzufügen
    source_directories=($directory)

    for dir in "${source_directories[@]}"; do
        echo "Sichere Verzeichnis: $dir"
        tar -cvjf "${backup_destination}backup_$(date +'%Y%m%d_%H%M%S').tar.bz2" "$dir"
    done
}

# Backup des Heimatverzeichnisses
backup_home_directory() {
    echo "Sichere Heimatverzeichnis: $HOME"
    tar -cvjf "${backup_destination}backup_home_$(date +'%Y%m%d_%H%M%S').tar.bz2" "$HOME"
}

# Archivierung und Komprimierung (tar, bzip2) des Backups
create_backup() {
    # Backup ausgewählter Verzeichnisse
    backup_selected_directories

    # Backup des Heimatverzeichnisses
    #backup_home_directory
}

# Hauptfunktion, die das Backup erstellt
main() {
        ask_for_dirs
        create_backup

}

# Hauptfunktion aufrufen
main
