import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import globals 1.0
import requests 1.0

AsemanApplication {
    id: app
    applicationName: "VTrade"
    applicationDisplayName: App.name["en"]
    applicationId: App.uniqueId
    organizationDomain: App.organizationDomain
    applicationVersion: App.version
    statusBarStyle: {
        if (mWin.viewport.currentType == "float" && !Devices.isAndroid)
            return AsemanApplication.StatusBarStyleLight;
        else
        if (Colors.darkMode)
            return AsemanApplication.StatusBarStyleLight;
        else
            return AsemanApplication.StatusBarStyleDark;
    }

    Component.onCompleted: {
        if (Devices.isDesktop) Devices.fontScale = 1.1;
        if (Devices.isAndroid) Devices.fontScale = 1.1;
        if (Devices.isIOS) Devices.fontScale = 1.15;

        Fonts.init();
        GTranslations.init();
        Bootstrap.init();
    }

    MainWindow {
        id: mWin
        visible: true
        font.family: Fonts.globalFont
        font.letterSpacing: -0.5
    }
}
