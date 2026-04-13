pragma Singleton
import QtQuick


Item {
    // 深色模式检测
    readonly property bool darkMode: Qt.styleHints.colorScheme === Qt.Dark

    // 基础颜色
    readonly property color backgroundColor:    darkMode ? "#1E1E1E" : "#F0F0F0"
    readonly property color secondBackgroundColor: darkMode ? "#2A2A2A" : "#FFFFFF"
    readonly property color sidebarColor:       darkMode ? "#252525" : "#E8E8E8"
    readonly property color textColor:          darkMode ? "#FFFFFF" : "#1A1A1A"
    readonly property color disabledTextColor:  darkMode ? "#808080" : "#999999"
    readonly property color highlightColor:     "#3385FF"
    readonly property color highlightTextColor: "#FFFFFF"

    // 圆角
    readonly property real smallRadius:  4
    readonly property real mediumRadius: 8
    readonly property real bigRadius:    12

    // Units
    readonly property real smallSpacing:  4
    readonly property real largeSpacing: 12

    // 字体度量（用于区段标题高度）
    readonly property real fontMetricsHeight: 14
}
