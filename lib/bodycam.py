import usb.core
import usb.util
import usb.control

packetLen = 10
usbIn = 0xc0
usbOut = 0x40

# Get all devices connected to the syhstem matching 0x4255 0x0001
def getDevices():
    devGen = usb.core.find(idVendor=0x4255, idProduct=0x0001, find_all=True)
    if devGen is None:
        raise ValueError('Device not found')
    devList = [None] * 0    
    for dev in devGen:
        devList.append(dev)
    return devList

# Get number of devices not in USB mode
def getDeviceCount():
    devList = getDevices()
    x = 0
    for dev in devList:
        x += 1
    return x

# Connect USB Mode for all devices in a list, Params: devList: generator of devices
def connectAll(devList):
    x = 0
    for dev in devList:
        x += 1
        connect(dev) 
    print(f"Connection succeeded. {x} device{'s were' if not x == 1 else ' was'} connected.")
    return devList #give us our device iterator instance

# Connect USB Mode, Params: dev: deviceInstance
def connect(dev):
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

# Boiler plate code for connecting all devices and can be reused somewhere else
if __name__ == "__main__":
    #read pw from file
    f = open("pw", "r")
    pw = f.read().strip()
    f.close()
    devList = connectAll()
    for dev in devList:
        if login(dev, pw):
            enableDiskMode(dev)


