/*
 * Copyright (C) 2021 CutefishOS Team.
 * Author: revenmartin <revenmartin@gmail.com>
 */

import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import Cutefish.Settings 1.0
import Cutefish.Accounts 1.0

import "../"

RoundedItem {
    id: control

    height: mainLayout.implicitHeight + Theme.largeSpacing * 2

    UserAccount {
        id: currentUser
        userId: model.userId
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["Image files (*.jpg *.png)", "All files (*)"]
        onAccepted: {
            let path = fileDialog.selectedFile.toString().replace("file://", "").replace("localhost", "");
            currentUser.iconFileName = path;
            _userImage.source = fileDialog.selectedFile;
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: Theme.largeSpacing
        spacing: 0

        RowLayout {
            id: _topLayout
            Layout.fillWidth: true
            spacing: Theme.largeSpacing

            Image {
                id: _userImage
                property int iconSize: 48
                Layout.preferredWidth: iconSize
                Layout.preferredHeight: iconSize
                sourceSize: Qt.size(iconSize, iconSize)
                source: iconFileName ? (iconFileName.startsWith("/") ? "file://" + iconFileName : "file:///" + iconFileName) : "image://icontheme/default-user"
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: fileDialog.open()
                    cursorShape: Qt.PointingHandCursor
                }

                layer.enabled: true
                layer.effect: MultiEffect {
                    source: _userImage
                    maskEnabled: true
                    maskSource: ShaderEffectSource {
                        sourceItem: Rectangle {
                            width: _userImage.width
                            height: _userImage.height
                            radius: width / 2
                            visible: false
                        }
                    }
                }
            }

            Label {
                font.pixelSize: 15
                font.bold: true
                text: userName
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                text: realName
                color: Theme.disabledTextColor
                visible: realName !== userName && realName !== ""
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Label {
                text: qsTr("Currently logged")
                visible: currentUser.userId === loggedUser.userId
                Layout.alignment: Qt.AlignVCenter
            }

            RoundButton {
                icon.width: 16
                icon.height: 16
                icon.source: Theme.darkMode ? (additionalSettings.shown ? "qrc:/images/dark/up.svg" : "qrc:/images/dark/down.svg")
                                           : (additionalSettings.shown ? "qrc:/images/light/up.svg" : "qrc:/images/light/down.svg")
                onClicked: additionalSettings.toggle()
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Hideable {
            id: additionalSettings
            Layout.fillWidth: true
            shown: false

            ColumnLayout {
                width: parent.width
                spacing: Theme.largeSpacing

                Item { height: Theme.smallSpacing }

                GridLayout {
                    columns: 2
                    Layout.fillWidth: true
                    rowSpacing: Theme.mediumSpacing

                    Label { text: qsTr("Account type") }
                    Label { 
                        text: currentUser.accountType === 0 ? qsTr("Standard") : qsTr("Administrator")
                        Layout.alignment: Qt.AlignRight
                    }

                    Label { text: qsTr("Automatic login") }
                    Switch {
                        checked: currentUser.automaticLogin
                        onCheckedChanged: currentUser.automaticLogin = checked
                        Layout.alignment: Qt.AlignRight
                    }
                }

                HorizontalDivider { visible: changePasswdLayout.visible }

                ColumnLayout {
                    id: changePasswdLayout
                    visible: false
                    Layout.fillWidth: true
                    spacing: Theme.smallSpacing

                    TextField {
                        id: passwordField
                        placeholderText: qsTr("New Password")
                        echoMode: TextField.Password
                        Layout.fillWidth: true
                    }

                    TextField {
                        id: verifyPasswordField
                        placeholderText: qsTr("Verify Password")
                        echoMode: TextField.Password
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        Button {
                            text: qsTr("Cancel")
                            onClicked: control.hideChangePasswordItem()
                            Layout.fillWidth: true
                        }
                        Button {
                            text: qsTr("Apply")
                            enabled: passwordField.text !== "" && passwordField.text === verifyPasswordField.text
                            onClicked: {
                                currentUser.setPassword(passwordField.text)
                                control.hideChangePasswordItem()
                            }
                            Layout.fillWidth: true
                        }
                    }
                }

                StandardButton {
                    text: qsTr("Change Password")
                    visible: !changePasswdLayout.visible
                    onClicked: changePasswdLayout.visible = true
                    Layout.fillWidth: true
                }

                StandardButton {
                    text: qsTr("Delete User")
                    enabled: model.userId !== loggedUser.userId
                    onClicked: accountsManager.deleteUser(model.userId, true)
                    Layout.fillWidth: true
                }
            }
        }
    }

    function hideChangePasswordItem() {
        passwordField.clear()
        verifyPasswordField.clear()
        changePasswdLayout.visible = false
    }
}
