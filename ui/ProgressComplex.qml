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
    ColumnLayout{
        
        RowLayout{
            WText {
                text: `Name:`
            }
            WText {
                rightPadding: 15
                Layout.fillWidth: true
                horizontalAlignment: WText.AlignRight
                text: `${cameraName}`
            }
        }

        RowLayout{
            WText{
                text: "Completed"
            }
            WText{
                rightPadding: 15
                Layout.fillWidth: true
                horizontalAlignment: WText.AlignRight
                text: `${cameraCurrent} / ${cameraTotal}`
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            ProgressBar {
                id: bodyCamProgress
                value: cameraCurrent / cameraTotal
            }
            WText {
                text: `${Math.floor((cameraCurrent / cameraTotal) * 100)}%`
            }
        }
        
        RowLayout{
            WText{
                text: "Filename:"
            }
            WText{
                rightPadding: 15
                Layout.fillWidth: true
                horizontalAlignment: WText.AlignRight
                text: `${fileName}`
            }
        }

        RowLayout{
            WText{
                text: "Files:"
            }
            WText{
                rightPadding: 15
                Layout.fillWidth: true
                horizontalAlignment: WText.AlignRight
                text: `${fileCurrent} / ${fileTotal}`
            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignHCenter
            ProgressBar {
                id: fileNameProgress
                value: fileCurrent / fileTotal
            }
            WText {
                text: `${Math.floor((fileCurrent / fileTotal) * 100)}%`
            }
        }

        RowLayout {
            WText {
                text: "Bytes: Transferred: "
            }
            WText {
                horizontalAlignment: WText.AlignRight
                Layout.preferredWidth: 63
                text: `${readableByteCount(bytesCurrent)}`
            }
            WText {
                text: "/"
            }
            WText {
                Layout.preferredWidth: 63
                text: `${readableByteCount(bytesTotal)}`
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            ProgressBar {
                id: bytesProgres
                value: bytesCurrent / bytesTotal
            }
            WText {
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