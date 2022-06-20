import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import "../components"
import "../models" as Models

Item {

    property alias walletId: walletModel.walletId

    BusyIndicator {
        anchors.centerIn: parent
        running: walletModel.refreshing
    }

    AsemanListView {
        id: listv
        anchors.fill: parent
        model: Models.WalletSymbolsModel {
            id: walletModel
            showSmallAssets: !GlobalSettings.hideSmallAssets
        }
        topMargin: 8 * Devices.density
        clip: true

        header: Item {
            width: listv.width
            height: headerColumn.height + headerColumn.y*2

            ColumnLayout {
                id: headerColumn
                y: listv.topMargin * 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: y

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100 * Devices.density
                    radius: Constants.radius
                    color: Colors.accent

                    Label {
                        anchors.centerIn: parent
                        font.pixelSize: 20 * Devices.fontDensity
                        color: "#ffffff"
                        text: {
                            var floored = formater.input * 1;
                            var floater = (Math.floor((walletModel.totalValueUSDT - floored) * 100) / 100);
                            return formater.output + (floater + "").slice(1) + "$";
                        }

                        TextFormater {
                            id: formater
                            count: 3
                            delimiter: ","
                            input: Math.floor(walletModel.totalValueUSDT)
                        }
                    }
                }

                TextField {
                    id: keyword
                    Layout.fillWidth: true
                    Layout.preferredHeight: 46 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    rightPadding: smallAssetsRow.width + 10 * Devices.density
                    placeholderText: qsTr("Search") + Translations.refresher
                    onTextChanged: keywordTimer.restart()

                    Timer {
                        id: keywordTimer
                        interval: 300
                        repeat: false
                        onTriggered: walletModel.keyword = keyword.text
                    }

                    RowLayout {
                        id: smallAssetsRow
                        anchors.right: parent.right
                        anchors.rightMargin: -5 * Devices.density
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3 * Devices.fontDensity
                        spacing: 0

                        Label {
                            font.pixelSize: 7 * Devices.fontDensity
                            opacity: 0.7
                            text: qsTr("Hide small assets")
                        }
                        Switch {
                            checked: GlobalSettings.hideSmallAssets
                            onCheckedChanged: GlobalSettings.hideSmallAssets = checked
                        }
                    }
                }
            }
        }

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
                    onClicked: if (model.symbol != "USDT") Viewport.controller.trigger("float:/wallets/buy", {"symbol": model.symbol, "id": dis.id, "price": model.price, "volume": model.volume, "unit": model.unit, "unitVolume": walletModel.availableSymbolsHash.value(model.unit)})
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
                        text: MaterialIcons.mdi_coins

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
                        text: model.symbol
                    }

                    ColumnLayout {
                        spacing: 0
                        Label {
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 9 * Devices.fontDensity
                            color: Colors.accent
                            text: {
                                var floored = symbolFormat.input * 1;
                                var floater = (Math.floor((model.volume - floored) * 100000) / 100000);
                                return symbolFormat.output + (floater + "").slice(1)
                            }

                            TextFormater {
                                id: symbolFormat
                                count: 3
                                delimiter: ","
                                input: Math.floor(model.volume)
                            }
                        }

                        Label {
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 7 * Devices.fontDensity
                            visible: model.symbol != "USDT"
                            opacity: 0.6
                            text: {
                                var floored = volumeFormat.input * 1;
                                var floater = (Math.floor(((model.volume * model.price) - floored) * 100000) / 100000);
                                return volumeFormat.output + (floater + "").slice(1) + "$"
                            }

                            TextFormater {
                                id: volumeFormat
                                count: 3
                                delimiter: ","
                                input: Math.floor(model.volume * model.price)
                            }
                        }
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
}
