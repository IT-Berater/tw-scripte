#!/bin/bash

#
# Dies start-gps.hs Script soll alles starten was für das wardrive nötig ist.
#
# 14.02.15 Thomas Wenzlaff
#
# 1. gpsd starten
# 2. LED an und warten auf Tastendruck
# 3. Zeit von GPSD ermittelt und setzen
# 4. Kismet Server starten
# 5. Warten auf Tastendruck warten.py
# 6. LED blinken
# 7. Kismet sauber runterfahren
# 8. gpsd runterfahren
# 9. System runterfahren
#
# (C) 2015 Thomas Wenzlaff http://www.wenzlaff.de
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see {http://www.gnu.org/licenses/}.
#
##############################################################################
echo 'Starte start-gps.sh Script ...'
/usr/bin/pkill gpsd
/usr/bin/pkill kismet_server

echo 'Starte gpsd Dämon im Hintergrund ...'
/etc/init.d/gpsd start
echo 'gpsd gestartet'

echo 'Warte bis GPS bereit ...'
/usr/bin/gpspipe -l -w -n 10 | grep -qm 1 '"mode":3'

echo 'Parse die aktuelle UTC Zeit von gpsd Ausgabe ...'
UTCDATE=`/usr/bin/gpspipe -w -n 10 | grep -m 1 "TPV" | sed -r 's/.*"time":"([^"]*)".*/\1/' | sed -e 's/^\(.\{10\}\)T\(.\{8\}\).*/\1 \2/'`
echo 'Die Zeit von gpsd:'
echo $UTCDATE
echo 'Setzt die aktuelle Systemzeit des Raspberry Pi'
/bin/date -u --set="$UTCDATE"

echo 'an-warte.py starten ...'
/root/autostart/an-warte.py
echo 'an-warte.py beendet, weiter ...'

echo 'Starte den Kismet Server im Hintergrund ...'
kismet_server --daemonize
echo 'Kismet Server gestartet'

echo 'warte.py starten'
echo 'Warte auf längeren Tastendruck bis die LED blinkt, zum sauberen runterfahren des Raspberry Pi ...'
/root/autostart/warte.py
echo 'warte.py beendet'

echo 'Warte bis der Kismet Server runtergefahren ist ...'
/usr/bin/pkill kismet_server
# warten bis Kismet seine Dateien gespeichert hat
/usr/bin/pgrep kismet
while [ $? = 0 ]
do
/bin/sleep 1
/usr/bin/pgrep kismet
done
echo 'OK, der Kismet Server ist sauber beendet.'

echo 'System sauber runterfahren ...'
/usr/bin/pkill gpsd
/bin/sleep 5
echo 'Starte nun shutdown now. Der Raspberry Pi kann gleich von der Stromversorgung getrennt werden.'
sudo shutdown now
