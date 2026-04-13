import QtQuick
import QtQuick.Controls

Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    clip: true

    topMargin: Theme.largeSpacing
    leftMargin: Theme.largeSpacing * 2
    rightMargin: Theme.largeSpacing * 2

    contentWidth: width - (leftMargin + rightMargin)

    WheelHandler {
        id: wheelHandler
        target: root
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    ScrollBar.vertical: ScrollBar {
        bottomPadding: Theme.smallRadius
    }
}
