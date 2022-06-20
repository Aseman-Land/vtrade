import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import "../components"
import "../models" as Models

Rectangle {
    id: dis
    color: Colors.backgroundDeep

    AsemanFlickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: logoutBtn.top
        anchors.top: header.bottom
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        clip: true

        Item {
            id: scene
            width: flick.width
            height: Math.max(sceneColumn.height + sceneColumn.y * 2, flick.height)

            ColumnLayout {
                id: sceneColumn
                anchors.left: parent.left
                anchors.right: parent.right
                y: 20 * Devices.density
                anchors.margins: y
                spacing: 8 * Devices.density

                RowLayout {
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Dark mode:")
                    }

                    Switch {
                        checked: GlobalSettings.darkMode
                        onClicked: GlobalSettings.darkMode = checked
                    }
                }
            }
        }
    }

    Button {
        id: logoutBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20 * Devices.density
        anchors.rightMargin: 20 * Devices.density
        anchors.bottomMargin: 10 * Devices.density
        anchors.bottom: parent.bottom
        highlighted: true
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Logout") + Translations.refresher
        IOSStyle.accent: "#aa0000"
        Material.accent: "#aa0000"
        onClicked: {
            var properties = {
                "title": qsTr("Logout"),
                "body": qsTr("Do you realy want to logout?"),
                "buttons": [qsTr("Cancel"), qsTr("Logout")]
            };

            var obj = Viewport.controller.trigger("dialog:/general/error", properties);
            obj.itemClicked.connect(function(idx) {
                switch (idx) {
                case 0: // Cancel
                    break;

                case 1: // Logout
                    GlobalSettings.accessToken = "";
                    dis.ViewportType.open = false;
                    break;
                }
                obj.ViewportType.open = false;
            })
        }
    }

    HScrollBar {
        scrollArea: flick
        color: Colors.accent
        anchors.right: flick.right
        anchors.top: flick.top
        anchors.bottom: flick.bottom
    }

    Header {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        light: GlobalSettings.darkMode
        shadow: false
        shadowOpacity: 0
        color: "transparent"
        text: qsTr("Settings") + Translations.refresher

        RowLayout {
            y: Devices.statusBarHeight + Devices.standardTitleBarHeight/2 - height/2
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: cancelBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                Material.accent: Qt.darker(Colors.backgroundDeep, 1.3)
                Material.theme: Material.Dark
                IOSStyle.accent: Qt.darker(Colors.backgroundDeep, 1.3)
                IOSStyle.theme: IOSStyle.Dark
                Material.elevation: 0
                onClicked: dis.ViewportType.open = false
            }
        }
    }
}
