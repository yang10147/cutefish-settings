/*
 * Copyright (C) 2021 CutefishOS Team.
 * Ported to org.kde.bluezqt for Qt6/Wayland.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import org.kde.bluezqt 1.0 as BluezQt
import org.kde.plasma.private.bluetooth 254.0
import "../"

ItemPage {
    id: control
    headerTitle: qsTr("Bluetooth")

    function setBluetoothEnabled(enabled) {
        BluezQt.Manager.bluetoothBlocked = !enabled
        for (var i = 0; i < BluezQt.Manager.adapters.length; ++i) {
            var adapter = BluezQt.Manager.adapters[i]
            adapter.powered = enabled
        }
    }

    DevicesProxyModel {
        id: devicesProxyModel
        sourceModel: BluezQt.DevicesModel {}
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            anchors.bottomMargin: Theme.largeSpacing

            RoundedItem {
                id: mainItem
                spacing: Theme.largeSpacing

                RowLayout {
                    Label {
                        text: qsTr("Bluetooth")
                        color: Theme.disabledTextColor
                    }

                    Item { Layout.fillWidth: true }

                    Switch {
                        id: bluetoothSwitch
                        Layout.fillHeight: true
                        rightPadding: 0
                        checked: !BluezQt.Manager.bluetoothBlocked
                        onCheckedChanged: setBluetoothEnabled(checked)
                    }
                }

                ListView {
                    id: _listView
                    visible: count > 0
                    interactive: false
                    spacing: 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentHeight

                    model: BluezQt.Manager.bluetoothOperational ? devicesProxyModel : []

                    section.property: "Section"
                    section.criteria: ViewSection.FullString
                    section.delegate: Label {
                        color: Theme.disabledTextColor
                        topPadding: Theme.largeSpacing
                        bottomPadding: Theme.largeSpacing
                        text: section === "My devices" ? qsTr("My devices")
                                                       : qsTr("Other devices")
                    }

                    delegate: Item {
                        width: ListView.view.width
                        height: _itemLayout.implicitHeight + Theme.largeSpacing

                        ColumnLayout {
                            id: _itemLayout
                            anchors.fill: parent
                            anchors.topMargin: Theme.smallSpacing
                            anchors.bottomMargin: Theme.smallSpacing
                            spacing: 0

                            Item {
                                Layout.fillWidth: true
                                height: _contentLayout.implicitHeight + Theme.largeSpacing

                                Rectangle {
                                    anchors.fill: parent
                                    radius: Theme.smallRadius
                                    color: Theme.textColor
                                    opacity: mouseArea.pressed ? 0.15
                                           : mouseArea.containsMouse ? 0.1 : 0.0
                                }

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    acceptedButtons: Qt.LeftButton
                                    onClicked: {
                                        if (model.Connected || model.Paired) {
                                            additionalSettings.toggle()
                                        } else {
                                            model.Device.connectToDevice()
                                        }
                                    }
                                }

                                RowLayout {
                                    id: _contentLayout
                                    anchors.fill: parent
                                    anchors.rightMargin: Theme.smallSpacing

                                    Image {
                                        width: 16; height: 16
                                        sourceSize: Qt.size(16, 16)
                                        source: Theme.darkMode
                                            ? "qrc:/images/sidebar/dark/bluetooth.svg"
                                            : "qrc:/images/sidebar/light/bluetooth.svg"
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Label {
                                        text: model.DeviceFullName
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Label {
                                        visible: model.Paired
                                        text: model.Connected ? qsTr("Connected")
                                                              : qsTr("Not Connected")
                                    }
                                }
                            }

                            Hideable {
                                id: additionalSettings
                                spacing: 0

                                ColumnLayout {
                                    Item { height: Theme.largeSpacing }

                                    RowLayout {
                                        spacing: Theme.largeSpacing
                                        Layout.leftMargin: Theme.smallSpacing

                                        Button {
                                            text: qsTr("Connect")
                                            visible: !model.Connected
                                            onClicked: {
                                                if (model.Paired)
                                                    model.Device.connectToDevice()
                                                else
                                                    model.Device.pair()
                                            }
                                        }

                                        Button {
                                            text: qsTr("Disconnect")
                                            visible: model.Connected
                                            onClicked: {
                                                model.Device.disconnectFromDevice()
                                                additionalSettings.hide()
                                            }
                                        }

                                        Button {
                                            text: qsTr("Forget This Device")
                                            flat: true
                                            onClicked: {
                                                var adapter = model.Device.adapter
                                                adapter.removeDevice(model.Device)
                                                additionalSettings.hide()
                                            }
                                        }
                                    }
                                }

                                HorizontalDivider {}
                            }
                        }
                    }
                }
            }

            Item { height: Theme.largeSpacing * 2 }
        }
    }
}
