import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Display")

    SystemPalette { id: palette }
    SystemPalette { id: disabledPalette; colorGroup: SystemPalette.Disabled }

    Appearance { id: appearance }
    Brightness  { id: brightness }
    DisplayManager { id: display }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 24

            // 亮度
            RoundedItem {
                visible: brightness.enabled

                Label {
                    text: qsTr("Brightness")
                    color: disabledPalette.text
                }

                RowLayout {
                    spacing: 12

                    Image {
                        width: 16; height: width
                        sourceSize: Qt.size(width, height)
                        Layout.alignment: Qt.AlignVCenter
                        source: "qrc:/images/" + (palette.window.hslLightness < 0.5 ? "dark" : "light") + "/display-brightness-low-symbolic.svg"
                    }

                    Slider {
                        id: brightnessSlider
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        value: brightness.value
                        from: 1; to: 100; stepSize: 1

                        Timer {
                            id: brightnessTimer
                            interval: 100; repeat: false
                            onTriggered: brightness.setValue(brightnessSlider.value)
                        }
                        onMoved: brightnessTimer.start()

                        ToolTip {
                            parent: brightnessSlider.handle
                            visible: brightnessSlider.pressed
                            text: brightnessSlider.value.toFixed(0)
                        }
                    }

                    Image {
                        width: 16; height: width
                        sourceSize: Qt.size(width, height)
                        Layout.alignment: Qt.AlignVCenter
                        source: "qrc:/images/" + (palette.window.hslLightness < 0.5 ? "dark" : "light") + "/display-brightness-symbolic.svg"
                    }
                }
            }

            // 缩放
            RoundedItem {
                Label { text: qsTr("Scale"); color: disabledPalette.text }
                TabBar {
                    Layout.fillWidth: true
                    TabButton { text: "100%" }
                    TabButton { text: "125%" }
                    TabButton { text: "150%" }
                    TabButton { text: "175%" }
                    TabButton { text: "200%" }

                    currentIndex: {
                        if (appearance.devicePixelRatio <= 1.0)  return 0
                        if (appearance.devicePixelRatio <= 1.25) return 1
                        if (appearance.devicePixelRatio <= 1.50) return 2
                        if (appearance.devicePixelRatio <= 1.75) return 3
                        return 4
                    }
                    onCurrentIndexChanged: {
                        var values = [1.0, 1.25, 1.50, 1.75, 2.0]
                        var v = values[currentIndex]
                        if (appearance.devicePixelRatio !== v)
                            appearance.setDevicePixelRatio(v)
                    }
                }
            }

            // 分辨率
            RoundedItem {
                Label { text: qsTr("Resolution"); color: disabledPalette.text }

                RowLayout {
                    Layout.fillWidth: true

                    ComboBox {
                        id: resolutionBox
                        Layout.fillWidth: true
                        model: display.resolutions
                        enabled: !display.loading && display.resolutions.length > 0

                        // 跟随后端变化
                        Connections {
                            target: display
                            function onOutputInfoChanged() {
                                resolutionBox.currentIndex = display.currentResolutionIndex
                            }
                        }

                        onActivated: function(index) {
                            display.setResolution(index)
                        }
                    }

                    BusyIndicator {
                        visible: display.loading
                        running: display.loading
                        width: 24; height: 24
                    }
                }

                Label {
                    visible: display.outputName !== ""
                    text: qsTr("Output: %1").arg(display.outputName)
                    color: disabledPalette.text
                    font.pixelSize: 12
                }
            }

            // 旋转
            RoundedItem {
                Label { text: qsTr("Rotation"); color: disabledPalette.text }

                ComboBox {
                    id: rotationBox
                    Layout.fillWidth: true
                    model: display.rotations
                    enabled: !display.loading

                    Connections {
                        target: display
                        function onOutputInfoChanged() {
                            rotationBox.currentIndex = display.currentRotationIndex
                        }
                    }

                    onActivated: function(index) {
                        display.setRotation(index)
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
