import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.NetworkManagement 1.0 as NM
import "../"

Dialog {
    id: control
    modal: true
    x: parent ? (parent.width - width) / 2 : 0
    y: parent ? (parent.height - height) / 2 : 0
    title: qsTr("Enter Password")

    signal connect(var devicePath, var specificPath, var password)

    property var name: ""
    property var devicePath: ""
    property var specificPath: ""
    property var securityType: ""

    function show() { open() }

    onOpened: {
        passwordField.clear()
        passwordField.forceActiveFocus()
    }

    ColumnLayout {
        id: _mainLayout
        spacing: Theme.largeSpacing

        Label {
            text: qsTr("Enter the password for %1").arg(control.name)
            color: Theme.disabledTextColor
            wrapMode: Text.WordWrap
        }

        TextField {
            id: passwordField
            focus: true
            echoMode: TextInput.Password
            selectByMouse: true
            placeholderText: qsTr("Password")

            validator: RegularExpressionValidator {
                regularExpression: {
                    if (control.securityType === NM.Enums.StaticWep)
                        return /^(?:[\x20-\x7F]{5}|[0-9a-fA-F]{10}|[\x20-\x7F]{13}|[0-9a-fA-F]{26}){1}$/
                    return /^(?:[\x20-\x7F]{8,64}){1}$/
                }
            }

            onAccepted: control.emitSignal()
            Keys.onEscapePressed: control.close()
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: Theme.largeSpacing

            Button {
                text: qsTr("Cancel")
                Layout.fillWidth: true
                onClicked: control.close()
            }

            Button {
                text: qsTr("Connect")
                flat: true
                Layout.fillWidth: true
                enabled: passwordField.acceptableInput
                onClicked: control.emitSignal()
            }
        }
    }

    function emitSignal() {
        control.connect(control.devicePath, control.specificPath, passwordField.text)
        control.close()
    }
}
