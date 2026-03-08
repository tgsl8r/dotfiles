import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."
import "../widgets"

Item {
    id: root

    property bool isOpen: false
    property var panelWindow: null

    signal toggle()
    signal closePopup()

    implicitWidth: btIcon.implicitWidth + Theme.padding * 2

    // Bluetooth state
    property bool btPowered: false
    property var btDevices: []

    // Poll bluetooth status
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            powerProcess.running = true;
        }
    }

    Process {
        id: powerProcess
        command: ["sh", "-c", "bluetoothctl show 2>/dev/null | grep 'Powered:' | awk '{print $2}'"]
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                root.btPowered = line.trim() === "yes";
            }
        }
        onExited: {
            if (root.btPowered) {
                devicesProcess.running = true;
            } else {
                root.btDevices = [];
            }
        }
    }

    Process {
        id: devicesProcess
        command: ["bluetoothctl", "devices"]
        running: false
        property string output: ""
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() !== "") {
                    devicesProcess.output += line.trim() + "\n";
                }
            }
            onStreamFinished: {
                const lines = devicesProcess.output.trim().split("\n");
                const devs = [];
                for (const l of lines) {
                    // Format: Device XX:XX:XX:XX:XX:XX DeviceName
                    const match = l.match(/^Device\s+([0-9A-Fa-f:]+)\s+(.+)$/);
                    if (match) {
                        devs.push({
                            mac: match[1],
                            name: match[2],
                            connected: false
                        });
                    }
                }
                devicesProcess.output = "";
                // Now check which are connected
                if (devs.length > 0) {
                    connectedProcess.pendingDevices = devs;
                    connectedProcess.running = true;
                } else {
                    root.btDevices = devs;
                }
            }
        }
    }

    Process {
        id: connectedProcess
        command: ["bluetoothctl", "devices", "Connected"]
        running: false
        property var pendingDevices: []
        property string output: ""
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() !== "") {
                    connectedProcess.output += line.trim() + "\n";
                }
            }
            onStreamFinished: {
                const connectedMacs = new Set();
                const lines = connectedProcess.output.trim().split("\n");
                for (const l of lines) {
                    const match = l.match(/^Device\s+([0-9A-Fa-f:]+)/);
                    if (match) connectedMacs.add(match[1]);
                }
                const devs = connectedProcess.pendingDevices.map(d => ({
                    mac: d.mac,
                    name: d.name,
                    connected: connectedMacs.has(d.mac)
                }));
                // Sort: connected first, then alphabetical
                devs.sort((a, b) => {
                    if (a.connected && !b.connected) return -1;
                    if (!a.connected && b.connected) return 1;
                    return a.name.localeCompare(b.name);
                });
                root.btDevices = devs;
                connectedProcess.output = "";
            }
        }
    }

    onIsOpenChanged: {
        if (isOpen && root.btPowered) {
            devicesProcess.running = true;
        }
    }

    // Bar icon
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        color: Theme.moduleBg
        radius: 0

        Text {
            id: btIcon
            anchors.centerIn: parent
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
            color: root.btPowered ? Theme.blue : Theme.dimText
            text: root.btPowered ? "󰂯" : "󰂲"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.toggle()
        }
    }

    // Popup
    LazyLoader {
        id: popupLoader
        active: root.isOpen

        PopupWindow {
            parentWindow: root.panelWindow
            visible: true
            relativeX: root.mapToItem(null, 0, 0).x - Theme.popupWidth / 2 + root.width / 2
            relativeY: root.panelWindow ? root.panelWindow.implicitHeight : Theme.barHeight
            width: Theme.popupWidth
            height: Math.min(popupContent.implicitHeight + 40, 450)
            color: "transparent"

            PopupFrame {
                id: popupContent
                anchors.fill: parent
                title: "󰂯 Bluetooth"
                itemCount: btListView.count + 1
                currentIndex: 0
                onCloseRequested: root.closePopup()
                onActionRequested: (idx) => {
                    if (idx === 0) {
                        // Toggle power
                        togglePowerProcess.command = ["bluetoothctl", "power", root.btPowered ? "off" : "on"];
                        togglePowerProcess.running = true;
                    } else {
                        const devIdx = idx - 1;
                        if (devIdx >= 0 && devIdx < root.btDevices.length) {
                            const dev = root.btDevices[devIdx];
                            toggleDevProcess.command = ["bluetoothctl", dev.connected ? "disconnect" : "connect", dev.mac];
                            toggleDevProcess.running = true;
                        }
                    }
                }

                contentItem: [
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.bottomMargin: 24
                        spacing: 2

                        // Power toggle
                        Rectangle {
                            Layout.fillWidth: true
                            height: Theme.itemHeight
                            radius: Theme.itemRadius
                            color: popupContent.currentIndex === 0 ? Theme.highlight : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.padding
                                anchors.rightMargin: Theme.padding
                                spacing: Theme.spacing

                                Text {
                                    text: root.btPowered ? "󰂯" : "󰂲"
                                    color: root.btPowered ? Theme.blue : Theme.dimText
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.iconSize + 2
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: "Bluetooth"
                                    color: Theme.white
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize
                                }

                                Text {
                                    text: root.btPowered ? "ON" : "OFF"
                                    color: root.btPowered ? Theme.green : Theme.dimText
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 1
                                    font.bold: true
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: popupContent.currentIndex = 0
                                onClicked: popupContent.actionRequested(0)
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
                            color: Theme.surface0
                        }

                        // Device list
                        ListView {
                            id: btListView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: root.btDevices
                            clip: true
                            spacing: 2

                            delegate: Rectangle {
                                required property var modelData
                                required property int index

                                width: btListView.width
                                height: Theme.itemHeight
                                radius: Theme.itemRadius
                                color: (index + 1) === popupContent.currentIndex ? Theme.highlight : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: Theme.padding
                                    anchors.rightMargin: Theme.padding
                                    spacing: Theme.spacing

                                    Text {
                                        text: modelData.connected ? "󰂱" : "󰂰"
                                        color: modelData.connected ? Theme.blue : Theme.dimText
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.iconSize + 2
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.name
                                        color: modelData.connected ? Theme.blue : Theme.white
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize
                                        font.bold: modelData.connected
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        visible: modelData.connected
                                        text: "connected"
                                        color: Theme.green
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize - 2
                                        font.italic: true
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: popupContent.currentIndex = index + 1
                                    onClicked: popupContent.actionRequested(index + 1)
                                }
                            }
                        }
                    }
                ]
            }
        }
    }

    Process {
        id: togglePowerProcess
        running: false
        onExited: {
            powerProcess.running = true;
        }
    }

    Process {
        id: toggleDevProcess
        running: false
        onExited: (code) => {
            devicesProcess.running = true;
            connectedProcess.pendingDevices = [];
        }
    }
}
