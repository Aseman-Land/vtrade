import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import "app"

AsemanWindow {
    id: mwin
    width: GlobalSettings.width;    onWidthChanged: GlobalSettings.width = width;
    height: GlobalSettings.height;  onHeightChanged: GlobalSettings.height = height;

    IOSStyle.theme: Colors.darkMode? IOSStyle.Dark : IOSStyle.Light
    Material.theme: Colors.darkMode? Material.Dark : Material.Light

    property alias viewport: app.viewport

    LayoutMirroring.enabled: GTranslations.reverseLayout
    LayoutMirroring.childrenInherit: true

    Rectangle {
        id: statusBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.statusBarHeight
        color: Colors.backgroundDeep
    }

    MainPage {
        id: app
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
