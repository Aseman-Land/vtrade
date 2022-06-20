import QtQuick 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import requests 1.0 as Req
import "../components"

Rectangle {
    id: addWallet
    color: Colors.backgroundDeep
    width: parent.width
    height: 400

    Req.AddWalletRequest {
        id: addReq
        allowGlobalBusy: true
        title: titleField.text
        initialize_price: valueIni.value
        onSuccessfull: {
            GlobalSignals.snackbarMessage(qsTr("\"%1\" wallet added").arg(title))
            GlobalSignals.reloadWallets();
            addWallet.ViewportType.open = false
        }
    }

    AsemanFlickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: addBtn.top
        anchors.top: header.bottom
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        clip: true

        EscapeItem {
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

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    font.bold: true
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Wallet name:")
                }

                TextField {
                    id: titleField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    placeholderText: qsTr("Title") + Translations.refresher
                }

                Label {
                    Layout.topMargin: 20 * Devices.density
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    font.bold: true
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Initianlized Value:")
                }

                ModernSpinBox {
                    id: valueIni
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200 * Devices.density
                    color: Colors.accent
                    unit: "USDT"
                }
            }
        }
    }

    Button {
        id: addBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20 * Devices.density
        anchors.rightMargin: 20 * Devices.density
        anchors.bottomMargin: 10 * Devices.density
        anchors.bottom: parent.bottom
        highlighted: true
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Create Wallet") + Translations.refresher
        onClicked: addReq.doRequest()
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
        text: qsTr("Add Wallet") + Translations.refresher
        light: GlobalSettings.darkMode
        shadow: false
        shadowOpacity: 0
        color: "transparent"

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
                onClicked: addWallet.ViewportType.open = false
            }
        }
    }
}
