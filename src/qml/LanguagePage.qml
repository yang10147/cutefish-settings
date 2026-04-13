import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0 as Settings

ItemPage {
    headerTitle: qsTr("Language")

    SystemPalette { id: palette }
    SystemPalette { id: disabledPalette; colorGroup: SystemPalette.Disabled }

    Settings.Language {
        id: language
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 6

        ListView {
            id: listView

            WheelHandler {
                target: listView
            }

            Layout.fillWidth: true
            Layout.fillHeight: true
            model: language.languages
            clip: true
            topMargin: 12
            leftMargin: 24
            rightMargin: 24
            bottomMargin: 12
            spacing: 12
            currentIndex: language.currentLanguage

            ScrollBar.vertical: ScrollBar {}

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration: 0

            highlight: Rectangle {
                color: palette.highlight
                radius: 4
            }

            delegate: MouseArea {
                property bool isSelected: index === listView.currentIndex
                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: 36
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton

                onClicked: language.setCurrentLanguage(index)

                Rectangle {
                    anchors.fill: parent
                    color: item.containsMouse && !isSelected ? disabledPalette.text : "transparent"
                    opacity: 0.1
                    radius: 4
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 6
                    anchors.rightMargin: 12

                    Label {
                        color: isSelected ? palette.highlightedText : palette.text
                        text: modelData
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    Image {
                        width: item.height * 0.45
                        height: width
                        sourceSize: Qt.size(width, height)
                        source: "qrc:/images/dark/checked.svg"
                        visible: isSelected
                        smooth: false
                    }
                }
            }
        }
    }
}
