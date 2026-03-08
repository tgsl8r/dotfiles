import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import ".."

Item {
    id: root

    implicitWidth: batteryRow.implicitWidth + Theme.padding * 2

    property var battery: UPower.displayDevice

    // Bar display
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        color: Theme.moduleBg
        radius: 0

        RowLayout {
            id: batteryRow
            anchors.centerIn: parent
            spacing: 4

            Text {
                id: batteryIcon
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconSize
                color: {
                    if (!root.battery) return Theme.dimText;
                    const pct = root.battery.percentage;
                    const charging = root.battery.state === UPowerDeviceState.Charging ||
                                     root.battery.state === UPowerDeviceState.FullyCharged;
                    if (pct <= 15 && !charging) return Theme.danger;
                    return Theme.white;
                }
                text: {
                    if (!root.battery) return "󰂑";
                    const pct = root.battery.percentage;
                    const charging = root.battery.state === UPowerDeviceState.Charging ||
                                     root.battery.state === UPowerDeviceState.FullyCharged;
                    if (charging) {
                        if (pct >= 90) return "󰂅";
                        if (pct >= 80) return "󰂋";
                        if (pct >= 70) return "󰂊";
                        if (pct >= 60) return "󰢞";
                        if (pct >= 50) return "󰂉";
                        if (pct >= 40) return "󰢝";
                        if (pct >= 30) return "󰂈";
                        if (pct >= 20) return "󰂇";
                        if (pct >= 10) return "󰂆";
                        return "󰢟";
                    } else {
                        if (pct >= 90) return "󰁹";
                        if (pct >= 80) return "󰂂";
                        if (pct >= 70) return "󰂁";
                        if (pct >= 60) return "󰂀";
                        if (pct >= 50) return "󰁿";
                        if (pct >= 40) return "󰁾";
                        if (pct >= 30) return "󰁽";
                        if (pct >= 20) return "󰁼";
                        if (pct >= 10) return "󰁻";
                        return "󰂎";
                    }
                }
            }

            Text {
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                color: batteryIcon.color
                text: root.battery ? Math.round(root.battery.percentage) + "%" : "N/A"
            }
        }
    }

    // Low battery blink animation
    SequentialAnimation {
        running: root.battery !== null &&
                 root.battery.percentage <= 15 &&
                 root.battery.state === UPowerDeviceState.Discharging
        loops: Animation.Infinite
        ColorAnimation {
            target: batteryIcon
            property: "color"
            to: Theme.danger
            duration: 500
        }
        ColorAnimation {
            target: batteryIcon
            property: "color"
            to: Theme.white
            duration: 500
        }
    }
}
