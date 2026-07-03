import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.vamp9.ytmusic 1.0
import "../components"

Item {
    id: root
    
    InnertubeClient {
        id: apiClient
        onSearchCompleted: (results) => {
            searchModel.clear()
            for (var i = 0; i < results.length; i++) {
                searchModel.append(results[i])
            }
            loadingIndicator.running = false
        }
        onErrorOccurred: (errorString) => {
            console.log("Error: " + errorString)
            loadingIndicator.running = false
        }
    }

    Component.onCompleted: {
        loadingIndicator.running = true
        apiClient.search("top hits pop")
    }

    ListModel {
        id: searchModel
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20

        // Search Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            TextField {
                id: searchInput
                Layout.fillWidth: true
                placeholderText: "Search YouTube Music..."
                font.pixelSize: 16
                color: "white"
                background: GlassEffect {
                    radius: 20
                }
                padding: 12
                onAccepted: {
                    loadingIndicator.running = true
                    apiClient.search(text)
                }
            }

            Button {
                text: "Buscar"
                onClicked: {
                    loadingIndicator.running = true
                    apiClient.search(searchInput.text)
                }
                background: GlassEffect {
                    radius: 20
                    color: parent.down ? Qt.rgba(0.5, 0.5, 0.5, 0.5) : Qt.rgba(0.3, 0.3, 0.3, 0.5)
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        BusyIndicator {
            id: loadingIndicator
            Layout.alignment: Qt.AlignHCenter
            running: false
            visible: running
        }

        // Results Grid
        GridView {
            id: resultsGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 240
            cellHeight: 280
            model: searchModel
            clip: true

            delegate: Item {
                width: 220
                height: 260
                
                GlassEffect {
                    anchors.fill: parent
                    radius: 12
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        // Thumbnail
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 120
                            color: "transparent"
                            radius: 8
                            clip: true
                            Image {
                                anchors.fill: parent
                                source: model.thumbnail
                                fillMode: Image.PreserveAspectCrop
                            }
                        }
                        
                        Text {
                            Layout.fillWidth: true
                            text: model.title
                            color: "white"
                            font.bold: true
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                        }
                        
                        Text {
                            Layout.fillWidth: true
                            text: model.author + " • " + model.duration
                            color: "#d0d0d0"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                        
                        Item { Layout.fillHeight: true } // Spacer
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Button {
                                text: "MP3"
                                Layout.fillWidth: true
                                background: Rectangle {
                                    color: Qt.rgba(0.2, 0.6, 1.0, 0.6)
                                    radius: 6
                                }
                                contentItem: Text { text: parent.text; color: "white"; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                                onClicked: {
                                    var globalPos = mapToItem(null, 0, 0)
                                    mainWindow.animateDownload(globalPos.x + width/2, globalPos.y + height/2)
                                    
                                    globalDownloadQueue.addDownload(model.videoId, model.title, model.thumbnail)
                                    globalDownloadManager.startDownload(model.videoId, true, mainWindow.globalDownloadPath.replace("file:///", ""))
                                }
                            }
                            Button {
                                text: "MP4"
                                Layout.fillWidth: true
                                background: Rectangle {
                                    color: Qt.rgba(1.0, 0.4, 0.2, 0.6)
                                    radius: 6
                                }
                                contentItem: Text { text: parent.text; color: "white"; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                                onClicked: {
                                    var globalPos = mapToItem(null, 0, 0)
                                    mainWindow.animateDownload(globalPos.x + width/2, globalPos.y + height/2)
                                    
                                    globalDownloadQueue.addDownload(model.videoId, model.title, model.thumbnail)
                                    globalDownloadManager.startDownload(model.videoId, false, mainWindow.globalDownloadPath.replace("file:///", ""))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
