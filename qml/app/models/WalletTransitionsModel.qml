import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0 as Req
import globals 1.0

AsemanListModel {
    id: lmodel

    property alias refreshing: req.refreshing
    property alias walletId: req.walletId

    signal newItemArrived()

    Connections {
        target: GlobalSignals
        onReloadWallet: if (lmodel.walletId == walletId) lmodel.refresh()
    }

    Req.GetTransitionsRequest {
        id: req
        Component.onCompleted: Tools.jsDelayCall(100, doRequest)
        onSuccessfull: reload()

        function reload() {
            lmodel.clear();
            var list = response.transitions;
            list.forEach(lmodel.append);

            if (_last_count != -1 && _last_count != lmodel.count)
                lmodel.newItemArrived();
            _last_count = lmodel.count;
        }

        property int _last_count: -1
    }

    function refresh() {
        req.doRequest()
    }
}
