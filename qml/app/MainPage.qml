import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls.Material 2.0
import AsemanQml.MaterialIcons 2.0
import globals 1.0
import requests 1.0
import "auth" as Auth
import "models" as Models
import "routes"
import "components"

Page {
    font.family: Fonts.globalFont

    IOSStyle.accent: Colors.accent
    IOSStyle.primary: Colors.primary

    Material.accent: Colors.accent
    Material.primary: Colors.primary

    property alias viewport: mainViewport
    property ViewportController mainController: ViewController
    readonly property bool mobileView: width < height

    Viewport {
        id: mainViewport
        anchors.fill: parent
        mainItem: Page {
            anchors.fill: parent

            Loader {
                anchors.fill: parent
                active: GlobalSettings.accessToken.length !== 0
                sourceComponent: Home {
                    anchors.fill: parent
                }
            }

            Loader {
                anchors.fill: parent
                active: GlobalSettings.accessToken.length === 0
                sourceComponent: Auth.AuthPage {
                    anchors.fill: parent
                }
            }
        }
        Component.onCompleted: ViewController.viewport = mainViewport
    }

    Connections {
        target: GlobalSignals
        function onSnackbarMessage(msg) {
            snackBar.open(msg)
        }
    }

    Snackbar {
        id: snackBar
        width: parent.width
        anchors.bottom: parent.bottom
        z: 1000
    }
}
