#!/bin/bash
#
#   pdf-to-dropbox.sh Version 1.0 vom 04.01.2014
#
#   Dieses Script kopiert PDFs aus dem lokalen Spooler Verzeichnis in ein Dropbox Verzeichnis.
#
#   (C) 2014 Thomas Wenzlaff http://www.wenzlaff.de
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see {http://www.gnu.org/licenses/}.
#

# Das Verzeichnis wo dieses Script liegt
temp='/home/pi/tw-scripte'
# Dropbox Ziel-Verzeichnis
dropbox_pdf_out="/pdf-output"
# Verzeichnis wo der Dropbox-Uploader installiert wurde
dropboxUploader_dir='/home/pi/Dropbox-Uploader'
# Das / Verzeichnis ist das /Apps/twuploader Verzeichnis ist so im uploader eingestellt

# Lokaler Spoler auf dem rPi
lokaler_spooler="/home/pi/PDF" 
# Fuer Annonyous: /var/spool/cups-pdf/ANONYMOUS"

# Kopiere alle Dateien aus dem lokalen Spooler Verzeichnis: $lokaler_spooler in das Dropbox Verzeichnis (Apps/twuploader/) $dropbox_out"

# ersetzt Leerzeichen in der Schleife durch Zeilenumbruch
IFS=$'\n'

# überalle Dateien in der ersten Spalte iterieren
for PrintFile in $(/bin/ls -1 ${lokaler_spooler})
do
    # PDF Datei in Dropbox hochladen
    $dropboxUploader_dir/dropbox_uploader.sh -q upload "$lokaler_spooler/$PrintFile" $dropbox_pdf_out
    echo "PDF-Datei $PrintFile steht nun in der Dropbox im Verzeichnis $dropbox_pdf_out bereit."
    # PDF Datei im Spooler loeschen
    rm "$lokaler_spooler/$PrintFile"
done
