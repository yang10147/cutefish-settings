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

    signal connect(var ssid, var username, var pwd, var type)

    function show() { open() }

    onOpened: {
        _userNameTextField.forceActiveFocus()
    }
    onClosed: {
        _nameTextField.clear()
        _userNameTextField.clear()
        _passwordTextField.clear()
        securitybox.currentIndex = 2
    }

    ColumnLayout {
        id: _mainLayout
        spacing: Theme.largeSpacing

        GridLayout {
            columns: 2
            columnSpacing: Theme.largeSpacing * 2
            rowSpacing: Theme.largeSpacing

            Label { text: qsTr("Name") }
            TextField {
                id: _nameTextField
                placeholderText: qsTr("Network Name")
                Layout.fillWidth: true
                Keys.onEscapePressed: control.close()
            }

            Label { text: qsTr("Security") }
            ComboBox {
                id: securitybox
                Layout.fillWidth: true
                currentIndex: 2
                model: [ qsTr("None"), "WEP", "WPA/WPA2", "WPA3" ]
            }

            Label {
                visible: securitybox.currentIndex === 1
                text: qsTr("UserName")
            }
            TextField {
                id: _userNameTextField
                visible: securitybox.currentIndex === 1
                placeholderText: qsTr("Username")
                focus: true
                Layout.fillWidth: true
                Keys.onEscapePressed: control.close()
            }

            Label {
                visible: securitybox.currentIndex !== 0
                text: qsTr("Password")
            }
            TextField {
                id: _passwordTextField
                visible: securitybox.currentIndex !== 0
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                Layout.fillWidth: true
                Keys.onEscapePressed: control.close()
            }
        }

        RowLayout {
            spacing: Theme.largeSpacing

            Button {
                text: qsTr("Cancel")
                Layout.fillWidth: true
                onClicked: control.close()
            }

            Button {
                enabled: _nameTextField.text !== ""
                         && (_passwordTextField.text.length > 7 || securitybox.currentIndex === 0)
                flat: true
                text: qsTr("Join")
                Layout.fillWidth: true
                onClicked: {
                    var security_type = securitybox.currentText
                    control.connect(_nameTextField.text,
                                    _userNameTextField.text,
                                    _passwordTextField.text,
                                    security_type)
                    control.close()
                }
            }
        }
    }
}
