import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import requests 1.0 as Req
import "components"
import "models" as Models

Rectangle {
    id: home
    color: Colors.backgroundLight

    BusyIndicator {
        anchors.centerIn: parent
        running: walletsModel.refreshing
    }

    Label {
        anchors.centerIn: parent
        visible: listv.count == 0
        font.pixelSize: 8 * Devices.fontDensity
        opacity: 0.7
        horizontalAlignment: Text.AlignHCenter
        text: qsTr("There is no wallet here.\nTo add new wallet click on '+' button.") + Translations.refresher
    }

    AsemanListView {
        id: listv
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: header.bottom
        model: Models.WalletsModel { id: walletsModel }
        topMargin: 8 * Devices.density
        delegate: Item {
            width: listv.width
            height: 74 * Devices.density

            Rectangle {
                anchors.fill: parent
                anchors.margins: listv.topMargin * 2
                anchors.topMargin: listv.topMargin
                anchors.bottomMargin: listv.topMargin
                color: marea.pressed? Colors.background : Colors.backgroundDeep
                radius: 8 * Devices.density

                MouseArea {
                    id: marea
                    anchors.fill: parent
                    onClicked: Viewport.controller.trigger("page:/wallets/open", {"title": model.title, "id": model.id})
                }

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 20 * Devices.density
                    spacing: 20 * Devices.density

                    Label {
                        font.family: MaterialIcons.family
                        font.pixelSize: 14 * Devices.fontDensity
                        color: "#fff"
                        text: MaterialIcons.mdi_wallet

                        Rectangle {
                            anchors.centerIn: parent
                            width: 40 * Devices.density
                            height: width
                            radius: width / 2
                            color: Colors.accent
                            z: -1
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        text: model.title
                    }
                }
            }
        }
    }

    HScrollBar {
        scrollArea: listv
        color: Colors.accent
        anchors.right: listv.right
        anchors.top: listv.top
        anchors.bottom: listv.bottom
    }

    Header {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Wallets") + Translations.refresher
        light: GlobalSettings.darkMode
        shadow: false
        color: Colors.primary

        Button {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            flat: true
            font.family: MaterialIcons.family
            font.pixelSize: 14 * Devices.fontDensity
            text: MaterialIcons.mdi_account
            height: Devices.standardTitleBarHeight
            width: height
            onClicked: Viewport.controller.trigger("float:/settings")
        }

        Button {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            flat: true
            font.family: MaterialIcons.family
            font.pixelSize: 14 * Devices.fontDensity
            text: MaterialIcons.mdi_plus
            height: Devices.standardTitleBarHeight
            width: height
            onClicked: Viewport.controller.trigger("float:/wallets/add")
        }
    }
}
