import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Background")

    SystemPalette { id: palette }

    Background { id: background }

    // 用 JS 数组替代 ListModel，避免自定义组件内 ListModel is not a type
    readonly property var colorList: [
        "#2B8ADA", "#4DA4ED", "#B7E786", "#F2BB73",
        "#EE72EB", "#F0905A", "#595959", "#000000"
    ]

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 12

            RoundedItem {
                RowLayout {
                    spacing: 24
                    Label { text: qsTr("Background type"); leftPadding: 6 }
                    TabBar {
                        Layout.fillWidth: true
                        currentIndex: background.backgroundType
                        onCurrentIndexChanged: background.backgroundType = currentIndex
                        TabButton { text: qsTr("Picture") }
                        TabButton { text: qsTr("Color") }
                    }
                }

                GridView {
                    id: _view
                    property int rowCount: Math.max(1, Math.floor(_view.width / itemWidth))
                    property int itemWidth: 180
                    property int itemHeight: 127

                    Layout.fillWidth: true
                    implicitHeight: Math.ceil(_view.count / rowCount) * cellHeight + 12
                    visible: background.backgroundType === 0
                    clip: true
                    model: background.backgrounds
                    currentIndex: -1
                    interactive: false
                    cellHeight: itemHeight
                    cellWidth: calcExtraSpacing(itemWidth, _view.width) + itemWidth

                    delegate: Item {
                        id: item
                        property bool isSelected: modelData === background.currentBackgroundPath
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        scale: 1.0

                        Behavior on scale {
                            NumberAnimation { duration: 200; easing.type: Easing.OutSine }
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 12
                            radius: 10
                            color: palette.base
                            visible: _image.status !== Image.Ready
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 32; height: width
                            sourceSize: Qt.size(width, height)
                            source: palette.window.hslLightness < 0.5
                                    ? "qrc:/images/dark/picture.svg"
                                    : "qrc:/images/light/picture.svg"
                            visible: _image.status !== Image.Ready
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 6
                            color: "transparent"
                            radius: 10
                            border.color: palette.highlight
                            border.width: _image.status === Image.Ready && isSelected ? 3 : 0
                            clip: true

                            Image {
                                id: _image
                                anchors.fill: parent
                                anchors.margins: 6
                                source: "file://" + modelData
                                sourceSize: Qt.size(width, height)
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                mipmap: true
                                cache: true
                                smooth: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton
                                hoverEnabled: true
                                onClicked: background.setBackground(modelData)
                                onEntered: _image.opacity = 0.7
                                onExited: _image.opacity = 1.0
                                onPressedChanged: item.scale = pressed ? 0.97 : 1.0
                            }
                        }
                    }

                    function calcExtraSpacing(cellSize, containerSize) {
                        var availableColumns = Math.floor(containerSize / cellSize)
                        if (availableColumns <= 0) return 0
                        return Math.floor(Math.max(containerSize - availableColumns * cellSize, 0) / availableColumns)
                    }
                }

                Item {
                    visible: background.backgroundType === 1
                    height: 6
                }

                GridView {
                    id: _colorView
                    Layout.fillWidth: true
                    visible: background.backgroundType === 1
                    property int rowCount: Math.max(1, Math.floor(width / cellWidth))
                    implicitHeight: Math.ceil(count / rowCount) * cellHeight + 12
                    cellWidth: 50
                    cellHeight: 50
                    interactive: false
                    model: colorList

                    delegate: Rectangle {
                        property bool isChecked: Qt.colorEqual(background.backgroundColor, modelData)
                        property color currentColor: modelData
                        width: 44; height: width
                        color: "transparent"
                        radius: width / 2
                        border.color: _mouseArea.pressed
                            ? Qt.rgba(currentColor.r, currentColor.g, currentColor.b, 0.6)
                            : Qt.rgba(currentColor.r, currentColor.g, currentColor.b, 0.4)
                        border.width: isChecked ? 3 : _mouseArea.containsMouse ? 2 : 0

                        MouseArea {
                            id: _mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: background.backgroundColor = modelData
                        }

                        Rectangle {
                            width: 32; height: width
                            anchors.centerIn: parent
                            color: currentColor
                            radius: width / 2
                        }
                    }
                }
            }

            Item { height: 12 }
        }
    }
}
