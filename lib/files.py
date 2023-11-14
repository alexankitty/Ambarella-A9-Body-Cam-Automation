import options
import subprocess
import os
import glob
import gps
import usbListen

fileServerMount = "./fileserver"
mountPath = "./mount"

def mountServer():
    if not os.path.isdir(fileServerMount):
        os.mkdir(fileServerMount)
    options.readSettings()
    subprocess.call(f'mount -t cifs {options.server_path} {fileServerMount} -o username={options.server_username},password={options.server_password},domain={options.domain},vers=3.0')

def unmountServer():
    #Make me safer, change my subprocess to a script that unmounts once no longer busy
    subprocess.call(f'umount {mountPath}')

def mountCamera(path):
    if not os.path.isdir(mountPath):
        os.mkdir(mountPath)
    subprocess.call(f"mount {path} {mountPath}")

def unmountCamera():
    #Make me safer, change my subprocess to a script that unmounts once no longer busy 
    subprocess.call(f"umount {mountPath}")

def extractCameraName(filename):
    #Write me
    print("")

def extractDate(filename):
    #Write me
    print("")

def extractTime(filename):
    #Write me
    print("")

def buildDirectoryTree(name, date):
    #split date into year month day
    year = 0
    month = 0 #two padded
    day = 0 #two padded
    baseDir = {fileServerMount}/{name}
    yearDir = f'{baseDir}/{year}'
    monthDir = f'{baseDir}/{year}/{month}'
    dayDir = f'{baseDir}/{year}/{month}/{day}'
    if not os.path.isdir(baseDir):
        os.mkdir(baseDir)
    if not os.path.isdir(yearDir):
        os.mkdir(yearDir)
    if not os.path.isdir(monthDir):
        os.mkdir(monthDir)
    if not os.path.isdir(dayDir):
        os.mkdir(dayDir)
    return dayDir

def copyAll(queue):
    usbListen.transferring = True
    mountServer()
    for dev in queue:
        copy(dev)
    unmountServer()
    #Write me
    print("")

def copy(devPath):
    mountCamera(devPath)
    for filename in glob.iglob(f'{mountPath}/DCIM/**', recursive=True):
        if os.path.isfile(filename): # filter dirs
            name = extractCameraName(filename)
            date = extractDate(filename)
            time = extractDate(filename)
            location = gps.getLocation(filename)
            dir = buildDirectoryTree(name, date)
            #copy the file
