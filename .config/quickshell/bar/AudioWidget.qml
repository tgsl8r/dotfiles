import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."
import "../widgets"

Item {
    id: root

    property bool isOpen: false
    property var panelWindow: null

    signal toggle()
    signal closePopup()

    implicitWidth: audioIcon.implicitWidth + Theme.padding * 2

    // Track default sink for bar icon
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property real sinkVolume: Pipewire.defaultAudioSink?.audio?.volume ?? 0
    property bool sinkMuted: Pipewire.defaultAudioSink?.audio?.muted ?? false

    // Sink and source list via process
    property var sinkList: []
    property var sourceList: []

    onIsOpenChanged: {
        if (isOpen) {
            sinksProcess.running = true;
            sourcesProcess.running = true;
        }
    }

    Process {
        id: sinksProcess
        command: ["sh", "-c", "wpctl status -k 2>/dev/null | awk '/Audio/,/Video/' | awk '/Sinks:/,/Sources:/' | grep -E '^\\s+[│├└]?\\s*\\*?\\s*[0-9]' | sed 's/[│├└]//g'"]
        running: false
        property string output: ""
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() !== "") {
                    sinksProcess.output += line.trim() + "\n";
                }
            }
            onStreamFinished: {
                const lines = sinksProcess.output.trim().split("\n");
                const sinks = [];
                for (const l of lines) {
                    const isDefault = l.includes("*");
                    const clean = l.replace("*", "").trim();
                    const match = clean.match(/(\d+)\.\s+(.+?)(?:\s+\[vol:\s*([\d.]+)(\s+MUTED)?\])?$/);
                    if (match) {
                        sinks.push({
                            id: parseInt(match[1]),
                            name: match[2].trim(),
                            volume: match[3] ? parseFloat(match[3]) : 0,
                            muted: match[4] !== undefined,
                            isDefault: isDefault
                        });
                    }
                }
                root.sinkList = sinks;
                sinksProcess.output = "";
            }
        }
    }

    Process {
        id: sourcesProcess
        command: ["sh", "-c", "wpctl status -k 2>/dev/null | awk '/Audio/,/Video/' | awk '/Sources:/,/Filters:/' | grep -E '^\\s+[│├└]?\\s*\\*?\\s*[0-9]' | sed 's/[│├└]//g'"]
        running: false
        property string output: ""
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() !== "") {
                    sourcesProcess.output += line.trim() + "\n";
                }
            }
            onStreamFinished: {
                const lines = sourcesProcess.output.trim().split("\n");
                const sources = [];
                for (const l of lines) {
                    const isDefault = l.includes("*");
                    const clean = l.replace("*", "").trim();
                    const match = clean.match(/(\d+)\.\s+(.+?)(?:\s+\[vol:\s*([\d.]+)(\s+MUTED)?\])?$/);
                    if (match) {
                        sources.push({
                            id: parseInt(match[1]),
                            name: match[2].trim(),
                            volume: match[3] ? parseFloat(match[3]) : 0,
                            muted: match[4] !== undefined,
                            isDefault: isDefault
                        });
                    }
                }
                root.sourceList = sources;
                sourcesProcess.output = "";
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
            id: audioIcon
            anchors.centerIn: parent
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
            color: root.sinkMuted ? Theme.dimText : Theme.white
            text: {
                if (root.sinkMuted) return " muted";
                const vol = Math.round(root.sinkVolume * 100);
                if (vol > 66) return "  " + vol + "%";
                if (vol > 33) return "  " + vol + "%";
                if (vol > 0) return "  " + vol + "%";
                return "  0%";
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
            height: Math.min(popupContent.implicitHeight + 40, 550)
            color: "transparent"

            PopupFrame {
                id: popupContent
                anchors.fill: parent
                title: " Audio"
                itemCount: root.sinkList.length + root.sourceList.length + 2
                currentIndex: 0
                onCloseRequested: root.closePopup()
                onActionRequested: (idx) => {
                    const sinkCount = root.sinkList.length;
                    const sinkHeaderIdx = 0;
                    const sourceHeaderIdx = sinkCount + 1;

                    // Mute toggle on default sink when selecting volume row
                    if (idx === sinkHeaderIdx) {
                        muteProcess.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
                        muteProcess.running = true;
                        return;
                    }

                    if (idx === sourceHeaderIdx) {
                        muteProcess.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"];
                        muteProcess.running = true;
                        return;
                    }

                    // Set default sink
                    if (idx > sinkHeaderIdx && idx < sourceHeaderIdx) {
                        const sinkIdx = idx - 1;
                        if (sinkIdx < root.sinkList.length) {
                            setDefaultProcess.command = ["wpctl", "set-default", root.sinkList[sinkIdx].id.toString()];
                            setDefaultProcess.running = true;
                        }
                        return;
                    }

                    // Set default source
                    if (idx > sourceHeaderIdx) {
                        const srcIdx = idx - sourceHeaderIdx - 1;
                        if (srcIdx < root.sourceList.length) {
                            setDefaultProcess.command = ["wpctl", "set-default", root.sourceList[srcIdx].id.toString()];
                            setDefaultProcess.running = true;
                        }
                    }
                }

                // Handle h/l for volume control
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_H) {
                        volDownProcess.running = true;
                        event.accepted = true;
                    } else if (event.key === Qt.Key_L) {
                        // Override L only for volume at header positions
                        if (popupContent.currentIndex === 0 || popupContent.currentIndex === root.sinkList.length + 1) {
                            // Do not capture L at headers - let it fall through to action
                        }
                    }
                }

                contentItem: [
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.bottomMargin: 24
                        spacing: 2

                        // Volume slider row (default sink)
                        Rectangle {
                            Layout.fillWidth: true
                            height: Theme.itemHeight + 10
                            radius: Theme.itemRadius
                            color: popupContent.currentIndex === 0 ? Theme.highlight : "transparent"

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.padding
                                anchors.rightMargin: Theme.padding
                                spacing: 2

                                RowLayout {
                                    spacing: Theme.spacing
                                    Text {
                                        text: root.sinkMuted ? "" : ""
                                        color: root.sinkMuted ? Theme.dimText : Theme.white
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.iconSize + 2
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        text: "Output Volume"
                                        color: Theme.white
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize
                                    }
                                    Text {
                                        text: Math.round(root.sinkVolume * 100) + "%"
                                        color: Theme.dimText
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize - 1
                                    }
                                }

                                // Volume bar
                                Rectangle {
                                    Layout.fillWidth: true
                                    implicitHeight: 4
                                    radius: 2
                                    color: Theme.surface0

                                    Rectangle {
                                        width: parent.width * root.sinkVolume
                                        height: parent.height
                                        radius: parent.radius
                                        color: root.sinkMuted ? Theme.dimText : Theme.blue
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: popupContent.currentIndex = 0
                                onClicked: popupContent.actionRequested(0)
                            }
                        }

                        // Sinks section header
                        Text {
                            Layout.fillWidth: true
                            Layout.leftMargin: Theme.padding
                            Layout.topMargin: 4
                            text: "Output Devices"
                            color: Theme.dimText
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize - 1
                            font.bold: true
                        }

                        // Sink list
                        Repeater {
                            model: root.sinkList

                            Rectangle {
                                required property var modelData
                                required property int index

                                Layout.fillWidth: true
                                height: Theme.itemHeight
                                radius: Theme.itemRadius
                                color: (index + 1) === popupContent.currentIndex ? Theme.highlight : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: Theme.padding
                                    anchors.rightMargin: Theme.padding
                                    spacing: Theme.spacing

                                    Text {
                                        text: modelData.isDefault ? "" : ""
                                        color: modelData.isDefault ? Theme.green : Theme.dimText
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.iconSize
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.name
                                        color: modelData.isDefault ? Theme.green : Theme.white
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize
                                        font.bold: modelData.isDefault
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: Math.round(modelData.volume * 100) + "%"
                                        color: Theme.dimText
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize - 1
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

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
                            color: Theme.surface0
                            Layout.topMargin: 4
                            Layout.bottomMargin: 4
                        }

                        // Source volume row
                        Rectangle {
                            Layout.fillWidth: true
                            height: Theme.itemHeight
                            radius: Theme.itemRadius
                            color: popupContent.currentIndex === (root.sinkList.length + 1) ? Theme.highlight : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.padding
                                anchors.rightMargin: Theme.padding
                                spacing: Theme.spacing

                                Text {
                                    text: ""
                                    color: Theme.white
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.iconSize + 2
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: "Input Volume"
                                    color: Theme.white
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: popupContent.currentIndex = root.sinkList.length + 1
                                onClicked: popupContent.actionRequested(root.sinkList.length + 1)
                            }
                        }

                        // Source section header
                        Text {
                            Layout.fillWidth: true
                            Layout.leftMargin: Theme.padding
                            Layout.topMargin: 4
                            text: "Input Devices"
                            color: Theme.dimText
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize - 1
                            font.bold: true
                        }

                        // Source list
                        Repeater {
                            model: root.sourceList

                            Rectangle {
                                required property var modelData
                                required property int index

                                Layout.fillWidth: true
                                height: Theme.itemHeight
                                radius: Theme.itemRadius
                                color: (index + root.sinkList.length + 2) === popupContent.currentIndex ? Theme.highlight : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: Theme.padding
                                    anchors.rightMargin: Theme.padding
                                    spacing: Theme.spacing

                                    Text {
                                        text: modelData.isDefault ? "" : ""
                                        color: modelData.isDefault ? Theme.green : Theme.dimText
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.iconSize
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.name
                                        color: modelData.isDefault ? Theme.green : Theme.white
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize
                                        font.bold: modelData.isDefault
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: Math.round(modelData.volume * 100) + "%"
                                        color: Theme.dimText
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSize - 1
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: popupContent.currentIndex = index + root.sinkList.length + 2
                                    onClicked: popupContent.actionRequested(index + root.sinkList.length + 2)
                                }
                            }
                        }

                        // Spacer
                        Item { Layout.fillHeight: true }
                    }
                ]
            }
        }
    }

    Process {
        id: muteProcess
        running: false
        onExited: {
            sinksProcess.running = true;
            sourcesProcess.running = true;
        }
    }

    Process {
        id: setDefaultProcess
        running: false
        onExited: {
            sinksProcess.running = true;
            sourcesProcess.running = true;
        }
    }

    Process {
        id: volDownProcess
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "2%-"]
        running: false
    }
}
