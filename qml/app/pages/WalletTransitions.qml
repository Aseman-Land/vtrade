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

Item {
    id: dis

    property alias walletId: walletModel.walletId

    signal newItemArrived()

    BusyIndicator {
        anchors.centerIn: parent
        running: walletModel.refreshing
    }

    Label {
        anchors.centerIn: parent
        visible: listv.count == 0
        font.pixelSize: 8 * Devices.fontDensity
        opacity: 0.7
        text: qsTr("There is no transitions") + Translations.refresher
    }

    AsemanListView {
        id: listv
        anchors.fill: parent
        model: Models.WalletTransitionsModel {
            id: walletModel
            onNewItemArrived: dis.newItemArrived();
        }
        topMargin: 8 * Devices.density
        clip: true
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
                }

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10 * Devices.density
                    anchors.margins: 20 * Devices.density
                    spacing: 10 * Devices.density

                    Label {
                        font.family: MaterialIcons.family
                        font.pixelSize: 14 * Devices.fontDensity
                        color: "#fff"
                        text: MaterialIcons.mdi_coins
                        Layout.rightMargin: 10 * Devices.density

                        Rectangle {
                            anchors.centerIn: parent
                            width: 40 * Devices.density
                            height: width
                            radius: width / 2
                            color: model.sell_order? "#aa0000" : Colors.accent
                            z: -1
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        color: model.sell_order? "#aa0000" : Colors.accent
                        text: model.sell_order? qsTr("SELL") : qsTr("BUY") + Translations.refresher
                    }

                    ColumnLayout {
                        spacing: 0
                        Label {
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 9 * Devices.fontDensity
                            color: Colors.accent
                            text: {
                                var floored = symbolFormat.input * 1;
                                var floater = (Math.floor((symbolFormat.value - floored) * 100000) / 100000);
                                return symbolFormat.output + (floater + "").slice(1) + " " + (model.sell_order? model.source : model.destination)
                            }

                            TextFormater {
                                id: symbolFormat
                                count: 3
                                delimiter: ","
                                input: Math.floor(value)

                                readonly property real value: model.sell_order? model.volume : (model.volume * model.unit_price)
                            }
                        }

                        Label {
                            Layout.alignment: Qt.AlignRight
                            font.pixelSize: 7 * Devices.fontDensity
                            opacity: 0.6
                            text: {
                                var floored = volumeFormat.input * 1;
                                var floater = (Math.floor((volumeFormat.value - floored) * 100000) / 100000);
                                return volumeFormat.output + (floater + "").slice(1) + "$"
                            }

                            TextFormater {
                                id: volumeFormat
                                count: 3
                                delimiter: ","
                                input: Math.floor(value)

                                readonly property real value: model.sell_order? (model.volume * model.unit_price) : model.volume
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
