import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Default Applications")

    DefaultApplications {
        id: defaultApps
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            RoundedItem {
                GridLayout {
                    columns: 2
                    columnSpacing: 24

                    Label {
                        text: qsTr("Web Browser")
                        enabled: browserComboBox.count !== 0
                    }

                    AppComboBox {
                        id: browserComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: defaultApps.browserList
                        currentIndex: defaultApps.browserIndex
                        enabled: count !== 0
                        onActivated: defaultApps.setDefaultBrowser(browserComboBox.currentIndex)
                    }

                    Label {
                        text: qsTr("File Manager")
                        enabled: fileManagerComboBox.count !== 0
                    }

                    AppComboBox {
                        id: fileManagerComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: defaultApps.fileManagerList
                        currentIndex: defaultApps.fileManagerIndex
                        enabled: count !== 0
                        onActivated: defaultApps.setDefaultFileManager(fileManagerComboBox.currentIndex)
                    }

                    Label {
                        text: qsTr("Email Client")
                        enabled: emailComboBox.count !== 0
                    }

                    AppComboBox {
                        id: emailComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: defaultApps.emailList
                        currentIndex: defaultApps.emailIndex
                        enabled: count !== 0
                        onActivated: defaultApps.setDefaultEMail(emailComboBox.currentIndex)
                    }

                    Label {
                        text: qsTr("Terminal")
                        enabled: terminalComboBox.count !== 0
                    }

                    AppComboBox {
                        id: terminalComboBox
                        Layout.fillWidth: true
                        textRole: "name"
                        model: defaultApps.terminalList
                        currentIndex: defaultApps.terminalIndex
                        enabled: count !== 0
                        onActivated: defaultApps.setDefaultTerminal(terminalComboBox.currentIndex)
                    }
                }
            }
        }
    }
}
