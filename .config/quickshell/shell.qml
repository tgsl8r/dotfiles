import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "bar" as Bar

ShellRoot {
    id: root

    // Global popup state - only one popup open at a time
    property string activePopup: ""

    function togglePopup(name) {
        if (activePopup === name) {
            activePopup = "";
        } else {
            activePopup = name;
        }
    }

    function closePopups() {
        activePopup = "";
    }

    // IPC handlers for river keybindings
    IpcHandler {
        target: "bar"

        function toggleNetwork() { root.togglePopup("network"); }
        function toggleBluetooth() { root.togglePopup("bluetooth"); }
        function toggleAudio() { root.togglePopup("audio"); }
        function close() { root.closePopups(); }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel

            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Theme.barHeight
            color: Theme.barBg

            Bar.BarPanel {
                id: bar
                anchors.fill: parent
                activePopup: root.activePopup
                onTogglePopup: (name) => root.togglePopup(name)
                onClosePopups: root.closePopups()
                panelWindow: panel
            }
        }
    }
}
