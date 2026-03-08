import QtQuick
import QtQuick.Layouts
import ".."

// Reusable keyboard-navigable popup frame
// All popups use this base for consistent keyboard interaction
Rectangle {
    id: root

    property string title: ""
    property alias contentItem: contentArea.data
    property int currentIndex: 0
    property int itemCount: 0

    signal closeRequested()
    signal actionRequested(int index)

    color: Theme.popupBg
    border.color: Theme.popupBorder
    border.width: 1
    radius: Theme.popupRadius

    // Keyboard navigation
    focus: true
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            root.closeRequested();
            event.accepted = true;
        } else if (event.key === Qt.Key_J || event.key === Qt.Key_Down) {
            if (root.itemCount > 0) {
                root.currentIndex = (root.currentIndex + 1) % root.itemCount;
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_K || event.key === Qt.Key_Up) {
            if (root.itemCount > 0) {
                root.currentIndex = (root.currentIndex - 1 + root.itemCount) % root.itemCount;
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_L) {
            root.actionRequested(root.currentIndex);
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: Theme.spacing

        // Title bar
        Text {
            Layout.fillWidth: true
            text: root.title
            color: Theme.white
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 2
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Theme.surface0
        }

        // Content area
        Item {
            id: contentArea
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    // Keyboard hint at bottom
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 1
        height: 20
        color: Theme.surface0
        radius: Theme.popupRadius

        // Only bottom corners rounded
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.color
        }

        Text {
            anchors.centerIn: parent
            text: "j/k:navigate  enter/l:select  esc:close"
            color: Theme.dimText
            font.family: Theme.fontFamily
            font.pixelSize: 10
        }
    }
}
