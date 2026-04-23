import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"

Dialog {
    id: control
    modal: true
    x: parent ? (parent.width - width) / 2 : 0
    y: parent ? (parent.height - height) / 2 : 0
    title: qsTr("Bluetooth Pairing Request")

    property var pin: ""

    function show() { open() }

    ColumnLayout {
        id: mainLayout
        spacing: Theme.largeSpacing

        Label {
            text: qsTr("Bluetooth Pairing Request")
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "<b>%1</b>".arg(control.pin)
            visible: control.pin !== ""
            font.pointSize: 16
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: Theme.largeSpacing
        }

        RowLayout {
            spacing: Theme.largeSpacing

            Button {
                text: qsTr("Cancel")
                Layout.fillWidth: true
                onClicked: {
                    control.close()
                    bluetoothMgr.confirmMatchButton(false)
                }
            }

            Button {
                text: qsTr("OK")
                Layout.fillWidth: true
                flat: true
                onClicked: {
                    control.close()
                    bluetoothMgr.confirmMatchButton(true)
                }
            }
        }
    }
}
