import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models
import Cutefish.Settings 1.0
import "../"

ItemPage {
    id: control
    headerTitle: qsTr("Power")

    PowerManager {
        id: power
    }

    Battery {
        id: battery
    }

    function timeoutToIndex(timeout) {
        switch (timeout) {
        case 2 * 60:   return 0
        case 5 * 60:   return 1
        case 10 * 60:  return 2
        case 15 * 60:  return 3
        case 30 * 60:  return 4
        case -1:       return 5
        }
        return 0
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: Theme.largeSpacing

            RoundedItem {
                Label {
                    text: qsTr("Mode")
                    color: Theme.disabledTextColor
                }

                RowLayout {
                    spacing: Theme.largeSpacing * 2

                    IconCheckBox {
                        source: "qrc:/images/powersave.svg"
                        text: qsTr("Power Save")
                        checked: power.mode === 0
                        onClicked: power.mode = 0
                    }

                    IconCheckBox {
                        source: "qrc:/images/performance.svg"
                        text: qsTr("Performance")
                        checked: power.mode === 1
                        onClicked: power.mode = 1
                    }
                }
            }

            Label {
                color: Theme.disabledTextColor
                leftPadding: Theme.largeSpacing * 2
                rightPadding: Theme.largeSpacing
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Performance mode: CPU and GPU frequencies will be increased, while power consumption and heat generation will be increased.")
            }

            RoundedItem {
                Layout.topMargin: Theme.largeSpacing

                GridLayout {
                    columns: 2
                    rowSpacing: Theme.largeSpacing * 2
                    Layout.bottomMargin: Theme.largeSpacing

                    Label {
                        text: qsTr("Turn off screen")
                        Layout.fillWidth: true
                    }

                    ComboBox {
                        Layout.preferredWidth: 160

                        model: ListModel {
                            ListElement { text: qsTr("2 Minutes") }
                            ListElement { text: qsTr("5 Minutes") }
                            ListElement { text: qsTr("10 Minutes") }
                            ListElement { text: qsTr("15 Minutes") }
                            ListElement { text: qsTr("30 Minutes") }
                            ListElement { text: qsTr("Never") }
                        }

                        currentIndex: timeoutToIndex(power.idleTime)

                        onActivated: {
                            switch (currentIndex) {
                            case 0: power.idleTime = 2 * 60;  break
                            case 1: power.idleTime = 5 * 60;  break
                            case 2: power.idleTime = 10 * 60; break
                            case 3: power.idleTime = 15 * 60; break
                            case 4: power.idleTime = 30 * 60; break
                            case 5: power.idleTime = -1;       break
                            }
                        }
                    }

                    Label {
                        text: qsTr("Hibernate after screen is turned off")
                        Layout.fillWidth: true
                    }

                    Switch {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        checked: power.sleepWhenClosedScreen
                        onClicked: power.sleepWhenClosedScreen = checked
                    }

                    Label {
                        text: qsTr("Lock screen after screen is turned off")
                        Layout.fillWidth: true
                    }

                    Switch {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        checked: power.lockWhenClosedScreen
                        onClicked: power.lockWhenClosedScreen = checked
                    }
                }
            }

            Item {
                height: Theme.largeSpacing * 2
            }
        }
    }
}
