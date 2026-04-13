/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * Author:     revenmartin <revenmartin@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.private.volume
import "../"

ItemPage {
    headerTitle: qsTr("Sound")

    function audioIcon(value) {
        if (value <= 0)
            return "audio-volume-muted-symbolic"
        else if (value <= 25)
            return "audio-volume-low-symbolic"
        else if (value <= 75)
            return "audio-volume-medium-symbolic"
        else
            return "audio-volume-high-symbolic"
    }

    function microphoneIcon(value) {
        if (value <= 25)
            return "audio-input-microphone-low-symbolic"
        else if (value <= 70)
            return "audio-input-microphone-medium-symbolic"
        else
            return "audio-input-microphone-high-symbolic"
    }

    SinkModel {
        id: paSinkModel
    }

    SourceModel {
        id: paSourceModel
    }

    PulseObjectFilterModel {
        id: paSinkFilterModel
        filterOutInactiveDevices: true
        sourceModel: paSinkModel
    }

    PulseObjectFilterModel {
        id: paSourceFilterModel
        filterOutInactiveDevices: true
        sourceModel: paSourceModel
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            Label {
                text: qsTr("Output Devices")
                leftPadding: Theme.largeSpacing
                bottomPadding: Theme.smallSpacing
                color: Theme.disabledTextColor
                visible: sinks.count >= 1
            }

            // Playback Devices
            ListView {
                id: sinks
                Layout.fillWidth: true
                interactive: false
                spacing: Theme.largeSpacing

                Layout.preferredHeight: {
                    var totalHeight = 0
                    for (var i = 0; i < sinks.visibleChildren.length; ++i) {
                        totalHeight += sinks.visibleChildren[i].height
                    }
                    return totalHeight
                }

                model: paSinkFilterModel

                delegate: Item {
                    width: ListView.view.width
                    height: _itemLayout.implicitHeight + Theme.largeSpacing * 2

                    readonly property var currentPort: Ports[ActivePortIndex]

                    Rectangle {
                        anchors.fill: parent
                        color: Theme.secondBackgroundColor
                        radius: Theme.bigRadius
                    }

                    ColumnLayout {
                        id: _itemLayout
                        anchors.fill: parent
                        anchors.margins: Theme.largeSpacing
                        spacing: Theme.largeSpacing

                        Label {
                            text: !currentPort ? Description : currentPort.description
                        }

                        RowLayout {
                            spacing: Theme.largeSpacing

                            Image {
                                Layout.leftMargin: 2
                                height: 16
                                width: height
                                sourceSize: Qt.size(width, height)
                                source: "qrc:/images/" + (Theme.darkMode ? "dark" : "light") + "/" + audioIcon(slider.value / slider.to * 100) + ".svg"
                                smooth: false
                                antialiasing: true
                            }

                            Slider {
                                id: slider
                                Layout.fillWidth: true
                                value: Volume
                                from: 0
                                to: 65536
                                enabled: VolumeWritable
                                visible: hasVolume

                                ToolTip {
                                    parent: slider.handle
                                    visible: slider.pressed
                                    text: (slider.value / slider.to * 100).toFixed(0)
                                }

                                onMoved: {
                                    Volume = value
                                    Muted = (value === 0)
                                }
                            }
                        }
                    }
                }
            }

            Item {
                height: Theme.largeSpacing * 2
            }

            Label {
                text: qsTr("Input Devices")
                leftPadding: Theme.largeSpacing
                bottomPadding: Theme.smallSpacing
                color: Theme.disabledTextColor
                visible: sinkInputView.count >= 1
            }

            // Recording Devices
            ListView {
                id: sinkInputView
                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight

                interactive: false
                spacing: Theme.largeSpacing
                model: paSourceFilterModel

                delegate: Item {
                    width: ListView.view.width
                    height: _layout.implicitHeight + Theme.largeSpacing * 2

                    readonly property var currentPort: Ports[ActivePortIndex]

                    Rectangle {
                        anchors.fill: parent
                        color: Theme.secondBackgroundColor
                        radius: Theme.bigRadius
                    }

                    ColumnLayout {
                        id: _layout
                        anchors.fill: parent
                        anchors.margins: Theme.largeSpacing
                        spacing: Theme.largeSpacing

                        Label {
                            text: !currentPort ? Description : currentPort.description
                        }

                        RowLayout {
                            spacing: Theme.largeSpacing

                            Image {
                                Layout.leftMargin: 2
                                height: 16
                                width: height
                                sourceSize: Qt.size(width, height)
                                source: "qrc:/images/" + (Theme.darkMode ? "dark" : "light") + "/" + microphoneIcon(_slider.value / _slider.to * 100) + ".svg"
                                smooth: false
                                antialiasing: true
                            }

                            Slider {
                                id: _slider
                                Layout.fillWidth: true
                                value: Volume
                                from: 0
                                to: 65536
                                enabled: VolumeWritable
                                visible: hasVolume

                                onMoved: {
                                    Volume = value
                                    Muted = (value === 0)
                                }

                                ToolTip {
                                    parent: _slider.handle
                                    visible: _slider.pressed
                                    text: (_slider.value / _slider.to * 100).toFixed(0)
                                }
                            }
                        }
                    }
                }
            }

            Item {
                height: Theme.largeSpacing * 2
            }
        }
    }
}
