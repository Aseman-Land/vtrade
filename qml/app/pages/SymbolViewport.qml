import QtQuick 2.0
import AsemanQml.Viewport 2.0
import globals 1.0

Viewport {
    id: dis

    property alias symbol: smb.symbol
    property alias unit: smb.unit
    property alias price: smb.price
    property alias volume: smb.volume
    property alias unitVolume: smb.unitVolume
    property alias id: smb.id

    mainItem: SymbolPage {
        id: smb
        anchors.fill: parent
        onCloseRequest: dis.ViewportType.open = false
    }
}
