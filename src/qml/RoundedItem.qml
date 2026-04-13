import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.fillWidth: true

    default property alias content: _mainLayout.data
    property alias spacing: _mainLayout.spacing
    property alias layout: _mainLayout

    color: Theme.secondBackgroundColor
    radius: Theme.mediumRadius

    Behavior on color {
        ColorAnimation { duration: 200; easing.type: Easing.Linear }
    }

    implicitHeight: _mainLayout.implicitHeight +
                    _mainLayout.anchors.topMargin +
                    _mainLayout.anchors.bottomMargin

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.leftMargin: Theme.largeSpacing * 1.5
        anchors.rightMargin: Theme.largeSpacing * 1.5
        anchors.topMargin: Theme.largeSpacing
        anchors.bottomMargin: Theme.largeSpacing
        spacing: Theme.largeSpacing
    }
}
