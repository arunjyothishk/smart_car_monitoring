#!/usr/bin/python
"""
tmp_values
Temperature
voltage
Smoke
Humidity

"""
import gtk
from time import sleep

voltage ="Battery voltage level : \n\n"
temp = "Car room Temperature : \n\n"
mq2 ="Smoke/Alcohol Sense value : \n\n"
hum ="Car room Humidity Level : \n\n"
#ser =serial.Serial("/dev/ttyS0",9600)

class PyApp(gtk.Window):
    def _init_(self):
        super(PyApp, self)._init_()

        self.set_size_request(480, 296)
        self.set_position(gtk.WIN_POS_CENTER)
        self.connect("destroy", gtk.main_quit)
        self.set_title("Vehicle Monitor")


        table = gtk.Table(2, 2, True);

        info = gtk.Button("Temperature")
        warn = gtk.Button("Humidity")
        ques = gtk.Button("MQ2")
        erro = gtk.Button("Voltage")


        info.connect("clicked", self.on_info)
        warn.connect("clicked", self.on_warn)
        ques.connect("clicked", self.on_ques)
        erro.connect("clicked", self.on_erro)

        table.attach(info, 0, 1, 0, 1)
        table.attach(warn, 1, 2, 0, 1)
        table.attach(ques, 0, 1, 1, 2)
        table.attach(erro, 1, 2, 1, 2)


        self.add(table)
        self.show_all()

    def on_info(self, widget):
        """
        ser.write("temp")
        tm = ser.read()
        sleep(0.03)
        data_left =ser.inWaiting()
        tm += ser.read(data_left)
        """
        file_object =open("tmp_values","r")
        tm=file_object.readline()
        file_object.close()
        md = gtk.MessageDialog(self,
            gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_INFO,
            gtk.BUTTONS_CLOSE, temp +str(tm))
        md.run()
        md.destroy()


    def on_erro(self, widget):
        """
        ser.write("voltage")
        vt = ser.read()
        sleep(0.03)
        data_left =ser.inWaiting()
        vt += ser.read(data_left)
        """
        file_object =open("tmp_values","r")
        vt=file_object.readline()
        vt=file_object.readline()
        file_object.close()
        md = gtk.MessageDialog(self,
            gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_ERROR,
            gtk.BUTTONS_CLOSE,voltage+vt )
        md.run()
        md.destroy()



    def on_ques(self, widget):
        """
        ser.write("mq2")
        sm= ser.read()
        sleep(0.03)
        data_left =ser.inWaiting()
        sm += ser.read(data_left)
        """
        file_object =open("tmp_values","r")
        sm=file_object.readline()
        sm=file_object.readline()
        sm=file_object.readline()
        file_object.close()
        md = gtk.MessageDialog(self,
            gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_QUESTION,
            gtk.BUTTONS_CLOSE, mq2+sm)
        md.run()
        md.destroy()


    def on_warn(self, widget):
        """
        ser.write("hum")
        hm = ser.read()
        sleep(0.03)
        data_left =ser.inWaiting()
        hm += ser.read(data_left)
        """
        file_object =open("tmp_values","r")
        hm=file_object.readline()
        hm=file_object.readline()
        hm=file_object.readline()
        hm=file_object.readline()
        file_object.close()
        md = gtk.MessageDialog(self,
            gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_WARNING,
            gtk.BUTTONS_CLOSE, hum + hm)
        md.run()
        md.destroy()

PyApp()
gtk.main()