#!/bin/bash
#
#   Script zur Ausgabe der CPU Temperatur auf einem Raspberry Pi mit Kali Linux
#
#   (c) Thomas Wenzlaff 2015 www.wenzlaff.info
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
#
if [ "$1" = "-g" ]
then
echo .1.3.6.1.2.1.25.1.8
echo gauge
temp=`cat /sys/class/thermal/thermal_zone0/temp`
echo $temp
fi
exit 0

