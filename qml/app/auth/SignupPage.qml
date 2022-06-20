import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import requests 1.0 as Req
import "../components"

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    Req.SignupRequest {
        id: signupReq
        allowGlobalBusy: true
        fullname: fullnameField.text
        username: userLbl.text
        onSuccessfull: {
            dis.ViewportType.open = false;
            GlobalSettings.accessToken = response.token;
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Colors.backgroundDeep }
            GradientStop { position: 1.0; color: Colors.background }
        }
    }

    EscapeItem {
        anchors.left: parent.left
        anchors.leftMargin: 80 * Devices.density
        anchors.right: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        visible: !mobileView

        Image {
            width: parent.width * 0.6
            height: parent.height * 0.6
            sourceSize: Qt.size(width*1.2, height*1.2)
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: Colors.darkMode? "../files/login_dark.png" : "../files/login_light.png"
        }
    }

    Item {
        anchors.right: parent.right
        anchors.rightMargin: mobileView? 0 : 80 * Devices.density
        anchors.left: mobileView? parent.left : parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        ColumnLayout {
            width: parent.width * 0.6
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -50 * Devices.density

            Label {
                font.pixelSize: 16 * Devices.fontDensity
                font.bold: true
                text: qsTr("Welcome Back") + Translations.refresher
            }

            TextField {
                id: fullnameField
                Layout.fillWidth: true
                placeholderText: qsTr("Fullname") + Translations.refresher
                font.pixelSize: 9 * Devices.fontDensity
                horizontalAlignment: Text.AlignLeft
                selectByMouse: true
                leftPadding: GTranslations.reverseLayout? 0 : 40 * Devices.density
                rightPadding: GTranslations.reverseLayout? 40 * Devices.density : 0
                Layout.preferredHeight: 50 * Devices.density
                onAccepted: userLbl.focus = true

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Devices.density
                    anchors.verticalCenterOffset: 3 * Devices.density
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: MaterialIcons.family
                    font.pixelSize: 12 * Devices.fontDensity
                    opacity: 0.6
                    text: MaterialIcons.mdi_account
                }
            }

            TextField {
                id: userLbl
                Layout.fillWidth: true
                placeholderText: qsTr("Username") + Translations.refresher
                font.pixelSize: 9 * Devices.fontDensity
                horizontalAlignment: Text.AlignLeft
                selectByMouse: true
                leftPadding: GTranslations.reverseLayout? 0 : 40 * Devices.density
                rightPadding: GTranslations.reverseLayout? 40 * Devices.density : 0
                Layout.preferredHeight: 50 * Devices.density
                onAccepted: passLbl.focus = true

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Devices.density
                    anchors.verticalCenterOffset: 3 * Devices.density
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: MaterialIcons.family
                    font.pixelSize: 12 * Devices.fontDensity
                    opacity: 0.6
                    text: MaterialIcons.mdi_account
                }
            }

            TextField {
                id: passLbl
                Layout.fillWidth: true
                placeholderText: qsTr("Password") + Translations.refresher
                font.pixelSize: 9 * Devices.fontDensity
                horizontalAlignment: Text.AlignLeft
                echoMode: TextField.Password
                selectByMouse: true
                leftPadding: GTranslations.reverseLayout? 0 : 40 * Devices.density
                rightPadding: GTranslations.reverseLayout? 40 * Devices.density : 0
                Layout.preferredHeight: 50 * Devices.density
                onAccepted: if(signupBtn.enabled) signupReq.doRequest(passLbl.text)

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * Devices.density
                    anchors.verticalCenterOffset: 3 * Devices.density
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: MaterialIcons.family
                    font.pixelSize: 12 * Devices.fontDensity
                    opacity: 0.6
                    text: MaterialIcons.mdi_textbox_password
                }
            }

            Button {
                id: signupBtn
                Layout.fillWidth: true
                text: qsTr("Signup") + Translations.refresher
                enabled: passLbl.length>3 && userLbl.length>2
                highlighted: true
                font.pixelSize: 9 * Devices.fontDensity
                onClicked: signupReq.doRequest(passLbl.text)
            }

            Button {
                id: cancelBtn
                Layout.fillWidth: true
                text: qsTr("Cancel") + Translations.refresher
                font.pixelSize: 9 * Devices.fontDensity
                onClicked: dis.ViewportType.open = false
            }
        }
    }
}
