# Ambarella A9 Body Cam Automation
Very simple scripts for putting an Ambrella A9 Body Cam into USB Mode, automating the file copy, and extracting the geo location

# Usage
Place your bodycam password in a `pw` file, run the script with `python enableUSBMode.py  
Place your apikey in a `googleApiKey` file.  
Place your samba (windows network share) credentials in a `sambaCreds` file.  
Fill in `mountPath` `fileServerMount` and `serverHost` in lines 3-6 of the `moveFiles.sh` script  
Use the `moveFiles.sh` script to automagically copy everything to your desired place.  
