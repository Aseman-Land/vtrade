import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import globals 1.0
import requests 1.0 as Req
import "../components"
import "../models" as Models

Rectangle {
    id: dis
    color: Colors.backgroundLight

    property alias title: header.text
    property alias id: symbols.walletId

    TabBar {
        id: tabBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        currentIndex: swipe.currentIndex

        TabButton {
            text: qsTr("Symbols")
            font.pixelSize: 9 * Devices.fontDensity
        }
        TabButton {
            text: qsTr("Orders")
            font.pixelSize: 9 * Devices.fontDensity
        }
        TabButton {
            text: qsTr("Transitions")
            font.pixelSize: 9 * Devices.fontDensity
        }
    }

    SwipeView {
        id: swipe
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: tabBar.bottom
        currentIndex: tabBar.currentIndex

        WalletSymbols { id: symbols }
        WalletOrders {
            walletId: symbols.walletId
            onNewItemArrived: swipe.setCurrentIndex(1)
        }
        WalletTransitions {
            walletId: symbols.walletId
            onNewItemArrived: swipe.setCurrentIndex(2)
        }
    }

    Header {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        light: GlobalSettings.darkMode
        shadow: false
        color: Colors.primary

        HeaderMenuButton {
            ratio: 1
            buttonColor: Colors.foreground
            onClicked: dis.ViewportType.open = false
        }

        Button {
            id: deleteBtn
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            flat: true
            font.family: MaterialIcons.family
            font.pixelSize: 14 * Devices.fontDensity
            text: MaterialIcons.mdi_dots_vertical
            height: Devices.standardTitleBarHeight
            width: height
            onClicked: {
                var pos = Qt.point(dis.LayoutMirroring.enabled? Constants.radius : deleteBtn.width - Constants.radius, deleteBtn.height);
                var parent = deleteBtn;
                while (parent && parent != dis) {
                    pos.x += parent.x;
                    pos.y += parent.y;
                    parent = parent.parent;
                }

                Viewport.viewport.append(menuComponent, {"pointPad": pos}, "menu");
            }
        }
    }

    function deleteRequest() {
        var properties = {
            "title": qsTr("Delete"),
            "body": qsTr("Do you realy want to delete this wallet?"),
            "buttons": [qsTr("Cancel"), qsTr("Delete")]
        };

        var obj = Viewport.controller.trigger("dialog:/general/error", properties);
        obj.itemClicked.connect(function(idx) {
            switch (idx) {
            case 0: // Cancel
                break;

            case 1: // Delete
                deleteReq.doRequest();
                break;
            }
            obj.ViewportType.open = false;
        })
    }

    function renameRequest() {
        Viewport.viewport.append(renameComponent, {}, "dialog");
    }

    Req.DeleteWalletRequest {
        id: deleteReq
        allowGlobalBusy: true
        _walletId: dis.id
        onSuccessfull: {
            dis.ViewportType.open = false;
            GlobalSignals.snackbarMessage( qsTr("Wallet deleted successfully") );
            GlobalSignals.reloadWallets();
        }
    }

    Component {
        id: renameComponent
        ChangeName {
            id: renameDlg
            cancelBtn.onClicked: renameDlg.ViewportType.open = false;
            confirmBtn.onClicked: confirm()
            nameField.onAccepted: confirm()

            function confirm() {
                req.title = nameField.text;
                req.doRequest();
            }

            Req.RenameWalletRequest {
                id: req
                allowGlobalBusy: true
                _walletId: dis.id
                onSuccessfull: {
                    dis.title = req.title
                    renameDlg.ViewportType.open = false;
                    GlobalSignals.snackbarMessage( qsTr("Name updated successfully") );
                    GlobalSignals.reloadWallets();
                }
            }
        }
    }

    Component {
        id: menuComponent
        MenuView {
            id: menuItem
            x: pointPad.x - width
            y: Math.min(pointPad.y, dis.height - height - 100 * Devices.density)
            width: 220 * Devices.density
            ViewportType.transformOrigin: {
                var y = 0;
                var x = dis.LayoutMirroring.enabled? 0 : width;
                return Qt.point(x, y);
            }

            property point pointPad
            property int index

            onItemClicked: {
                switch (index) {
                case 0:
                    renameRequest()
                    break;
                case 1:
                    deleteRequest()
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: qsTr("Change Name"),
                        icon: "mdi_rename_box",
                        enabled: true
                    },
                    {
                        title: qsTr("Delete Wallet"),
                        icon: "mdi_trash_can",
                        enabled: true
                    },
                ]
            }
        }
    }
}
