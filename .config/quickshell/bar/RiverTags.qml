import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Row {
    id: root
    spacing: 2

    property int tagCount: 9
    property int focusedTags: 0
    property int occupiedTags: 0
    property int urgentTags: 0

    // Poll river for tag state
    Process {
        id: tagProcess
        command: ["sh", "-c", "riverctl list-tags 2>/dev/null || echo 0"]
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                // River doesn't have a simple list-tags; we poll focused/occupied state
            }
        }
    }

    // Use river's status protocol via polling
    Timer {
        interval: 250
        running: true
        repeat: true
        onTriggered: {
            focusedProcess.running = true;
            occupiedProcess.running = true;
        }
    }

    Process {
        id: focusedProcess
        command: ["sh", "-c", "riverctl get-focused-tags 2>/dev/null || echo 1"]
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                const val = parseInt(line.trim());
                if (!isNaN(val)) root.focusedTags = val;
            }
        }
    }

    Process {
        id: occupiedProcess
        command: ["sh", "-c", "riverctl get-occupied-tags 2>/dev/null || echo 0"]
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                const val = parseInt(line.trim());
                if (!isNaN(val)) root.occupiedTags = val;
            }
        }
    }

    Process {
        id: urgentProcess
        command: ["sh", "-c", "riverctl get-urgent-tags 2>/dev/null || echo 0"]
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                const val = parseInt(line.trim());
                if (!isNaN(val)) root.urgentTags = val;
            }
        }
    }

    Rectangle {
        width: tagRow.implicitWidth + 8
        height: Theme.barHeight - 8
        anchors.verticalCenter: parent.verticalCenter
        radius: Theme.barRadius
        color: Theme.base

        Row {
            id: tagRow
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: root.tagCount

                Rectangle {
                    required property int index
                    property int tagBit: 1 << index
                    property bool isFocused: (root.focusedTags & tagBit) !== 0
                    property bool isOccupied: (root.occupiedTags & tagBit) !== 0
                    property bool isUrgent: (root.urgentTags & tagBit) !== 0

                    width: 18
                    height: 18
                    radius: 9
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: (index + 1).toString()
                        color: {
                            if (isUrgent) return Theme.red;
                            if (isFocused) return Theme.red;
                            if (isOccupied) return Theme.blue;
                            return Theme.white;
                        }
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        font.bold: isFocused
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const tags = 1 << index;
                            setTagProcess.command = ["riverctl", "set-focused-tags", tags.toString()];
                            setTagProcess.running = true;
                        }
                    }
                }
            }
        }
    }

    Process {
        id: setTagProcess
        running: false
    }
}
