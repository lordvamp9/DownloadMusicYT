import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import com.vamp9.ytmusic 1.0
import "../components"

Item {
    id: root
    
    property bool isFloatingPlayer: false
    property string currentDownloadPath: mainWindow.globalDownloadPath
    property int currentPlayingIndex: -1
    
    function formatTime(ms) {
        var s = Math.floor(ms / 1000)
        var m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }
    
    NativeAudioPlayer {
        id: audioPlayer
        onDurationChanged: {
            if (!progressSlider.pressed) {
                progressSlider.value = (duration > 0) ? position / duration : 0.0
            }
        }
        onPositionChanged: {
            if (!progressSlider.pressed) {
                progressSlider.value = (duration > 0) ? position / duration : 0.0
            }
        }
    }

    FolderListModel {
        id: folderModel
        folder: currentDownloadPath
        nameFilters: ["*.mp3", "*.mp4", "*.m4a", "*.webm"]
        showDirs: false
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Mis Descargas"
                color: "white"
                font.pixelSize: 28
                font.bold: true
                style: Text.Raised
                styleColor: "black"
                Layout.fillWidth: true
            }
            
            Button {
                text: isFloatingPlayer ? "Cerrar Mini Reproductor" : "Abrir Mini Reproductor"
                onClicked: {
                    isFloatingPlayer = !isFloatingPlayer
                    if (!isFloatingPlayer) {
                        audioPlayer.stop()
                    }
                }
                background: GlassEffect { radius: 8; color: Qt.rgba(1, 1, 1, 0.1) }
                contentItem: Text { text: parent.text; color: "white"; font.bold: true }
            }
        }

        // Real Library List
        ListView {
            id: libraryList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            
            model: folderModel

            delegate: GlassEffect {
                width: ListView.view.width
                height: 60
                radius: 8
                color: Qt.rgba(1, 1, 1, 0.05)
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 15
                    
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 4
                        color: "#333"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/ui/icons/library.svg"
                            fillMode: Image.Pad
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: fileBaseName
                            color: "white"
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        Text {
                            text: fileSuffix.toUpperCase() + " File • " + Math.round(fileSize / 1024 / 1024) + " MB"
                            color: "#aaa"
                            font.pixelSize: 12
                        }
                    }
                    
                    Button {
                        text: "Play"
                        icon.source: "qrc:/ui/icons/play.svg"
                        icon.color: "white"
                        background: Rectangle { color: Qt.rgba(0.2, 0.8, 0.2, 0.5); radius: 6 }
                        contentItem: RowLayout {
                            Image { source: parent.parent.icon.source; sourceSize: Qt.size(16, 16) }
                            Text { text: parent.parent.text; color: "white"; font.bold: true }
                        }
                        onClicked: {
                            isFloatingPlayer = true
                            playerTitle.text = fileBaseName
                            audioPlayer.setSource(fileURL)
                            audioPlayer.play()
                            root.currentPlayingIndex = index
                        }
                    }
                }
            }
            
            Text {
                visible: folderModel.count === 0
                text: "No se encontraron archivos de música o video en:\n" + currentDownloadPath.replace("file:///", "")
                color: "#888"
                font.pixelSize: 16
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // Refined Floating Player (Aero Glass Style, WMP Vista/7 Inspired)
    GlassEffect {
        id: floatingPlayer
        width: 460
        height: 300
        radius: 12
        visible: isFloatingPlayer
        
        // Initial position at bottom right
        x: parent.width - width - 20
        y: parent.height - height - 20
        
        // No hard borders
        border.width: 0

        // Inner gradient background mimicking the sleek dark/teal palette
        Rectangle {
            anchors.fill: parent
            radius: 12
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.05, 0.15, 0.25, 0.85) }
                GradientStop { position: 0.7; color: Qt.rgba(0.0, 0.05, 0.1, 0.95) }
                GradientStop { position: 1.0; color: Qt.rgba(0.0, 0.0, 0.0, 0.95) }
            }
        }
        
        MouseArea {
            anchors.fill: parent
            drag.target: floatingPlayer
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            // Top Area: Text
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    id: playerTitle
                    text: "Ninguna canción seleccionada"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 22
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                Text {
                    text: "YouTube Audio Download"
                    color: "#88ccff"
                    font.pixelSize: 14
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            // Middle Area: Album Art
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Rectangle {
                    width: 110
                    height: 110
                    color: "#050505"
                    radius: 8
                    clip: true
                    border.width: 0
                    
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/ui/icons/library.svg"
                        sourceSize: Qt.size(50, 50)
                        opacity: 0.4
                    }
                    
                    // Glassy reflection on the album art
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: parent.height / 2
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.15) }
                            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
                        }
                    }
                }
                
                Item { Layout.fillWidth: true } // Spacer to push album art to left
            }

            // Bottom Area: Slider & Controls
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                
                // Slider and Time
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    Text { text: formatTime(audioPlayer.position); color: "#88ccff"; font.pixelSize: 12; font.bold: true; width: 35 }
                    
                    Slider {
                        id: progressSlider
                        Layout.fillWidth: true
                        value: audioPlayer.duration > 0 ? audioPlayer.position / audioPlayer.duration : 0.0
                        height: 14
                        
                        onMoved: {
                            audioPlayer.position = value * audioPlayer.duration
                        }
                        
                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: parent.availableWidth
                            height: 4
                            radius: 2
                            color: Qt.rgba(0, 0, 0, 0.6)
                            
                            Rectangle {
                                width: parent.parent.visualPosition * parent.width
                                height: parent.height
                                color: "#00aaff"
                                radius: 2
                                
                                // Glowing effect
                                Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                    border.color: "#88ccff"
                                    opacity: 0.5
                                    radius: 2
                                }
                            }
                        }
                        handle: Rectangle {
                            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: 14
                            height: 14
                            radius: 7
                            color: "#ffffff"
                        }
                    }
                    
                    Text { text: formatTime(audioPlayer.duration); color: "#88ccff"; font.pixelSize: 12; font.bold: true; width: 35; horizontalAlignment: Text.AlignRight }
                }

                // Controls (Pill shaped container)
                Item {
                    Layout.fillWidth: true
                    height: 50
                    
                    // The glassy pill shape behind controls
                    Rectangle {
                        anchors.centerIn: parent
                        width: 200
                        height: 48
                        radius: 24
                        color: Qt.rgba(0, 0, 0, 0.5)
                        border.width: 0
                        
                        // Inner glassy reflection
                        Rectangle {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 2
                            height: parent.height / 2
                            radius: 22
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.08) }
                                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
                            }
                        }
                    }
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 20
                        
                        // Prev Button
                        Item {
                            width: 24; height: 24
                            Image { anchors.centerIn: parent; source: "qrc:/ui/icons/prev.svg"; sourceSize: Qt.size(20,20); opacity: prevMouseArea.pressed ? 0.7 : 1.0 }
                            MouseArea { 
                                id: prevMouseArea; anchors.fill: parent
                                onClicked: {
                                    if (root.currentPlayingIndex > 0) {
                                        root.currentPlayingIndex -= 1;
                                        var nextFile = folderModel.get(root.currentPlayingIndex, "fileURL")
                                        var nextName = folderModel.get(root.currentPlayingIndex, "fileBaseName")
                                        playerTitle.text = nextName
                                        audioPlayer.setSource(nextFile)
                                        audioPlayer.play()
                                    }
                                }
                            }
                        }
                        
                        // Big Play Button
                        Rectangle {
                            id: playBtn
                            width: 44; height: 44
                            radius: 22
                            color: playMouseArea.pressed ? Qt.rgba(0, 0.4, 0.8, 1) : Qt.rgba(0, 0.6, 1, 1)
                            border.width: 0
                            
                            // Glass reflection on play button
                            Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: parent.height / 2
                                radius: 22
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.3) }
                                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
                                }
                            }
                            
                            Image { 
                                source: audioPlayer.isPlaying ? "qrc:/ui/icons/pause.svg" : "qrc:/ui/icons/play.svg"
                                sourceSize: Qt.size(24,24)
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: audioPlayer.isPlaying ? 0 : 2
                            }
                            
                            MouseArea {
                                id: playMouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if (audioPlayer.isPlaying) {
                                        audioPlayer.pause()
                                    } else {
                                        audioPlayer.play()
                                    }
                                }
                            }
                        }
                        
                        // Next Button
                        Item {
                            width: 24; height: 24
                            Image { anchors.centerIn: parent; source: "qrc:/ui/icons/next.svg"; sourceSize: Qt.size(20,20); opacity: nextMouseArea.pressed ? 0.7 : 1.0 }
                            MouseArea { 
                                id: nextMouseArea; anchors.fill: parent 
                                onClicked: {
                                    if (root.currentPlayingIndex >= 0 && root.currentPlayingIndex < folderModel.count - 1) {
                                        root.currentPlayingIndex += 1;
                                        var nextFile = folderModel.get(root.currentPlayingIndex, "fileURL")
                                        var nextName = folderModel.get(root.currentPlayingIndex, "fileBaseName")
                                        playerTitle.text = nextName
                                        audioPlayer.setSource(nextFile)
                                        audioPlayer.play()
                                    }
                                }
                            }
                        }
                    }
                    
                    // Volume button floating on the right
                    Rectangle {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.rgba(1,1,1,0.05)
                        radius: 17
                        width: 34; height: 34
                        
                        Image { anchors.centerIn: parent; source: "qrc:/ui/icons/volume.svg"; sourceSize: Qt.size(18,18); opacity: volMouseArea.pressed ? 0.7 : 1.0 }
                        MouseArea { 
                            id: volMouseArea
                            anchors.fill: parent
                            onClicked: volumePopup.open()
                        }
                    }
                }
            }
        }
        
        Popup {
            id: volumePopup
            y: -130
            x: floatingPlayer.width - 50
            width: 40
            height: 120
            background: GlassEffect { radius: 8; border.width: 0; Rectangle { anchors.fill: parent; radius: 8; color: Qt.rgba(0,0,0,0.8) } }
            
            Slider {
                id: volumeSlider
                anchors.centerIn: parent
                orientation: Qt.Vertical
                height: 100
                value: 0.8
                onValueChanged: audioPlayer.setVolume(value)
            }
        }
    }
}
