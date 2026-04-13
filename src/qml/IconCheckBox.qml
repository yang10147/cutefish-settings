import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: control
    property var iconSpacing: Theme.smallSpacing * 0.8
    property alias source: icon.source
    property alias text: label.text
    property bool checked: false
    property var iconSize: 96
    signal clicked

    implicitHeight: mainLayout.implicitHeight
    implicitWidth: mainLayout.implicitWidth
    scale: 1.0

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        Rectangle {
            id: _box
            width: control.iconSize
            height: width
            color: "transparent"
            border.width: 3
            border.color: control.checked ? Theme.highlightColor : "transparent"
            radius: Theme.bigRadius + control.iconSpacing

            Image {
                id: icon
                anchors.fill: parent
                anchors.margins: Theme.smallSpacing
                sourceSize: Qt.size(icon.width, icon.height)
                opacity: 1
                smooth: false
                layer.enabled: true

                // 去掉Behavior on opacity（Easing在此上下文不可用）
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: icon.opacity = 0.8
                    onExited:  icon.opacity = 1.0
                }
            }

            MultiEffect {
                anchors.fill: icon
                source: icon
                maskEnabled: true
                maskSource: Rectangle {
                    width: icon.width
                    height: icon.height
                    radius: Theme.bigRadius
                    visible: false
                }
            }
        }

        Label {
            id: label
            color: control.checked ? Theme.highlightColor : Theme.textColor
            visible: label.text !== ""
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutSine }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: control.clicked()
        onPressedChanged: control.scale = pressed ? 0.95 : 1.0
    }
}
