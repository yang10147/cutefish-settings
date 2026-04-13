import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Date & Time")

    SystemPalette { id: disabledPalette; colorGroup: SystemPalette.Disabled }

    TimeZoneDialog { id: timeZoneDialog }
    TimeZoneMap { id: timeZoneMap }
    Time { id: time }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 24

            RoundedItem {
                spacing: 18

                RowLayout {
                    Label { text: qsTr("Auto Sync") }
                    Item { Layout.fillWidth: true }
                    Switch {
                        Layout.fillHeight: true
                        rightPadding: 0; rightInset: 0
                        checkable: time.canNTP
                        checked: time.useNtp
                        onCheckedChanged: time.useNtp = checked
                    }
                }

                Label {
                    text: qsTr("Unable to use Auto Sync. Please ensure your NTP service is installed.")
                    color: disabledPalette.text
                    visible: !time.canNTP
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }

            RoundedItem {
                spacing: 18
                RowLayout {
                    Label { text: qsTr("24-Hour Time") }
                    Item { Layout.fillWidth: true }
                    Switch {
                        Layout.fillHeight: true
                        rightPadding: 0; rightInset: 0
                        checked: time.twentyFour
                        onCheckedChanged: time.twentyFour = checked
                    }
                }
            }

            StandardButton {
                Layout.fillWidth: true
                text: ""
                onClicked: timeZoneDialog.show()

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 18
                    Label { text: qsTr("Time Zone") }
                    Item { Layout.fillWidth: true }
                    Label { text: timeZoneMap.currentTimeZone }
                }
            }
        }
    }
}
