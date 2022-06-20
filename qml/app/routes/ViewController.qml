pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0

ViewportController {
    id: viewController

    readonly property int waitCount: GlobalSettings.waitCount
    property variant waitObj

    onWaitCountChanged: {
        if (waitCount) {
            if (!waitObj) waitObj = trigger("dialog:/wait");
        } else {
            if (waitObj) waitObj.close()
        }
    }

    ViewportControllerRoute {
        route: /dialog\:\/general\/error.*/
        source: "ErrorDialog.qml"
    }

    ViewportControllerRoute {
        route: /dialog\:\/wait/
        source: "WaitDialog.qml"
    }

    ViewportControllerRoute {
        route: /\w+:\/settings/
        source: "../pages/Settings.qml"
    }

    ViewportControllerRoute {
        route: /\w+:\/signup/
        source: "../auth/SignupPage.qml"
    }

    ViewportControllerRoute {
        route: /\w+:\/web\/browse/
        source: "WebBrowserPage.qml"
    }

    ViewportControllerRoute {
        route: /\w+:\/wallets\/add/
        source: "../pages/AddWallet.qml"
    }

    ViewportControllerRoute {
        route: /\w+:\/wallets\/open(?:\?.+)?/
        source: "../pages/WalletPage.qml"
    }

    ViewportControllerRoute {
        route: /\w+:\/wallets\/buy/
        source: "../pages/SymbolViewport.qml"
    }
}

