import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    //Properties
    Item {
        id: devices
        property string name
        property int current
        property int total
    }
    Item {
        id: files
        property string name
        property int current
        property int total
    }

    Item {
        id: bytes
        property int current
        property int total
    }
    property bool connected: false
    property bool transferring: false
    property bool displayOptions: false
    property string devicePlural: devices.total == 1 ? "body camera" : "body cameras"

    visible: true
    width: 320
    height: 240
    title: "Body Cam Interface"

    //layout
    Column {
        
        anchors.horizontalCenter: parent.horizontalCenter
        
        visible: !displayOptions
        width: parent.width
        Text {
            text: connected ? `${devices.total} ${devicePlural} ready for transfer.` : `Connect a body camera.`
            visible: !transferring && !devices.total
        }
        Text {
            text: "Connect a camera to begin."
            visible: !transferring && devices.total
        }
        Text {
            id: status
            text: "Transferring..."
            visible: transferring
        }
        ProgressComplex {
            visible: transferring
            cameraName: devices.name
            cameraCurrent: devices.current
            cameraTotal: devices.total
            fileName: files.name
            fileCurrent: files.current
            fileTotal: files.total
            bytesCurrent: bytes.current
            bytesTotal: bytes.total
        }
        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: button1
                text: transferring ? "Pause" : "Start" 
            }
            Button {
                id: button2
                text: transferring ? "Stop" : "Options"
            }
        }
    }
    Column{
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        visible: displayOptions
        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                width: 20
                height: 20
                id: back
                text: "<"
            }
            Text {
                text: "Options"
            }
        }
        
        ScrollView {
            anchors.horizontalCenter: parent.horizontalCenter
            id: scroller
            
            height: 300
            width: 200
            clip : true

            GridLayout{
                columns: 2
                Button {
                    text: "Shutdown"
                }
                Button {
                    text: "Restart"
                }
            }
        }
    }

    Timer {
        id: timer
        running: false
        repeat: true
        interval: 100
        property bool block
        property int i
        property int b
        property int f
        onTriggered: transferTest()
    }
    Connections {
        target: button1
        function onClicked(){
            timer.running = true
            transferring = true
            devices.total = 3
            files.total = 10
            bytes.total = 16384
            timer.i = 0
            timer.b = 0
            timer.f = 0
            transferTest()
        }
    }
    Connections {
        target: button2
        function onClicked(){
            if(transferring) {
                transferring = false
            }
            else{
                displayOptions = true
            }
        }
    }
    Connections {
        target: back
        function onClicked(){
            displayOptions = false
        }
    }
    function transferTest(){
        if(timer.i >= devices.total) {
            transferring = false
        }
        if(timer.f >= files.total){
            timer.i++
            timer.f = 0
        }
        if(timer.b >= bytes.total){
            timer.f++
            timer.b = 0
        }
        timer.b += 512
        devices.name = `Camera # ${timer.i}`
        devices.current = timer.i
        files.name = `test${timer.f}.mp4`
        files.current = timer.f
        bytes.current = timer.b
    }
}