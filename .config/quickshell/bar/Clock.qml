import QtQuick
import ".."

Rectangle {
    id: root

    implicitWidth: clockText.implicitWidth + Theme.padding * 2
    implicitHeight: Theme.barHeight

    color: "transparent"

    Rectangle {
        anchors.centerIn: parent
        width: clockText.implicitWidth + Theme.padding * 2
        height: Theme.barHeight - 8
        radius: Theme.barRadius
        color: Theme.moduleBg

        Text {
            id: clockText
            anchors.centerIn: parent
            color: Theme.white
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            text: Qt.formatDateTime(new Date(), "ddd dd MMM yyyy | HH:mm:ss")
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clockText.text = Qt.formatDateTime(new Date(), "ddd dd MMM yyyy | HH:mm:ss");
            }
        }
    }
}
