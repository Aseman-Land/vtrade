pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0

AsemanObject {
    signal reloadWallets();
    signal snackbarMessage(string msg)
    signal reloadWallet(int walletId)
    signal ordersRequest(int walletId)
}

