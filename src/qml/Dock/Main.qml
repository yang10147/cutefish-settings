import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Dock")

    SystemPalette { id: disabledPalette; colorGroup: SystemPalette.Disabled }

    Appearance { id: appearance }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 24

            RoundedItem {
                Label { text: qsTr("Style"); color: disabledPalette.text }
                RowLayout {
                    spacing: 24
                    IconCheckBox {
                        source: "qrc:/images/dock_bottom.svg"
                        text: qsTr("Center")
                        checked: appearance.dockStyle === 0
                        onClicked: appearance.setDockStyle(0)
                    }
                    IconCheckBox {
                        source: "qrc:/images/dock_straight.svg"
                        text: qsTr("Full")
                        checked: appearance.dockStyle === 1
                        onClicked: appearance.setDockStyle(1)
                    }
                }
            }

            RoundedItem {
                Label { text: qsTr("Position on screen"); color: disabledPalette.text }
                RowLayout {
                    spacing: 24
                    IconCheckBox {
                        source: "qrc:/images/dock_left.svg"
                        text: qsTr("Left")
                        checked: appearance.dockDirection === 0
                        onClicked: appearance.setDockDirection(0)
                    }
                    IconCheckBox {
                        source: "qrc:/images/dock_bottom.svg"
                        text: qsTr("Bottom")
                        checked: appearance.dockDirection === 1
                        onClicked: appearance.setDockDirection(1)
                    }
                    IconCheckBox {
                        source: "qrc:/images/dock_right.svg"
                        text: qsTr("Right")
                        checked: appearance.dockDirection === 2
                        onClicked: appearance.setDockDirection(2)
                    }
                }
            }

            RoundedItem {
                Label { text: qsTr("Size"); color: disabledPalette.text }
                TabBar {
                    Layout.fillWidth: true
                    bottomPadding: 4
                    TabButton { text: qsTr("Small") }
                    TabButton { text: qsTr("Medium") }
                    TabButton { text: qsTr("Large") }
                    TabButton { text: qsTr("Huge") }

                    currentIndex: {
                        if (appearance.dockIconSize <= 45) return 0
                        else if (appearance.dockIconSize <= 53) return 1
                        else if (appearance.dockIconSize <= 63) return 2
                        else return 3
                    }
                    onCurrentIndexChanged: {
                        var sizes = [45, 53, 63, 72]
                        appearance.setDockIconSize(sizes[currentIndex])
                    }
                }
            }

            RoundedItem {
                Label { text: qsTr("Display mode"); color: disabledPalette.text }
                TabBar {
                    Layout.fillWidth: true
                    currentIndex: appearance.dockVisibility
                    onCurrentIndexChanged: appearance.setDockVisibility(currentIndex)
                    TabButton { text: qsTr("Always show") }
                    TabButton { text: qsTr("Always hide") }
                    TabButton { text: qsTr("Smart hide") }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
