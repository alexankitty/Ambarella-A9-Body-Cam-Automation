import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Column{
    spacing: 5
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    Row {
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        Button {
            width: 20
            height: 30
            id: back
            text: "<"
        }
        WText {
            font.pointSize: 14
            text: "Options"
        }
    }
    
    ScrollView {
        anchors.horizontalCenter: parent.horizontalCenter
        id: scroller
        
        height: 300
        clip : true

        GridLayout{
            columns: 2
            Button {
                text: "Shutdown"
            }
            Button {
                text: "Restart"
            }
            Button {
                text: logs ? "Hide Logs" : "Show Logs"
            }
            Button {
                text: "Return to Desktop"
            }
            Button {
                text: autoQueue ? "Disable Auto Queue" : "Enable Auto Queue" 
            }
        }
    }
    Connections {
        target: back
        function onClicked(){
            displayOptions = false
        }
    }
}