import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Network 2.0
import globals 1.0

BaseRequest {
    id: req
    contentType: NetworkRequest.TypeJson
    url: baseUrl + "/v1/wallet/" + _walletId

    property int _walletId

    function doRequest(pass) {
        _networkManager.deleteMethod(req)
    }
}
