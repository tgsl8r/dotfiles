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

    implicitWidth: networkIcon.implicitWidth + Theme.padding * 2

    // Network state
    property string networkType: "disconnected"
    property string networkName: ""
    property var networkList: []

    // Poll network status
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statusProcess.running = true
    }

    Process {
        id: statusProcess
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                const parts = line.trim().split(":");
                if (parts.length >= 3 && parts[1] === "connected") {
                    if (parts[0] === "wifi") {
                        root.networkType = "wifi";
                        root.networkName = parts[2];
                    } else if (parts[0] === "ethernet") {
                        root.networkType = "ethernet";
                        root.networkName = parts[2];
                    }
                }
            }
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.networkType = "disconnected";
                root.networkName = "";
            }
        }
    }

    // Scan networks when popup opens
    onIsOpenChanged: {
        if (isOpen) {
            scanProcess.running = true;
        }
    }

    Process {
        id: scanProcess
        command: ["nmcli", "-t", "-f", "ACTIVE,SSID,SECURITY,SIGNAL", "device", "wifi", "list", "--rescan", "auto"]
        running: false
        property string output: ""
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() !== "") {
                    scanProcess.output += line.trim() + "\n";
                }
            }
            onStreamFinished: {
                const lines = scanProcess.output.trim().split("\n");
                const nets = [];
                for (const l of lines) {
                    const parts = l.split(":");
                    if (parts.length >= 4 && parts[1] !== "") {
                        nets.push({
                            active: parts[0] === "yes",
                            ssid: parts[1],
                            security: parts[2],
                            signal: parseInt(parts[3]) || 0
                        });
                    }
                }
                // Sort: active first, then by signal strength
                nets.sort((a, b) => {
                    if (a.active && !b.active) return -1;
                    if (!a.active && b.active) return 1;
                    return b.signal - a.signal;
                });
                root.networkList = nets;
                scanProcess.output = "";
            }
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
            id: networkIcon
            anchors.centerIn: parent
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
            color: root.networkType === "disconnected" ? Theme.danger : Theme.white
            text: {
                if (root.networkType === "wifi") return "  " + root.networkName;
                if (root.networkType === "ethernet") return "  Wired";
                return "⚠ Disconnected";
            }
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
            height: Math.min(popupContent.implicitHeight + 40, 500)
            color: "transparent"

            PopupFrame {
                id: popupContent
                anchors.fill: parent
                title: " Network"
                itemCount: networkListView.count
                currentIndex: 0
                onCloseRequested: root.closePopup()
                onActionRequested: (idx) => {
                    if (idx >= 0 && idx < root.networkList.length) {
                        const net = root.networkList[idx];
                        if (net.active) {
                            disconnectProcess.command = ["nmcli", "connection", "down", net.ssid];
                            disconnectProcess.running = true;
                        } else {
                            connectProcess.command = ["nmcli", "device", "wifi", "connect", net.ssid];
                            connectProcess.running = true;
                        }
                    }
                }

                contentItem: [
                    ListView {
                        id: networkListView
                        anchors.fill: parent
                        anchors.bottomMargin: 24
                        model: root.networkList
                        clip: true
                        currentIndex: popupContent.currentIndex
                        spacing: 2

                        delegate: Rectangle {
                            required property var modelData
                            required property int index

                            width: networkListView.width
                            height: Theme.itemHeight
                            radius: Theme.itemRadius
                            color: index === popupContent.currentIndex ? Theme.highlight : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.padding
                                anchors.rightMargin: Theme.padding
                                spacing: Theme.spacing

                                Text {
                                    text: {
                                        const sig = modelData.signal;
                                        if (sig > 75) return "󰤨";
                                        if (sig > 50) return "󰤥";
                                        if (sig > 25) return "󰤢";
                                        return "󰤟";
                                    }
                                    color: modelData.active ? Theme.green : Theme.white
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.iconSize + 2
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.ssid
                                    color: modelData.active ? Theme.green : Theme.white
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize
                                    font.bold: modelData.active
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: modelData.security !== "" ? "󰌾" : ""
                                    color: Theme.dimText
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.iconSize
                                }

                                Text {
                                    text: modelData.signal + "%"
                                    color: Theme.dimText
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 1
                                    Layout.preferredWidth: 32
                                    horizontalAlignment: Text.AlignRight
                                }

                                Text {
                                    visible: modelData.active
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
                                onEntered: popupContent.currentIndex = index
                                onClicked: popupContent.actionRequested(index)
                            }
                        }
                    }
                ]
            }
        }
    }

    Process {
        id: connectProcess
        running: false
        onExited: (code) => {
            statusProcess.running = true;
            scanProcess.running = true;
        }
    }

    Process {
        id: disconnectProcess
        running: false
        onExited: (code) => {
            statusProcess.running = true;
            scanProcess.running = true;
        }
    }
}
