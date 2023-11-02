import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: progressComplex
    property string cameraName
    property int cameraCurrent
    property int cameraTotal
    property string fileName
    property int fileCurrent
    property int fileTotal
    property int bytesCurrent
    property int bytesTotal
    objectName: "ProgressComplex"
    height: childrenRect.height
    width: childrenRect.width
    anchors.horizontalCenter: parent.horizontalCenter
    ColumnLayout{
        Text {
            id: bodyCamText
            text: `Name: ${cameraName}`
        }

        Text {
            id: bodyCamProgInfo
            text: `Completed: ${cameraCurrent} / ${cameraTotal} `
        }

        RowLayout {
            ProgressBar {
                id: bodyCamProgress
                value: cameraCurrent / cameraTotal
            }
            Text {
                text: `${Math.floor((cameraCurrent / cameraTotal) * 100)}%`
            }
        }
        

        Text {
            id: fileNameText
            text: `Filename: ${fileName}`
        }

        Text {
            id: fileNameProgInfo
            text: `Files: ${fileCurrent} / ${fileTotal}`
        }

        RowLayout{
            ProgressBar {
                id: fileNameProgress
                value: fileCurrent / fileTotal
            }
            Text {
                text: `${Math.floor((fileCurrent / fileTotal) * 100)}%`
            }
        }

        RowLayout {
            Text {
                text: "Bytes: Transferred: "
            }
            Text {
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 63
                text: `${readableByteCount(bytesCurrent)}`
            }
            Text {
                text: "/"
            }
            Text {
                Layout.preferredWidth: 63
                text: `${readableByteCount(bytesTotal)}`
            }
        }
        RowLayout {
            ProgressBar {
                id: bytesProgres
                value: bytesCurrent / bytesTotal
            }
            Text {
                text: `${Math.floor((bytesCurrent / bytesTotal) * 100)}%`
            }
        }
        
    }
    //Javascript
    function readableByteCount(size){
        var kb = size / 1024
        var mb = kb / 1024
        var gb = mb / 1024
        var tb = gb / 1024
        var pb = tb / 1024
        if (pb > 1) return `${pb}PB`
        if (tb > 1) return `${tb}TB`
        if (gb > 1) return `${gb}GB`
        if (mb > 1) return `${mb}MB`
        if (kb > 1) return `${kb}KB`
        return `${size}B`
    }
}