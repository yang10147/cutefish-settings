import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: control

    property alias source: image.source
    signal clicked()

    width: 22
    height: width

    Image {
        id: image
        anchors.fill: parent
        sourceSize: Qt.size(control.width, control.height)
        smooth: false
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: control.clicked()
    }

    // Qt6: MultiEffect 替代 ColorOverlay
    MultiEffect {
        anchors.fill: image
        source: image
        colorization: 1.0
        colorizationColor: "white"
        opacity: 0.5
        visible: mouseArea.containsPress
    }
}
