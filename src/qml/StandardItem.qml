import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: control

    height: mainLayout.implicitHeight + Theme.smallRadius * 2

    property alias key: keyLabel.text
    property alias value: valueLabel.text

    Layout.fillWidth: true

    RowLayout {
        id: mainLayout
        anchors.fill: parent

        Label {
            id: keyLabel
            color: Theme.textColor
        }

        Item { Layout.fillWidth: true }

        Label {
            id: valueLabel
            color: Theme.disabledTextColor
        }
    }
}
