import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

ApplicationWindow {
    id: rootWindow
    title: qsTr("Settings")
    visible: true
    width: 900
    height: 610
    minimumWidth: 900
    minimumHeight: 600

    // 供子页面访问的属性（兼容原有引用）
    readonly property bool compositing: true
    readonly property bool active: activeFocusItem !== null || Window.active

    property alias stackView: _stackView

    color: Theme.backgroundColor

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    RowLayout {
        anchors.fill: parent
        spacing: 0

        SideBar {
            id: sideBar
            Layout.fillHeight: true

            onCurrentIndexChanged: {
                switchPageFromIndex(currentIndex)
            }
        }

        StackView {
            id: _stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: Qt.resolvedUrl(sideBar.model.get(0).page)
            clip: true

            pushEnter: Transition {}
            pushExit: Transition {}
        }
    }

    function switchPageFromIndex(index) {
        _stackView.pop()
        _stackView.push(Qt.resolvedUrl(sideBar.model.get(index).page))
    }

    function switchPageFromName(pageName) {
        for (var i = 0; i < sideBar.model.count; ++i) {
            if (pageName === sideBar.model.get(i).name) {
                switchPageFromIndex(i)
                sideBar.view.currentIndex = i
            }
        }
        rootWindow.show()
        rootWindow.raise()
    }
}
