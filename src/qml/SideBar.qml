import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml.Models
import Cutefish.Settings 1.0
import "./"

Item {
    implicitWidth: 230

    property alias view: listView
    property alias model: listModel
    property alias currentIndex: listView.currentIndex

    // 侧边栏背景
    Rectangle {
        anchors.fill: parent
        color: Theme.sidebarColor

        Behavior on color {
            ColorAnimation { duration: 250; easing.type: Easing.Linear }
        }
    }

    ListModel {
        id: listModel

        ListElement {
            title: qsTr("WLAN")
            name: "wlan"
            page: "qrc:/qml/WLAN/Main.qml"
            iconSource: "wlan.svg"
            iconColor: "#0067FF"
            category: qsTr("Network and connection")
        }
        ListElement {
            title: qsTr("Ethernet")
            name: "ethernet"
            page: "qrc:/qml/Wired/Main.qml"
            iconSource: "network.svg"
            iconColor: "#0067FF"
            category: qsTr("Network and connection")
        }
        ListElement {
            title: qsTr("Bluetooth")
            name: "bluetooth"
            page: "qrc:/qml/Bluetooth/Main.qml"
            iconSource: "bluetooth.svg"
            iconColor: "#0067FF"
            category: qsTr("Network and connection")
        }
        ListElement {
            title: qsTr("Proxy")
            name: "proxy"
            page: "qrc:/qml/Proxy/Main.qml"
            iconSource: "proxy.svg"
            iconColor: "#0067FF"
            category: qsTr("Network and connection")
        }
        ListElement {
            title: qsTr("Display")
            name: "display"
            page: "qrc:/qml/Display/Main.qml"
            iconSource: "display.svg"
            iconColor: "#0087ED"
            category: qsTr("Display and appearance")
        }
        ListElement {
            title: qsTr("Appearance")
            name: "appearance"
            page: "qrc:/qml/Appearance/Main.qml"
            iconSource: "appearance.svg"
            iconColor: "#03B4CB"
            category: qsTr("Display and appearance")
        }
        ListElement {
            title: qsTr("Fonts")
            name: "fonts"
            page: "qrc:/qml/Fonts/Main.qml"
            iconSource: "fonts.svg"
            iconColor: "#FFBF36"
            category: qsTr("Display and appearance")
        }
        ListElement {
            title: qsTr("Background")
            name: "background"
            page: "qrc:/qml/Wallpaper/Main.qml"
            iconSource: "wallpaper.svg"
            iconColor: "#34B4A7"
            category: qsTr("Display and appearance")
        }
        ListElement {
            title: qsTr("Dock")
            name: "dock"
            page: "qrc:/qml/Dock/Main.qml"
            iconSource: "dock.svg"
            iconColor: "#8585FC"
            category: qsTr("Display and appearance")
        }
        ListElement {
            title: qsTr("User")
            name: "accounts"
            page: "qrc:/qml/User/Main.qml"
            iconSource: "accounts.svg"
            iconColor: "#DA7C43"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Notifications")
            name: "notifications"
            page: "qrc:/qml/Notification/Main.qml"
            iconSource: "notifications.svg"
            iconColor: "#F16884"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Sound")
            name: "sound"
            page: "qrc:/qml/Sound/Main.qml"
            iconSource: "sound.svg"
            iconColor: "#F16884"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Mouse")
            name: "mouse"
            page: "qrc:/qml/Cursor/Main.qml"
            iconSource: "cursor.svg"
            iconColor: "#3385FF"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Touchpad")
            name: "touchpad"
            page: "qrc:/qml/Touchpad/Main.qml"
            iconSource: "touchpad.svg"
            iconColor: "#999999"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Date & Time")
            name: "datetime"
            page: "qrc:/qml/DateTime/Main.qml"
            iconSource: "datetime.svg"
            iconColor: "#418CFF"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Default Applications")
            name: "defaultapps"
            page: "qrc:/qml/DefaultApp/Main.qml"
            iconSource: "defaultapps.svg"
            iconColor: "#418CFF"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Language")
            name: "language"
            page: "qrc:/qml/LanguagePage.qml"
            iconSource: "language.svg"
            iconColor: "#20A7FF"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Battery")
            name: "battery"
            page: "qrc:/qml/Battery/Main.qml"
            iconSource: "battery.svg"
            iconColor: "#2EC347"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("Power")
            name: "power"
            page: "qrc:/qml/Power/Main.qml"
            iconColor: "#FE8433"
            iconSource: "power.svg"
            category: qsTr("System")
        }
        ListElement {
            title: qsTr("About")
            name: "about"
            page: "qrc:/qml/About/Main.qml"
            iconSource: "about.svg"
            iconColor: "#24A7FD"
            category: qsTr("System")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        // 标题栏区域
        Label {
            text: rootWindow.title
            color: Theme.textColor
            Layout.preferredHeight: 40
            leftPadding: Theme.largeSpacing + Theme.smallSpacing
            rightPadding: Theme.largeSpacing + Theme.smallSpacing
            topPadding: Theme.smallSpacing
            bottomPadding: 0
            font.pointSize: 13
        }

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            model: listModel

            spacing: Theme.smallSpacing
            leftMargin: Theme.largeSpacing
            rightMargin: Theme.largeSpacing
            topMargin: 0
            bottomMargin: Theme.largeSpacing

            ScrollBar.vertical: ScrollBar {}
            WheelHandler {
                target: listView
                onWheel: (event) => {
                    listView.contentY -= event.angleDelta.y
                }
            }

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration: 0
            highlight: Rectangle {
                radius: Theme.mediumRadius
                color: Qt.rgba(Theme.textColor.r,
                               Theme.textColor.g,
                               Theme.textColor.b, 0.05)
                smooth: true
            }

            section.property: "category"
            section.delegate: Item {
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: Theme.fontMetricsHeight + Theme.largeSpacing + Theme.smallSpacing

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: Theme.smallSpacing
                    anchors.topMargin: Theme.largeSpacing
                    color: Theme.disabledTextColor
                    font.pointSize: 8
                    text: section
                }
            }

            WheelHandler {
                target: listView
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            }

            delegate: Item {
                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: 35

                property bool isCurrent: listView.currentIndex === index

                Rectangle {
                    anchors.fill: parent

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: listView.currentIndex = index
                    }

                    radius: Theme.mediumRadius
                    color: mouseArea.pressed
                        ? Qt.rgba(Theme.textColor.r, Theme.textColor.g, Theme.textColor.b,
                                  Theme.darkMode ? 0.05 : 0.10)
                        : (mouseArea.containsMouse || isCurrent)
                            ? Qt.rgba(Theme.textColor.r, Theme.textColor.g, Theme.textColor.b,
                                      Theme.darkMode ? 0.10 : 0.05)
                            : "transparent"
                    smooth: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.smallSpacing
                    spacing: Theme.smallSpacing

                    Rectangle {
                        width: 24
                        height: 24
                        Layout.alignment: Qt.AlignVCenter
                        radius: 6
                        color: model.iconColor

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(model.iconColor, 1.15) }
                            GradientStop { position: 1.0; color: model.iconColor }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 16
                            height: width
                            source: "qrc:/images/sidebar/dark/" + model.iconSource
                            sourceSize: Qt.size(width, height)
                            antialiasing: false
                            smooth: false
                        }
                    }

                    Label {
                        text: model.title
                        color: Theme.darkMode ? Theme.textColor : "#363636"
                        font.pointSize: 8
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }
    }

    function removeItem(name) {
        for (var i = 0; i < listModel.count; ++i) {
            if (name === listModel.get(i).name) {
                listModel.remove(i)
                break
            }
        }
    }

    property var _battery: Battery {}
    property var _touchPad: Touchpad {}

    Timer {
        interval: 0
        running: true
        repeat: false
        onTriggered: {
            if (!_battery.available)
                removeItem("battery")
            if (!_touchPad.available)
                removeItem("touchpad")
        }
    }
}
