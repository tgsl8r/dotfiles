import QtQuick
import QtQuick.Layouts
import ".."
import "../widgets"

Item {
    id: root

    property string activePopup: ""
    property var panelWindow: null

    signal togglePopup(string name)
    signal closePopups()

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left section: River tags
        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: tags.implicitWidth + 10

            RiverTags {
                id: tags
                anchors.centerIn: parent
            }
        }

        // Spacer
        Item { Layout.fillWidth: true }

        // Center section: Clock
        Clock {
            Layout.fillHeight: true
            Layout.preferredWidth: implicitWidth
        }

        // Spacer
        Item { Layout.fillWidth: true }

        // Right section: widgets
        RowLayout {
            Layout.fillHeight: true
            spacing: 0

            NetworkWidget {
                Layout.fillHeight: true
                isOpen: root.activePopup === "network"
                onToggle: root.togglePopup("network")
                panelWindow: root.panelWindow
                onClosePopup: root.closePopups()
            }

            BluetoothWidget {
                Layout.fillHeight: true
                isOpen: root.activePopup === "bluetooth"
                onToggle: root.togglePopup("bluetooth")
                panelWindow: root.panelWindow
                onClosePopup: root.closePopups()
            }

            AudioWidget {
                Layout.fillHeight: true
                isOpen: root.activePopup === "audio"
                onToggle: root.togglePopup("audio")
                panelWindow: root.panelWindow
                onClosePopup: root.closePopups()
            }

            BatteryWidget {
                Layout.fillHeight: true
            }
        }
    }
}
