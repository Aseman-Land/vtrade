pragma Singleton

import QtQuick 2.10
import AsemanQml.Base 2.0

QtObject {
    readonly property int width: 480
    readonly property int height: 800
    readonly property int radius: 10 * Devices.density

    readonly property string cachePath: AsemanApp.homePath + "/cache"

    readonly property int version: 0

    Component.onCompleted: {
        Tools.mkDir(cachePath)
    }
}
