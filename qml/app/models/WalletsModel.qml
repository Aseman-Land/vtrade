import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0 as Req
import globals 1.0

AsemanListModel {
    id: lmodel
    cachePath: Constants.cachePath + "/wallets.data"

    property alias refreshing: req.refreshing

    Req.GetWalletsRequest {
        id: req
        Component.onCompleted: Tools.jsDelayCall(100, doRequest)
        onSuccessfull: {
            lmodel.clear();
            response.wallets.forEach(function(w){ lmodel.insert(0, w); });
        }
    }

    Connections {
        target: GlobalSignals
        function onReloadWallets() {
            lmodel.refresh();
        }
    }

    function refresh() {
        req.doRequest()
    }
}
