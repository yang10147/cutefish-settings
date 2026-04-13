import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Notifications")

    Notifications {
        id: notifications
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            RoundedItem {
                RowLayout {
                    Label {
                        text: qsTr("Do Not Disturb")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        checked: notifications.doNotDisturb
                        Layout.fillHeight: true
                        onClicked: notifications.doNotDisturb = checked
                    }
                }
            }
        }
    }
}
