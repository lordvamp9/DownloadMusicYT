import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "Cola de Descargas"
            color: "white"
            font.pixelSize: 24
            font.bold: true
        }

        ListView {
            id: downloadsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10
            model: globalDownloadQueue

            delegate: GlassEffect {
                width: ListView.view.width
                height: 80
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 15

                    // Thumbnail Mock
                    Rectangle {
                        width: 60
                        height: 60
                        radius: 4
                        color: "transparent"
                        clip: true
                        Image {
                            anchors.fill: parent
                            source: model.thumbnail
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        
                        Text {
                            text: model.title
                            color: "white"
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            ProgressBar {
                                Layout.fillWidth: true
                                value: model.progress / 100.0
                            }
                            Text {
                                text: model.progress + "%"
                                color: "white"
                            }
                        }

                        Text {
                            text: model.status
                            color: model.status === "Completado" ? "#00ff00" : (model.status === "Error" ? "red" : "#00aaff")
                            font.pixelSize: 12
                        }
                    }

                    Button {
                        text: "✕"
                        width: 40
                        height: 40
                        onClicked: {
                            globalDownloadManager.cancelDownload(model.videoId)
                            globalDownloadQueue.removeDownload(model.videoId)
                        }
                    }
                }
            }
        }
    }
}
