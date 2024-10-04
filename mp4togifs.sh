#!/bin/bash

# Script zum Umwandeln von allen *.mp4 Dateien aus einem Verzeichnis nach *.gif.
# Wenn es schon eine *.gif mit dem Namen der *.mp4 gibt wird die Datei nicht nochmal erzeugt.
# Kann für transformation von erzeugten Blender mp4 nach gif verwendet werden.
#
# Aufruf: ./mp4togifs.sh VERZEICHNIS
# z.B. um alle im lokalen Verzeichnis umzuwandeln:  ./mp4togifs.sh .
#
# Thomas Wenzlaff (c) 2024

#!/bin/bash

# Überprüfen, ob ffmpeg installiert ist
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg ist nicht installiert. Bitte installiere ffmpeg, um das Skript auszuführen."
    exit 1
fi

# Überprüfen, ob ein Verzeichnis als Argument übergeben wurde
if [ -z "$1" ]; then
    echo "Bitte ein Verzeichnis angeben."
    exit 1
fi

# Verzeichnis setzen
directory="$1"

# Name der Pallete für jede Datei
palette="$directory/palette.png"

# Überprüfen, ob das angegebene Argument ein Verzeichnis ist
if [ ! -d "$directory" ]; then
    echo "Das angegebene Argument ist kein Verzeichnis."
    exit 1
fi

# Alle mp4 Dateien im Verzeichnis durchsuchen
find "$directory" -type f -name "*.mp4" | while read -r mp4_file; do

    # Entferne die .mp4 Erweiterung
    base_name="${mp4_file%.mp4}"

    # Prüfen ob es eine entsprechende .gif Datei gibt
    if [ ! -f "${base_name}.gif" ]; then
        echo "OK: Keine .gif Datei für: ${mp4_file} vorhanden, erzeuge nun die $base_name.gif ..."

        # erzeugen einer Palette
        ffmpeg -nostdin -i "$mp4_file" -vf fps=30,scale=512:-1:flags=lanczos,palettegen "$palette"

        # umwandlung mit der pallete
        ffmpeg -nostdin -i "$mp4_file" -i "$palette" -filter_complex "fps=30,scale=512:-1:flags=lanczos[x];[x][1:v]paletteuse" -metadata artist="Thomas Wenzlaff" -metadata copyright="Copyright 2024 (c) by Thomas Wenzlaff wenzlaff.de" -metadata title="Art by Kleinhirn.eu" "$base_name.gif"

        echo "OK: Umwandlung von ${mp4_file} nach $base_name.gif erfolgreich"

        if [ -f "$palette" ]; then
           rm -f "$palette"
        fi
    fi
done
