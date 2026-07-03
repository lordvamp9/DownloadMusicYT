import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import com.vamp9.ytmusic 1.0
import "components"
import "views"
import QtCore

Window {
    id: mainWindow
    
    property string globalDownloadPath: "file:///C:/Users/pc/Music"
    
    Settings {
        id: appSettings
        category: "Preferences"
        property alias downloadPath: mainWindow.globalDownloadPath
    }
    
    DownloadQueueModel {
        id: globalDownloadQueue
    }

    Component {
        id: downloadFlyComponent
        Item {
            id: flyWrapper
            width: 36; height: 36
            property real startX: 0
            property real startY: 0
            x: startX
            y: startY
            z: 999
            
            Rectangle {
                anchors.fill: parent
                radius: 18
                color: Qt.rgba(0, 0.6, 1.0, 0.9)
                border.color: "white"
                border.width: 2
                Image {
                    source: "qrc:/ui/icons/download.svg"
                    anchors.centerIn: parent
                    sourceSize: Qt.size(18, 18)
                }
            }
            
            ParallelAnimation {
                id: flyAnim
                // The "Descargas" button in the sidebar is roughly at x: 20, y: 150
                NumberAnimation { target: flyWrapper; property: "x"; to: 20; duration: 700; easing.type: Easing.InOutQuad }
                NumberAnimation { target: flyWrapper; property: "y"; to: 150; duration: 700; easing.type: Easing.InOutCubic }
                NumberAnimation { target: flyWrapper; property: "opacity"; from: 1; to: 0.2; duration: 700; easing.type: Easing.InQuad }
                NumberAnimation { target: flyWrapper; property: "scale"; from: 1; to: 0.5; duration: 700 }
                onFinished: flyWrapper.destroy()
            }
            
            Component.onCompleted: flyAnim.start()
        }
    }

    function animateDownload(startX, startY) {
        downloadFlyComponent.createObject(mainWindow.contentItem, { "startX": startX, "startY": startY })
    }

    DownloadManager {
        id: globalDownloadManager
        onProgressUpdated: (videoId, percent) => {
            globalDownloadQueue.updateProgress(videoId, percent)
        }
        onDownloadCompleted: (videoId, path) => {
            globalDownloadQueue.updateStatus(videoId, "Completado")
        }
        onDownloadFailed: (videoId, error) => {
            globalDownloadQueue.updateStatus(videoId, "Error")
        }
    }
    width: 1024
    height: 768
    visible: true
    title: "YouTube Music Downloader - Aero Glass"
    
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint

    // Background Image representing Windows 7 Multimedia Aero Glass
    Rectangle {
        anchors.fill: parent
        color: "#1e2228" // Base multimedia dark gray/blue
        
        // Classic Aero Glass style reflection and gradient
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#424d58" }
            GradientStop { position: 0.49; color: "#2b323a" }
            GradientStop { position: 0.50; color: "#1c2126" } // The sharp glass horizon line
            GradientStop { position: 1.0; color: "#121518" }
        }
    }

    GlassEffect {
        anchors.fill: parent
        radius: 12
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            
            // Custom Title Bar
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: Qt.rgba(1, 1, 1, 0.08)
                radius: 12
                Rectangle {
                    width: parent.width
                    height: 12
                    anchors.bottom: parent.bottom
                    color: parent.color
                }
                
                // Reflection on title bar
                Rectangle {
                    width: parent.width - 4
                    height: 18
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(1, 1, 1, 0.1)
                    radius: 10
                }
                
                Text {
                    text: "YouTube Music Downloader"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                    style: Text.Raised
                    styleColor: "black"
                }
                
                MouseArea {
                    anchors.fill: parent
                    property variant clickPos: "1,1"
                    onPressed: (mouse) => { clickPos = Qt.point(mouse.x, mouse.y) }
                    onPositionChanged: (mouse) => {
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        mainWindow.x += delta.x
                        mainWindow.y += delta.y
                    }
                }
                
                Button {
                    text: "✕"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    background: Rectangle { color: "transparent" }
                    contentItem: Text { text: parent.text; color: "white"; anchors.centerIn: parent }
                    onClicked: Qt.quit()
                }
            }

            // Main Content Area
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Sidebar
                Rectangle {
                    Layout.preferredWidth: 220
                    Layout.fillHeight: true
                    color: Qt.rgba(0, 0, 0, 0.3)
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8
                        
                        Component {
                            id: sidebarButton
                            Button {
                                id: btn
                                Layout.fillWidth: true
                                property string iconSource: ""
                                property string btnText: ""
                                
                                background: Rectangle {
                                    color: btn.down ? Qt.rgba(1, 1, 1, 0.2) : (btn.hovered ? Qt.rgba(1, 1, 1, 0.1) : "transparent")
                                    radius: 6
                                    border.color: btn.hovered ? Qt.rgba(1, 1, 1, 0.3) : "transparent"
                                }
                                
                                contentItem: RowLayout {
                                    spacing: 12
                                    Image {
                                        source: btn.iconSource
                                        Layout.preferredWidth: 20
                                        Layout.preferredHeight: 20
                                        sourceSize: Qt.size(20, 20)
                                    }
                                    Text {
                                        text: btn.btnText
                                        color: "white"
                                        font.pixelSize: 15
                                        font.bold: true
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        Loader {
                            Layout.fillWidth: true
                            sourceComponent: sidebarButton
                            onLoaded: { item.iconSource = "qrc:/ui/icons/search.svg"; item.btnText = "Buscador"; item.clicked.connect(() => stackView.replace(searchView)) }
                        }
                        Loader {
                            Layout.fillWidth: true
                            sourceComponent: sidebarButton
                            onLoaded: { item.iconSource = "qrc:/ui/icons/download.svg"; item.btnText = "Descargas"; item.clicked.connect(() => stackView.replace(downloadsView)) }
                        }
                        Loader {
                            Layout.fillWidth: true
                            sourceComponent: sidebarButton
                            onLoaded: { item.iconSource = "qrc:/ui/icons/library.svg"; item.btnText = "Mis descargas"; item.clicked.connect(() => stackView.replace(libraryView)) }
                        }
                        Item { Layout.fillHeight: true } // Spacer
                        Loader {
                            Layout.fillWidth: true
                            sourceComponent: sidebarButton
                            onLoaded: { item.iconSource = "qrc:/ui/icons/settings.svg"; item.btnText = "Configuración"; item.clicked.connect(() => stackView.replace(settingsView)) }
                        }
                    }
                }

                // StackView for Navigation
                StackView {
                    id: stackView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    initialItem: searchView
                    clip: true
                    
                    // Animations for transitions
                    replaceEnter: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
                    }
                    replaceExit: Transition {
                        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
                    }
                    pushEnter: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
                    }
                    pushExit: Transition {
                        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
                    }
                }
            }
        }
    }

    // Views Components
    Component { id: searchView; SearchView {} }
    Component { id: downloadsView; DownloadsView {} }
    Component { id: libraryView; LibraryView {} }
    Component { id: settingsView; SettingsView {} }
}
