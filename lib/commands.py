import subprocess
import sys

def shutdown():
    subprocess.call("shutdown now")

def restart():
    subprocess.call("reboot")

def quit():
    sys.exit(0)