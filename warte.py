#!/usr/bin/python
# coding=ISO-8859-1

# warte.py Script
#
# Thomas Wenzlaff (c) 2015 www.wenzlaff.info
#
# Dieses Script wartet bis die Taste einmal gedrückt wird und dann
# wird als Bestätigung die LED 10 mal blinken.
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
import RPi.GPIO as GPIO
import time

SCHALTER = 11
LED = 7

GPIO.setwarnings(False)

GPIO.setmode(GPIO.BOARD)
GPIO.setup(LED, GPIO.OUT) 
GPIO.setup(SCHALTER, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def blink( anzahl ):
 "Methode blinkt so oft wie anzahl"
 i = 0
 while (i < anzahl):
   GPIO.output(LED, True)
   time.sleep(0.1)
   GPIO.output(LED, False)
   time.sleep(0.1)
   i = i + 1
  

print "Start warte.py um %s Warte nun auf Tastendruck..." % time.ctime()

while True:
	input_state = GPIO.input(SCHALTER)
	time.sleep(2)
	if input_state == False:
		print "Taste wurde gedrückt"
		print "10 mal blinken ..."
 		blink(10)
		break

print "Das warten.py Script ist nun um %s zu Ende" % time.ctime()
