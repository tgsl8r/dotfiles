pragma Singleton
import QtQuick

QtObject {
    // Catppuccin Macchiato palette
    readonly property color base: "#000000"
    readonly property color mantle: "#000000"
    readonly property color crust: "#000000"
    readonly property color white: "#e2dee0"

    readonly property color text: "#cad3f5"
    readonly property color subtext0: "#a5adcb"
    readonly property color subtext1: "#b8c0e0"

    readonly property color surface0: "#363a4f"
    readonly property color surface1: "#494d64"
    readonly property color surface2: "#5b6078"

    readonly property color overlay0: "#6e738d"
    readonly property color overlay1: "#8087a2"
    readonly property color overlay2: "#939ab7"

    readonly property color blue: "#8aadf4"
    readonly property color lavender: "#b7bdf8"
    readonly property color sapphire: "#7dc4e4"
    readonly property color sky: "#91d7e3"
    readonly property color teal: "#8bd5ca"
    readonly property color green: "#a6da95"
    readonly property color yellow: "#eed49f"
    readonly property color peach: "#f5a97f"
    readonly property color maroon: "#ee99a0"
    readonly property color red: "#ed8796"
    readonly property color mauve: "#c6a0f6"
    readonly property color pink: "#f5bde6"
    readonly property color flamingo: "#f0c6c6"
    readonly property color rosewater: "#f4dbd6"

    readonly property color barBg: Qt.lighter(base, 1.0)
    readonly property color moduleBg: Qt.lighter(base, 1.1)
    readonly property color popupBg: Qt.lighter(base, 1.05)
    readonly property color popupBorder: surface0
    readonly property color highlight: surface0
    readonly property color highlightText: white
    readonly property color dimText: overlay0
    readonly property color danger: "#bf616a"

    readonly property string fontFamily: "Atkinson Hyperlegible Nerd Font"
    readonly property int fontSize: 12
    readonly property int iconSize: 14

    readonly property int barHeight: 30
    readonly property int barRadius: 10
    readonly property int popupWidth: 360
    readonly property int popupRadius: 10
    readonly property int itemHeight: 36
    readonly property int itemRadius: 6
    readonly property int spacing: 8
    readonly property int padding: 10
}
