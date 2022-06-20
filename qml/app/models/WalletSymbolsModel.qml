import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0 as Req
import globals 1.0

AsemanListModel {
    id: lmodel

    property alias refreshing: req.refreshing
    readonly property double totalValueUSDT: prv.totalValueUSDT
    property alias availableSymbolsHash: availableSymbolsHash

    property alias walletId: req.walletId
    property bool showSmallAssets: true
    property string keyword

    onShowSmallAssetsChanged: req.reload()
    onKeywordChanged: req.reload()

    Connections {
        target: GlobalSignals
        onReloadWallet: if (lmodel.walletId == walletId) lmodel.refresh()
    }

    QtObject {
        id: prv
        property double totalValueUSDT
    }

    HashObject {
        id: availableSymbolsHash
    }

    Req.GetWalletRequest {
        id: req
        Component.onCompleted: Tools.jsDelayCall(100, doRequest)
        onSuccessfull: reload()

        function reload() {
            lmodel.clear();
            availableSymbolsHash.clear();
            if (!response)
                return;

            var total = 0;
            var list = response.wallet.symbols;
            list.forEach(function(w){
                var prc = w.volume * w.price;
                total += prc;

                availableSymbolsHash.insert(w.symbol, w.volume);
                if (prc < 1 && !showSmallAssets)
                    return;
                if (keyword.length && w.symbol.toLowerCase().indexOf(keyword.toLowerCase()) < 0)
                    return;

                lmodel.append(w);
            });

            prv.totalValueUSDT = total;
        }
    }

    function refresh() {
        req.doRequest()
    }
}
