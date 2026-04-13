import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Cutefish.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("About")

    About {
        id: about
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            Item {
                height: Theme.largeSpacing
            }

            Image {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                width: 140
                height: 72
                sourceSize: Qt.size(width, height)
                source: "qrc:/images/logo.svg"
            }

            Item {
                height: Theme.smallSpacing
            }

            Label {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                text: "<b>Openfish</b>"
                visible: !about.isCutefishOS
                font.pointSize: 22
                color: "#3385FF"
                leftPadding: Theme.largeSpacing * 2
                rightPadding: Theme.largeSpacing * 2
            }

            Image {
                Layout.preferredWidth: 167
                Layout.preferredHeight: 26
                sourceSize: Qt.size(500, 76)
                source: "qrc:/images/logo.png"
                Layout.alignment: Qt.AlignHCenter
                visible: about.isCutefishOS
                asynchronous: true
            }

            Label {
                text: qsTr("Built on %1").arg(about.prettyProductName)
                visible: !about.isCutefishOS
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                color: Theme.disabledTextColor
            }

            Item {
                height: Theme.largeSpacing * 2
            }

            RoundedItem {
                StandardItem {
                    key: qsTr("System Version")
                    value: about.version
                }
                StandardItem {
                    key: qsTr("System Type")
                    value: about.architecture
                }
                StandardItem {
                    key: qsTr("Kernel Version")
                    value: about.kernelVersion
                }
                StandardItem {
                    key: qsTr("Processor")
                    value: about.cpuInfo
                }
                StandardItem {
                    key: qsTr("RAM")
                    value: about.memorySize
                }
                StandardItem {
                    key: qsTr("Internal Storage")
                    value: about.internalStorage
                }
            }

            Item {
                height: Theme.smallSpacing
            }

            StandardButton {
                Layout.fillWidth: true
                visible: about.isCutefishOS
                text: qsTr("Software Update")
                onClicked: about.openUpdator()
            }
        }
    }
}
