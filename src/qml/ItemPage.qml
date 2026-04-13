import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: page

    property string headerTitle

    background: Rectangle {
        color: Theme.backgroundColor
    }

    header: Item {
        height: 40

        Label {
            anchors.left: parent.left
            leftPadding: Theme.largeSpacing * 3
            rightPadding: Qt.application.layoutDirection === Qt.RightToLeft ? Theme.largeSpacing * 3 : 0
            topPadding: Theme.largeSpacing
            bottomPadding: 0
            font.pointSize: 12
            text: page.headerTitle
            color: rootWindow.active ? Theme.textColor : Theme.disabledTextColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
