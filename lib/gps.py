import subprocess
from geopy.geocoders import GoogleV3

def getLocation(videofile):
    #read apikey from file
    f = open("../googleApiKey", "r")
    googleApiKey = f.read().strip()
    f.close()

    geolocator = GoogleV3(api_key=googleApiKey)

    out = subprocess.run(['ffmpeg','-i',videofile, '-map', 's:0', '-f','ass','-'],\
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    subtitle = out.stdout
    subtitles = subtitle.split("Dialogue: ")
    subtitles = subtitles[1:]
    gpsArray = [None] * 0

    for dialogue in subtitles:
        dialogue = dialogue.split("  ")[1].strip()
        dialogue = dialogue.split("$G:")[1]
        leftover = dialogue.split(" ")
        date = leftover[0]
        leftover = leftover[1].split("-")
        time = leftover[0]
        latitude = leftover[1]
        if latitude[0] == "S":
            latitude = "-" + latitude[1:]
        else:
            latitude = latitude[1:]
        longitude = leftover[2]
        if longitude[0] == "E":
            longitude = "-" + longitude[1:]
        else:
            longitude = longitude[1:]
        gpsData = {
            "date": date,
            "time": time,
            "latitude": float(latitude),
            "longitude": float(longitude),
            "geoCoords": f'{latitude}, {longitude}'
            }
        gpsArray.append(gpsData)
    found = False
    for data in gpsArray:
        if data['latitude'] or data['longitude']:
            found = True
            location = geolocator.reverse(data['geoCoords'])
            return location[0].address
            break

    if not found:
        return "No Location"
