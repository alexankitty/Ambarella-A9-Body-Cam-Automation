import pyudev
import bodycam
import options
import queue
import time

pending = bodycam.getDeviceCount()
options.readSettings()
transferring = False

def startMonitor():
    context = pyudev.Context()
    monitor = pyudev.Monitor.from_netlink(context)
    monitor.filter_by(subsystem='usb')

    for device in iter(monitor.poll, None):
        if device.action == 'add':
            pending = bodycam.getDeviceCount()
            if transferring and options.auto_queue:
                bodycam.connectAll()
                time.sleep(5)
                #Get the block device and and append it to the queue.
                