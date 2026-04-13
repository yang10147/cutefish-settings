import QtQuick
import QtQuick.Controls
import QtQuick.Particles

Item {
    id: control
    height: 150

    property int value: 0
    property int radius: height * 0.15
    property bool enableAnimation: false

    SystemPalette { id: palette }

    // 用 clip + Rectangle 替代 OpacityMask
    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: Qt.rgba(palette.highlight.r,
                       palette.highlight.g,
                       palette.highlight.b, 0.4)
        clip: true

        Rectangle {
            id: valueRect
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: control.width * (control.value / 100)
            opacity: 1

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Qt.rgba(palette.highlight.r,
                                                             palette.highlight.g,
                                                             palette.highlight.b, 1) }
                GradientStop { position: 1.0; color: Qt.rgba(palette.highlight.r,
                                                             palette.highlight.g,
                                                             palette.highlight.b, 0.3) }
            }

            Behavior on width {
                SmoothedAnimation {
                    velocity: 1000
                    easing.type: Easing.OutSine
                }
            }

            ParticleSystem {
                anchors.fill: parent

                Emitter {
                    anchors.fill: parent
                    emitRate: 7
                    lifeSpan: 2000
                    lifeSpanVariation: 500
                    size: 16
                    endSize: 32
                    enabled: control.enableAnimation

                    velocity: AngleDirection {
                        angle: 0
                        magnitude: 175
                        magnitudeVariation: 50
                    }
                }

                ItemParticle {
                    delegate: Rectangle {
                        width: Math.ceil(Math.random() * (10 - 4)) + 4
                        height: width
                        radius: width
                        color: Qt.rgba(255, 255, 255, 0.3)
                    }
                }
            }
        }
    }
}
