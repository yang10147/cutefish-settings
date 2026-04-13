import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Touchpad")

    Touchpad {
        id: touchpad
        Component.onCompleted: accelSpeedSlider.load()
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            RoundedItem {
                GridLayout {
                    columns: 2
                    rowSpacing: Theme.largeSpacing * 2

                    Label {
                        text: qsTr("Enable")
                        Layout.fillWidth: true
                    }

                    Switch {
                        id: _enableSwitch
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        rightPadding: 0
                        Component.onCompleted: checked = touchpad.enabled
                        onCheckedChanged: touchpad.enabled = checked
                    }

                    Label {
                        visible: _enableSwitch.checked
                        text: qsTr("Tap to click")
                        Layout.fillWidth: true
                    }

                    Switch {
                        visible: _enableSwitch.checked
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        rightPadding: 0
                        Component.onCompleted: checked = touchpad.tapToClick
                        onCheckedChanged: touchpad.tapToClick = checked
                    }

                    Label {
                        visible: _enableSwitch.checked
                        text: qsTr("Natural scrolling")
                        Layout.fillWidth: true
                    }

                    Switch {
                        visible: _enableSwitch.checked
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        rightPadding: 0
                        Component.onCompleted: checked = touchpad.naturalScroll
                        onCheckedChanged: touchpad.naturalScroll = checked
                    }

                    Label {
                        visible: _enableSwitch.checked
                        text: qsTr("Pointer acceleration")
                    }

                    Slider {
                        id: accelSpeedSlider
                        visible: _enableSwitch.checked
                        Layout.fillWidth: true
                        from: 1
                        to: 11
                        stepSize: 1

                        property int accelSpeedValue: 0

                        function load() {
                            accelSpeedValue = Math.round(touchpad.pointerAcceleration * 100)
                            value = Math.round(6 + touchpad.pointerAcceleration / 0.2)
                        }

                        function onAccelSpeedChanged(val) {
                            if (val !== accelSpeedValue) {
                                accelSpeedValue = val
                                value = Math.round(6 + (val / 100) / 0.2)
                            }
                            if ((val / 100) !== touchpad.pointerAcceleration)
                                touchpad.pointerAcceleration = val / 100
                        }

                        onMoved: {
                            if (touchpad !== undefined) {
                                accelSpeedValue = Math.round(((value - 6) * 0.2) * 100)
                                onAccelSpeedChanged(accelSpeedValue)
                            }
                        }
                    }
                }
            }

            Item {
                height: Theme.smallSpacing
            }
        }
    }
}
