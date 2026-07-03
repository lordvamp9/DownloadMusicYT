import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: Qt.rgba(0.2, 0.2, 0.2, 0.6)
    radius: 10
    border.color: Qt.rgba(1.0, 1.0, 1.0, 0.15)
    border.width: 1

    // Simulated gloss / highlight on top edge
    Rectangle {
        width: parent.width - 2
        height: 1
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.horizontalCenter: parent.horizontalCenter
        color: Qt.rgba(1.0, 1.0, 1.0, 0.2)
        radius: root.radius
    }

    // Optional subtle gradient
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(0.3, 0.3, 0.3, 0.3) }
        GradientStop { position: 1.0; color: Qt.rgba(0.1, 0.1, 0.1, 0.5) }
    }
}
