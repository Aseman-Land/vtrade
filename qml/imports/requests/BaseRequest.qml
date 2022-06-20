import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Network 2.0
import AsemanQml.Viewport 2.0
import globals 1.0

NetworkRequest {
    id: req
    contentType: 0//NetworkRequest.TypeJson
    ignoreKeys: ["baseUrl", "refreshingState", "allowGlobalBusy", "allowShowErrors", "forceAllowUnreachable"]
    ignoreRegExp: /^_\w+$/
    headers: {
        "Device-ID": Devices.deviceId,
        "Content-Type": "application/json",
        "Authorization": "Bearer " + GlobalSettings.accessToken,
        "Accept-Language": "fa",
        "Accept": "application/json"
    }

    readonly property string baseUrl: App.domain + "/api"
    readonly property bool refreshingState: req.refreshing
    property bool allowGlobalBusy: false
    property bool allowShowErrors: true
    property bool forceAllowUnreachable: false

    property alias _networkManager: networkManager
    property bool _debug: false

    signal refreshRequest()

    onErrorChanged: if ((error.indexOf("HostNotFoundError") != -1 || error.indexOf("UnknownNetworkError") != -1) && (forceAllowUnreachable || allowGlobalBusy)) mainController.trigger("dialog:/general/error", {"title": qsTr("Client Error"), "body": qsTr("Network Unreachable")})
    onResponseChanged: if (_debug) console.debug(Tools.variantToJson(response))
    onHeadersChanged: if (!refreshing) refreshRequest()
    onRefreshingStateChanged: {
        if (!allowGlobalBusy)
            return;

        if (refreshingState)
            GlobalSettings.waitCount++
        else
            GlobalSettings.waitCount--
    }

    Component.onDestruction: if (refreshingState && allowGlobalBusy) GlobalSettings.waitCount--

    onServerError: {
        if (status == 405)
            return;
        try {
            _showError(qsTr("Server Error"), response.message? response.message : error)
        } catch (e) {}
    }
    onClientError: {
        if (status == 405)
            return;
        try {
            _showError(qsTr("Client Error"), response.message? response.message : error);
        } catch (e) {}
    }

    function _showError(title, body) {
        if (testMode)
            return;
        if (!allowShowErrors)
            return;
        Tools.jsDelayCall(500, function() {
            mainController.trigger("dialog:/general/error", {"title": title, "body": body})
        })
    }

    NetworkRequestManager {
        id: networkManager
        ignoreSslErrors: App.ignoreSslErrors
    }

    Timer {
        repeat: false
        running: true
        interval: 100
        onTriggered: refreshRequest()
    }
}
