/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: control
    width: 900
    height: 600
    minimumWidth: 800
    minimumHeight: 500
    visible: false
    flags: Qt.Dialog | Qt.WindowTitleHint | Qt.WindowCloseButtonHint

    title: qsTr("Time Zone")

    SystemPalette { id: palette }

    onWidthChanged: control.reset()
    onHeightChanged: control.reset()

    function reset() {
        dot.visible = false
        popupItem.visible = false
    }

    onVisibleChanged: {
        if (!visible)
            control.reset()
    }

    Connections {
        target: timeZoneMap

        function onAvailableListChanged() {
            popupText.text = timeZoneMap.localeTimeZoneName(timeZoneMap.availableList[0])
            popupItem.visible = true
        }
    }

    // 拖动支持
    Item {
        z: -1
        anchors.fill: parent

        DragHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            grabPermissions: PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
            onActiveChanged: if (active) control.startSystemMove()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12

        Image {
            id: _worldMap
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: palette.window.hslLightness < 0.5
                    ? "qrc:/images/dark/world.svg"
                    : "qrc:/images/light/world.svg"
            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit

            Rectangle {
                id: dot
                width: 20
                height: 20
                radius: height / 2
                color: palette.highlight
                z: 99
                visible: false
                border.width: 5
                border.color: Qt.rgba(palette.highlight.r,
                                      palette.highlight.g,
                                      palette.highlight.b, 0.5)

                function show(x, y) {
                    dot.x = x - dot.width / 2
                    dot.y = y - dot.height / 2
                    dot.visible = true
                }
            }

            Item {
                id: popupItem
                visible: popupText.text !== ""
                width: popupText.implicitWidth + 12
                height: popupText.implicitHeight + 12

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: palette.highlight
                }

                Label {
                    id: popupText
                    anchors.centerIn: parent
                    text: (timeZoneMap.availableList && timeZoneMap.availableList[0])
                          ? timeZoneMap.availableList[0] : ""
                    color: palette.highlightedText
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: (mouse) => {
                    timeZoneMap.clicked(mouse.x, mouse.y, _worldMap.width, _worldMap.height)
                    dot.show(mouse.x, mouse.y)

                    popupItem.x = mouse.x + 6
                    popupItem.y = mouse.y + 6

                    if (popupItem.x + popupItem.width >= _worldMap.width)
                        popupItem.x = _worldMap.width - popupItem.width - 2

                    if (popupItem.y + popupItem.height >= _worldMap.height)
                        popupItem.y = _worldMap.height - popupItem.height - 2

                    popupItem.visible = true
                }
            }
        }

        RowLayout {
            spacing: 12

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Cancel")
                onClicked: control.close()
            }

            Button {
                text: qsTr("Set")
                highlighted: true
                enabled: popupText.text !== ""
                onClicked: {
                    timeZoneMap.setTimeZone(timeZoneMap.availableList[0])
                    control.close()
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
