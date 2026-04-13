import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Appearance")

    SystemPalette { id: palette }
    SystemPalette { id: disabledPalette; colorGroup: SystemPalette.Disabled }

    Appearance { id: appearance }

    // 用 JS 数组替代 ListModel，避免自定义组件内 ListModel is not a type
    readonly property var accentColorList: [
        "#4D94FF", "#FF5C5C", "#4CAF50", "#9C27B0",
        "#FF69B4", "#FF9800", "#9E9E9E"
    ]

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 24

            RoundedItem {
                Label { text: qsTr("Theme"); color: disabledPalette.text }

                RowLayout {
                    spacing: 24
                    IconCheckBox {
                        source: "qrc:/images/light_mode.svg"
                        text: qsTr("Light")
                        checked: !appearance.darkMode
                        onClicked: appearance.switchDarkMode(false)
                    }
                    IconCheckBox {
                        source: "qrc:/images/dark_mode.svg"
                        text: qsTr("Dark")
                        checked: appearance.darkMode
                        onClicked: appearance.switchDarkMode(true)
                    }
                }

                HorizontalDivider {}

                RowLayout {
                    spacing: 12
                    Label {
                        id: dimsTipsLabel
                        text: qsTr("Dim the wallpaper in dark theme")
                        bottomPadding: 6
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    }
                    Item { Layout.fillWidth: true }
                    Switch {
                        checked: appearance.dimsWallpaper
                        height: dimsTipsLabel.height
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                        onCheckedChanged: appearance.setDimsWallpaper(checked)
                        rightPadding: 0
                    }
                }

                RowLayout {
                    Label {
                        text: qsTr("System effects")
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    }
                    Item { Layout.fillWidth: true }
                    Switch {
                        checked: appearance.systemEffects
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                        onCheckedChanged: appearance.systemEffects = checked
                        rightPadding: 0
                    }
                }
            }

            RoundedItem {
                RowLayout {
                    spacing: 24
                    Label { text: qsTr("Minimize animation") }
                    TabBar {
                        Layout.fillWidth: true
                        currentIndex: appearance.minimiumAnimation
                        onCurrentIndexChanged: appearance.minimiumAnimation = currentIndex
                        TabButton { text: qsTr("Default") }
                        TabButton { text: qsTr("Magic Lamp") }
                    }
                }
            }

            RoundedItem {
                Label { text: qsTr("Accent color"); color: disabledPalette.text }

                GridView {
                    id: accentColorView
                    property int itemSize: 54
                    height: itemSize
                    Layout.fillWidth: true
                    cellWidth: itemSize
                    cellHeight: itemSize
                    interactive: false
                    model: accentColorList

                    delegate: Item {
                        property bool checked: Qt.colorEqual(palette.highlight, modelData)
                        property color currentColor: modelData
                        width: GridView.view.itemSize
                        height: width

                        MouseArea {
                            id: _mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: appearance.setAccentColor(index)
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 6
                            color: "transparent"
                            radius: width / 2
                            border.color: _mouseArea.pressed
                                ? Qt.rgba(currentColor.r, currentColor.g, currentColor.b, 0.6)
                                : Qt.rgba(currentColor.r, currentColor.g, currentColor.b, 0.4)
                            border.width: checked || _mouseArea.containsMouse ? 3 : 0

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 6
                                color: currentColor
                                radius: width / 2
                                Image {
                                    anchors.centerIn: parent
                                    width: parent.height * 0.6; height: width
                                    sourceSize: Qt.size(width, height)
                                    source: "qrc:/images/dark/checked.svg"
                                    visible: checked
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
