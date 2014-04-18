#!/bin/bash
#
#   dir-to-pdf.sh Version 1.0 vom 04.01.2014
#
#   Dieses Script holt alle Dateien aus einem Dropbox Verzeichnis in ein lokales
#   Verzeichnis und druckt PDF Dateien mit CUPS. Die verarbeiteten Dateien werden
#   dann in ein anderes Dropbox Verzeichnis verschoben.
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

# Dropbox Verzeichnis mit den Dateien die als PDF gedruckt werden sollen
# ist das /Apps/twuploader/input Verzeichnis

# Das Verzeichnis wo diese Script liegt
temp='/home/pi/tw-scripte'
# Dateien werden von Dropbox lokal auf den pi hierhin kopiert, das input Text-Verzeichnis
temp_in="$temp/input"
# Verzeichnis wo die verarbeiteten Dateien abgelegt werden
temp_out="$temp/output"
# Verzeichnis wo der Dropbox-Uploader installiert wurde
dropboxUploader_dir='/home/pi/Dropbox-Uploader'
# Das / Verzeichnis ist das /Apps/twuploader Verzeichnis ist so im uploader eingestellt

# Kopieren von Dropbox Verzeichnis /Appt/twupload/input in das temp Verzeichnis
# -q Quiet Mode, keine Ausgabe 
$dropboxUploader_dir/dropbox_uploader.sh -q download /input ${temp}

IFS=$'\n'

for PrintFile in $(/bin/ls -1 ${temp_in})
do
    # Kopieren der input Datei ins output Verzeichnis
    cp "$temp_in/$PrintFile" "$temp_out/$PrintFile"

    # Kopiere Orginal-Datei ins output Verzeichnis der Dropbox
    $dropboxUploader_dir/dropbox_uploader.sh upload "$temp_in/$PrintFile" /output

    # "Drucke in spooler und loesche nach erfolg die Datei $PrintFile"
    # Drucke Datei (lösche mit -r die eingabe Date)
    lpr -r $temp_in/$PrintFile

    # Erzeugte PDF nach Dropbox hochladen, geht ja nur wenn der Druckspooler asyncron die PDF erzeugt hat
    # Das wird dann in dem Script pdf-to-dropbox.sh erledigt

    # Loeschen der input Datei in der Dropbox
    $dropboxUploader_dir/dropbox_uploader.sh -q delete "/input/$PrintFile"
done

# CUPS Spooler Verzeichnise /var/spool/cups-pdf/ANONYMOUS/
#                           /home/pi/PDF/
