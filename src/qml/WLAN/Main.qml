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

import Cutefish.NetworkManagement 1.0 as NM

import "../"

ItemPage {
    id: control
    headerTitle: qsTr("WLAN")

    property var itemHeight: 45
    property var settingsMap: ({})

    NM.Handler {
        id: handler
    }

    NM.WifiSettings {
        id: wifiSettings
    }

    NM.NetworkModel {
        id: networkModel
    }

    NM.EnabledConnections {
        id: enabledConnections
    }

    NM.IdentityModel {
        id: connectionModel
    }

    NM.Configuration {
        id: configuration
    }

    NewNetworkDialog {
        id: newNetworkDialog

        onConnect: {
            wifiSettings.addOtherConnection(ssid, username, pwd, type)
        }
    }

    Timer {
        interval: 10200
        repeat: true
        running: control.visible
        triggeredOnStart: true
        onTriggered: handler.requestScan()
    }

    Timer {
        id: scanTimer
        interval: 10200
        repeat: true
        running: control.visible
        onTriggered: handler.requestScan()
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: mainLayout.implicitHeight
        visible: enabledConnections.wirelessHwEnabled

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.bottomMargin: Theme.largeSpacing
            spacing: Theme.largeSpacing * 2

            RoundedItem {
                WifiView {
                    Layout.fillWidth: true
                    visible: enabledConnections.wirelessHwEnabled
                }
            }

            StandardButton {
                Layout.fillWidth: true
                text: qsTr("Add other...")
                onClicked: newNetworkDialog.show()
            }

            // Hotspot
            // 还未完善
//            RoundedItem {
//                id: hotspotItem
//                visible: handler.hotspotSupported

//                RowLayout {
//                    Label {
//                        text: qsTr("Hotspot")
//                        color: Theme.disabledTextColor
//                    }

//                    Item {
//                        Layout.fillWidth: true
//                    }

//                    Switch {
//                        Layout.fillHeight: true
//                        rightPadding: 0

//                        onToggled: {
//                            if (checked) {
//                                handler.createHotspot()
//                            } else {
//                                handler.stopHotspot()
//                            }
//                        }
//                    }
//                }

//                Item {
//                    height: Theme.largeSpacing
//                }

//                TextField {
//                    id: ssidName
//                    text: configuration.hotspotName
//                    placeholderText: qsTr("SSID")
//                }

//                TextField {
//                    id: hotspotPassword
//                    placeholderText: qsTr("Password")
//                    text: configuration.hotspotPassword
//                }
//            }

            Item {
                height: Theme.largeSpacing
            }
        }
    }
}
