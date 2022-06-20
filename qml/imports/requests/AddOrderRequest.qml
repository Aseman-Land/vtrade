import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Network 2.0
import globals 1.0

BaseRequest {
    id: req
    contentType: NetworkRequest.TypeJson
    url: baseUrl + "/v1/wallet/" + _walletId + "/orders"

    property int _walletId
    property string sell
    property string buy
    property string volume
    property string price
    property int sell_order

    function doRequest(pass) {
        _networkManager.post(req)
    }
}
