import json

auto_queue = False
view_logs = False
server_path = ""
server_username = ""
server_password = ""
domain = ""

def readSettings():

    f = open("../settings.json", "r")

    if f:
        data = json.load(f)
        auto_queue = data['auto_queue']
        view_logs = data['view_logs']
        server_path = data['server_path']
        server_username = data['server_username']
        server_password = data['server_password']
        domain = data["domain"]
        f.close()
    else:
        #initialize settings
        f.close()
        saveSettings()

def saveSettings():
    data = {
        "auto_queue": auto_queue,
        "view_logs": view_logs,
        "server_path": server_path,
        "server_username": server_username,
        "server_password": server_password,
        "domain": domain
    }
    json_object = json.dumps(data, indent=4)
    with open("../settings.json", "w") as outfile:
        outfile.write(json_object)