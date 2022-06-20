import QtQuick 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls.Material 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import requests 1.0 as Req
import "../components"
import "../routes"

Rectangle {
    id: dis
    color: Colors.backgroundDeep
    width: parent.width
    height: 400

    property string symbol: "BTC"
    property string unit: "USDT"
    property real price: 1
    property real volume
    property real unitVolume
    property alias id: addReq._walletId

    property int decimals: 10000000

    signal closeRequest()

    Req.AddOrderRequest {
        id: addReq
        sell: tabBar.currentIndex? dis.symbol : dis.unit
        buy: tabBar.currentIndex? dis.unit : dis.symbol
        price: "" + (tabBar.currentIndex? price.text*1 : 1/price.text)
        volume: "" + (tabBar.currentIndex? volume.text*1 : volume.text * price.text)
        sell_order: tabBar.currentIndex
        allowGlobalBusy: true
        onSuccessfull: {
            GlobalSignals.snackbarMessage(qsTr("Order placed successfully"))
            GlobalSignals.reloadWallet(addReq._walletId);
            GlobalSignals.ordersRequest(addReq._walletId);
            dis.closeRequest();
        }
    }

    TabBar {
        id: tabBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom

        TabButton {
            text: qsTr("BUY")
            font.pixelSize: 9 * Devices.fontDensity
        }
        TabButton {
            text: qsTr("SELL")
            font.pixelSize: 9 * Devices.fontDensity
        }
    }

    AsemanFlickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: addBtn.top
        anchors.top: tabBar.bottom
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height

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

                ComboBox {
                    id: orderType
                    font.pixelSize: 9 * Devices.fontDensity
                    Layout.fillWidth: true
                    model: [qsTr("Limit"), qsTr("Market"), qsTr("Stop Limit"), qsTr("Stop Market")]
                    enabled: false
                }

                Label {
                    Layout.topMargin: 20 * Devices.density
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    font.bold: true
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Price:")
                }

                TextField {
                    id: price
                    font.pixelSize: 9 * Devices.fontDensity
                    Layout.fillWidth: true
                    Layout.preferredHeight: 46 * Devices.density
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: RegularExpressionValidator { regularExpression: /(\d|\.)*/ }
                    placeholderText: qsTr("Price") + Translations.refresher
                    text: dis.price

                    Label {
                        anchors.right: parent.right
                        anchors.rightMargin: 10 * Devices.density
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3 * Devices.fontDensity
                        text: dis.unit
                        color: Colors.accent
                    }
                }

                Label {
                    Layout.topMargin: 20 * Devices.density
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    font.bold: true
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Volume:")
                }

                ColumnLayout {
                    spacing: 2 * Devices.density

                    TextField {
                        id: volume
                        font.pixelSize: 9 * Devices.fontDensity
                        Layout.fillWidth: true
                        Layout.preferredHeight: 46 * Devices.density
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: RegularExpressionValidator { regularExpression: /(\d|\.)*/ }
                        placeholderText: qsTr("Volume") + Translations.refresher
                        onTextChanged: if (!slider.pressed) slider.value = text * 1

                        Label {
                            anchors.right: parent.right
                            anchors.rightMargin: 10 * Devices.density
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 3 * Devices.fontDensity
                            text: dis.symbol
                            color: Colors.accent
                        }
                    }

                    Label {
                        id: available
                        Layout.fillWidth: true
                        font.pixelSize: 7 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        opacity: 0.7
                        text: qsTr("Available %1").arg("" + (tabBar.currentIndex? dis.volume : unitVolume)) + " " + (tabBar.currentIndex? dis.symbol : dis.unit)
                    }

                    Slider {
                        id: slider
                        Layout.fillWidth: true
                        from: 0
                        to: tabBar.currentIndex? dis.volume : (dis.unitVolume / price.text)
                        labelDecimals: 5
                        labelVisible: pressed
                        labelUnit: dis.symbol
                        stepSize: to / 10000
                        onValueChanged: if (!volume.focus) volume.text = "" + Math.floor(slider.value * decimals) / decimals
                    }
                }

                Label {
                    Layout.topMargin: 20 * Devices.density
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    font.bold: true
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("EST. Value:")
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    text: Math.floor((tabBar.currentIndex? slider.value * price.text : slider.value) * decimals) / decimals + " " + (tabBar.currentIndex? dis.unit : dis.symbol)
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
        text: tabBar.currentIndex? qsTr("SELL") : qsTr("BUY") + Translations.refresher
        IOSStyle.accent: tabBar.currentIndex? "#aa0000" : Colors.accent
        Material.accent: tabBar.currentIndex? "#aa0000" : Colors.accent
        onClicked: {
            addReq.doRequest()
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
        text: dis.symbol
        color: "transparent"

        RowLayout {
            y: Devices.statusBarHeight + Devices.standardTitleBarHeight/2 - height/2
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight

            Button {
                id: chartBtn
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                flat: true
                font.family: MaterialIcons.family
                font.pixelSize: 14 * Devices.fontDensity
                text: MaterialIcons.mdi_chart_bar
                Layout.preferredHeight: Devices.standardTitleBarHeight
                Layout.preferredWidth: Devices.standardTitleBarHeight
                highlighted: true
                onClicked: Viewport.viewport.append(chartViewComponent, {}, "page")
            }

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
                onClicked: dis.closeRequest()
            }
        }
    }

    Component {
        id: chartViewComponent
        WebBrowserPage {
            anchors.fill: parent
            link: "https://www.tradingview.com/chart/?symbol=" + dis.symbol + dis.unit
            title: dis.symbol + "/" + dis.unit
        }
    }
}
