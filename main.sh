#!/usr/bin/python

import serial
import os
from time import sleep
om="omxplayer /home/pi/voice\ files/"
#var=input("name port : ")
ser =serial.Serial("/dev/ttyS0",9600)
commands=["temp","voltage","mq2","hum","ir","status"]
values=["","","","","",""]
announced=False
dl=.4
critic_hum =98
critic_temp=31
critic_voltage=12.30
critic_smoke=700
bat=True
#os.system("./gtk.sh")
while True:
    for i in commands:
        ser.write(i)
        received = ser.read()
        sleep(0.03)
        data_left =ser.inWaiting()
        received += ser.read(data_left)
        values[commands.index(i)]=received+"\n"
#        print(i+" "+"value is "+ received)
        sleep(1)
    print(values)
    file_object =open("tmp_values","w")
    file_object.writelines(values)
    file_object.close()
    if(values[0]>critic_temp):
        os.system(om+"temp.mp3")
        sleep(dl)
    if(values[1]<critic_voltage):
        bat=False
        os.system(om+"battery.mp3")
        sleep(dl)
    else:
        bat=True
    if(values[2]>critic_smoke):
        os.system(om+"smoke.mp3")
        sleep(dl)
    if(values[3]>critic_hum):
        os.system(om+"hum.mp3")
        sleep(dl)
    if(values[5]=="opened\n" and  bat and (not announced)):
        os.system(om+"liv.mp3")
        sleep(dl)
        os.system(om+"enter.mp3")
        announced=True
        sleep(dl)
        os.system(om+"exit.mp3")
        sleep(dl)
#    os.system('clear')
"""
nd "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-MqdFK8/pygtk/
pi@ra
"""