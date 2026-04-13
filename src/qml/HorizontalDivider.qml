import QtQuick
import QtQuick.Layouts

Item {
    id: control
    height: Theme.largeSpacing * 2

    Layout.fillWidth: true

    Rectangle {
        anchors.centerIn: parent
        height: 1
        width: control.width
        color: Theme.disabledTextColor
        opacity: Theme.darkMode ? 0.3 : 0.1
    }
}
