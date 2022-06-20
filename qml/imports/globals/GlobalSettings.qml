pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0

AsemanObject {

    property int waitCount
    property bool languageInited: false

    property alias accessToken: _auth.accessToken
    property alias name: _auth.name
    property alias userId: _auth.userId
    property int userRole
    property int assignLimit
    property int blocksUnfinished

    readonly property bool adminMode: userRole == 255
    readonly property string displayName: formName(name)
    readonly property bool limitReached: blocksUnfinished >= assignLimit

    property alias width: _settings.width
    property alias height: _settings.height

    property alias introDone: _settings.introDone
    property alias darkMode: _settings.darkMode
    property alias language: _settings.language
    property alias hideSmallAssets: _settings.hideSmallAssets

    function formName(n) {
        if (n.length == 0)
            return "";

        return n[0].toUpperCase() + n.slice(1).toLowerCase();
    }

    onAccessTokenChanged: {
        if (accessToken.length != 0)
            return;

        introDone = false
        userId = 0;
        name = "";
    }

    Settings {
        id: _auth
        category: "General"
        source: AsemanApp.homePath + "/auth.ini"

        property string accessToken
        property string userId
        property string name
    }

    Settings {
        id: _settings
        category: "General"
        source: AsemanApp.homePath + "/settings.ini"

        property bool introDone: false
        property bool darkMode: false
        property bool hideSmallAssets: false

        property real width: 450
        property real height: 750

        property string language: "en"
    }
}

