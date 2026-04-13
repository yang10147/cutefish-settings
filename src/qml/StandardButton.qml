import QtQuick
import QtQuick.Controls

Button {
    id: control

    property color backgroundColor: Theme.darkMode ? "#363636" : "#FFFFFF"
    property color hoveredColor: Theme.darkMode ? Qt.lighter(backgroundColor, 1.3)
                                                : Qt.darker(backgroundColor, 1.1)
    property color pressedColor: Theme.darkMode ? Qt.lighter(backgroundColor, 1.1)
                                                : Qt.darker(backgroundColor, 1.2)

    background: Rectangle {
        radius: Theme.mediumRadius
        color: control.pressed ? control.pressedColor
             : control.hovered ? control.hoveredColor
             : control.backgroundColor
    }
}
