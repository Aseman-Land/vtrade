pragma Singleton

import QtQuick 2.10
import QtQuick.Controls.Material 2.0
import AsemanQml.Base 2.0

AsemanObject
{
    property alias ubuntuFont: ubuntu_font.name
    property alias iranSansFont: iran_sans.name
    property alias shabnamFont: shabnam.name
    readonly property url resourcePath: "fonts"

    property string globalFont: ubuntuFont + ", " + shabnamFont + ", Noto Color Emoji"

    FontLoader { id: shabnam; source: "fonts/Shabnam.ttf"}
    FontLoader { id: iran_sans; source: "fonts/IRANSans_Regular.ttf"}
    FontLoader { id: ubuntu_font; source: "fonts/Ubuntu-R.ttf" }

    function init() {
        AsemanApp.globalFont.family = globalFont
    }
}
