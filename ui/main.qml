import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    //Properties
    Material.theme: Material.Dark
    Material.accent: "#FFFFFF"
    Material.foreground: "#FFFFFF"
    Material.background: "#000000"
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
    property bool autoQueue
    property bool logs
    property alias logText: log.text
    property string devicePlural: devices.total == 1 ? "body camera" : "body cameras"

    visible: true
    width: 800
    height: 480
    title: "Body Cam Interface"
    //visibility: "FullScreen"

    //layout
    Column {
        topPadding: 5
        leftPadding: 5
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        
        visible: !displayOptions
        width: parent.width
        RowLayout{
            width: parent.width
            Column{
                Layout.alignment: logs ? Qt.AlignRight : Qt.AlignHCenter
                WText {
                    text: connected ? `${devices.total} ${devicePlural} ready for transfer.` : `Connect a body camera.`
                    visible: !transferring
                }        
                
                WText {
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
            }
            ScrollView {
                Layout.alignment: Qt.AlignRight
                visible: logs
                id: view
                implicitWidth: 300
                implicitHeight: 300
                rightPadding: 20
                clip: true

                TextArea {
                    id: log
                    text: ""
                    color: "#FFFFFF"
                    font.pointSize: 12
                    readOnly: true
                    wrapMode: TextEdit.Wrap
                    activeFocusOnPress: false
                    textMargin: 6
                    background: Rectangle {
                        border.width: 4
                        color: "#000000"
                        border.color: "#111111"
                    }
                }
            }
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
    Loader{
        source: "options.qml"
        visible: displayOptions
        anchors.horizontalCenter: parent.horizontalCenter
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