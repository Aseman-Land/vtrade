import QtQuick 2.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import globals 1.0

Item {
    id: dis

    property alias color: area.color
    property string unit
    property double minimum: 1
    property double maximum: slider.goldMaximum

    property bool middleMode: false
    property double baseValue: 0

    readonly property real value: priceFormat.price

    ColumnLayout {
        id: sceneColumn
        anchors.fill: parent
        spacing: 8 * Devices.density

        Rectangle {
            id: area
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Constants.radius

            Label {
                anchors.centerIn: parent
                color: "#ffffff"
                font.pixelSize: 18 * Devices.fontDensity
                text: {
                    var log = Math.floor(Math.log(priceFormat.price * 100)/Math.log(10));
                    var decimals = 6 - log;
                    if (decimals < 0) decimals = 0;

                    var floored = priceFormat.input * 1;
                    var floater = (Math.floor((priceFormat.price - floored) * Math.pow(10, decimals)) / Math.pow(10, decimals));
                    return priceFormat.output + (floater + "").slice(1) + " " + unit
                }

                TextFormater {
                    id: priceFormat
                    delimiter: ","
                    count: 3
                    input: Math.floor(price)

                    readonly property real price: (slider.price * dis.maximum / slider.goldMaximum)
                }
            }
        }

        Slider {
            id: slider
            Layout.fillWidth: true
            stepSize: 1
            from: 1
            to: middleMode? 140 : 70
            value: middleMode? 70 : 1

            readonly property real goldMaximum: 10000000
            readonly property double price: {
                var mid = middleMode? to / 2 : 0;
                var val = Math.abs(value - mid);
                for (var i=0; i<10; i++)
                    if (val <= 10*(i+1)) {
                        var res = (val - 10*i) * Math.pow(10, i);
                        if (res == 0)
                            return baseValue;
                        else
                        if (value >= mid)
                            return baseValue + res;
                        else
                            return baseValue - (res * baseValue / goldMaximum);
                    }

            }
        }
    }
}
