import QtQuick
import QtQuick.Controls

Item {
    id: control

    SystemPalette { id: palette }

    clip: true

    Component {
        id: wallpaperItem
        Image {
            source: "file://" + background.currentBackgroundPath
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
        }
    }

    Component {
        id: colorItem
        Rectangle {
            color: background.backgroundColor
        }
    }

    Loader {
        anchors.fill: parent
        sourceComponent: background.backgroundType === 0 ? wallpaperItem : colorItem
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: 30; height: width
        radius: height * 0.2
        opacity: 0.5
        color: palette.window
    }

    Rectangle {
        id: desktopItem
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 50
        width: 30; height: width
        radius: height * 0.2
        opacity: 0.5
        color: palette.window
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        height: 38
        radius: height * 0.3
        color: palette.window
        opacity: 0.7
    }
}
