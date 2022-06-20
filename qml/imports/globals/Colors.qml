pragma Singleton

import QtQuick 2.10
import AsemanQml.Base 2.0
import VTrade 1.0

QtObject {
    readonly property color accent: darkMode? "#a379ff" : "#5b24bd"
    readonly property color primary: darkMode? "#1a1a1a" : "#fafafa"

    readonly property color background: darkMode? "#1a1a1a" : "#f4f4f4"
    readonly property color backgroundDeep: darkMode? "#333" : "#fff"
    readonly property color backgroundLight: darkMode? "#000" : "#eee"

    readonly property color foreground: darkMode? "#fff" : "#222"

    readonly property bool darkMode: GlobalSettings.darkMode

    Component.onCompleted: VTradeTools.setupWindowColor(backgroundDeep)
    onBackgroundDeepChanged: VTradeTools.setupWindowColor(backgroundDeep)
}
