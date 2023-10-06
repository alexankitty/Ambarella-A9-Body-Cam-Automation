import usb.core
import usb.util
import usb.control
import sys

packetLen = 10
usbIn = 0xc0
usbOut = 0x40

def connect():
    # find our device
    dev = usb.core.find(idVendor=0x4255, idProduct=0x0001)

    # was it found?
    if dev is None:
        raise ValueError('Device not found')
    # set the active configuration. With no arguments, the first
    # configuration will be the active one
    dev.set_configuration()

    # get an endpoint instance
    cfg = dev.get_active_configuration()
    intf = cfg[(0,0)]

    ep = usb.util.find_descriptor(
        intf,
        # match the first OUT endpoint
        custom_match = \
        lambda e: \
            usb.util.endpoint_direction(e.bEndpointAddress) == \
            usb.util.ENDPOINT_OUT)

    assert ep is not None
    print("Connection succeeded.")
    return dev #give us our device instance

# Check password and log in. Params: dev: deviceInstance pw: string
def login(dev, pw):
    pwHex = pw.encode('utf-8').hex()
    loginPacketString = f'{("a1120012" + pwHex):0<128}'
    loginPacket = bytearray.fromhex(loginPacketString)
    dev.ctrl_transfer(usbOut, 85, 0x0080, 0, loginPacket);#Login - require for formality sake
    ret = dev.ctrl_transfer(usbIn, 85, 0x0080, 0, packetLen)
    if ret[2] != 1:
        raise ValueError("Password Incorrect, exiting.")
    else:
        print("Login successful.")
        return True

# Enables USB mode on the body cam Params: dev: deviceInstance
def enableDiskMode(dev):
    usbPacketString = f"{'a1230023':0<128}"
    usbPacket = bytearray.fromhex(usbPacketString)

    dev.ctrl_transfer(usbOut, 80, 0x0080, 0, usbPacket)#Enter USB Mode
    ret = dev.ctrl_transfer(usbIn, 85, 0x0080, 0, packetLen)
    print("Disk mode enabled, enjoy :)")

#read pw from file
f = open("pw", "r")
pw = f.read().strip()
f.close()
print(pw)
dev = connect()
if login(dev, pw):
    enableDiskMode(dev)


