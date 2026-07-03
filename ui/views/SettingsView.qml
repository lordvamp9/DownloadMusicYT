import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../components"

Item {
    id: root

    FolderDialog {
        id: folderDialog
        title: "Please choose a download folder"
        currentFolder: mainWindow.globalDownloadPath
        onAccepted: {
            mainWindow.globalDownloadPath = String(selectedFolder)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        Text {
            text: "Settings"
            color: "white"
            font.pixelSize: 28
            font.bold: true
            style: Text.Raised
            styleColor: "black"
        }

        GlassEffect {
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            radius: 12
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 25
                

                // Download Path
                RowLayout {
                    Text {
                        text: "Ruta de Descarga"
                        color: "white"
                        font.pixelSize: 16
                        Layout.preferredWidth: 200
                    }
                    
                    TextField {
                        id: pathField
                        Layout.fillWidth: true
                        text: mainWindow.globalDownloadPath.replace("file:///", "")
                        readOnly: true
                        color: "white"
                        font.pixelSize: 14
                        background: Rectangle {
                            color: Qt.rgba(0, 0, 0, 0.4)
                            border.color: Qt.rgba(1, 1, 1, 0.2)
                            radius: 4
                        }
                    }
                    
                    Button {
                        text: "Examinar..."
                        onClicked: folderDialog.open()
                        background: Rectangle {
                            color: parent.down ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.1)
                            border.color: Qt.rgba(1, 1, 1, 0.3)
                            radius: 4
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
