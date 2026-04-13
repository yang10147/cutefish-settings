import QtQuick

Canvas {
    width: 500
    height: 500
    id: canvas
    antialiasing: true

    property int xPadding: 45
    property int yPadding: 40

    property var data
    property real yMax: 100
    property real xMax: 100
    property real yMin: 0
    property real xMin: 0
    property real yStep: 20

    property string yUnits: ""
    property string xUnits: ""

    property real xDuration: 3600
    property real xDivisions: 6
    property real xDivisionWidth: 600000
    property real xTicksAt: xTicksAtDontCare

    property real plotWidth: width - xPadding * 1.5
    property real plotHeight: height - yPadding * 2

    SystemPalette { id: palette }

    property color textColor: palette.text
    property color bgColor: palette.base
    property color highlightColor: palette.highlight
    property bool darkMode: palette.window.hslLightness < 0.5

    onDataChanged: canvas.requestPaint()
    onTextColorChanged: canvas.requestPaint()
    onHighlightColorChanged: canvas.requestPaint()

    function scalePoint(plot, currentUnixTime) {
        var scaledX = (plot.x - (currentUnixTime / 1000 - xDuration)) / xDuration * plotWidth
        var scaledY = (plot.y - yMin) * plotHeight / (yMax - yMin)
        return Qt.point(xPadding + scaledX, height - yPadding - scaledY)
    }

    onPaint: {
        var c = canvas.getContext('2d')
        c.clearRect(0, 0, width, height)

        c.fillStyle = bgColor
        c.fillRect(xPadding, yPadding, plotWidth, plotHeight)
        c.fillStyle = textColor

        c.lineWidth = 1
        c.lineJoin = 'round'
        c.lineCap = 'round'
        c.strokeStyle = highlightColor
        var gradient = c.createLinearGradient(0, 0, 0, height)
        gradient.addColorStop(0, Qt.rgba(highlightColor.r, highlightColor.g, highlightColor.b, 0.2))
        gradient.addColorStop(1, Qt.rgba(highlightColor.r, highlightColor.g, highlightColor.b, 0.05))
        c.fillStyle = gradient

        var currentUnixTime = Date.now()
        var xMinUnixTime = currentUnixTime - xDuration * 1000

        c.beginPath()
        var index = 0
        while ((index < data.length - 1) && (data[index].x < (xMinUnixTime / 1000))) {
            index++
        }

        var firstPoint = scalePoint(data[index], currentUnixTime)
        c.moveTo(firstPoint.x, firstPoint.y)

        var point
        for (var i = index + 1; i < data.length; i++) {
            if (data[i].x > (xMinUnixTime / 1000)) {
                point = scalePoint(data[i], currentUnixTime)
                c.lineTo(point.x, point.y)
            }
        }

        if (point === undefined) return

        c.stroke()
        c.strokeStyle = 'rgba(0, 0, 0, 0)'
        c.lineTo(point.x, height - yPadding)
        c.lineTo(firstPoint.x, height - yPadding)
        c.fill()
        c.closePath()

        c.fillStyle = textColor
        c.textAlign = "right"
        c.textBaseline = "middle"
        for (i = 0; i <= yMax; i += yStep) {
            var y = scalePoint(Qt.point(0, i)).y
            c.fillText(i + canvas.yUnits, xPadding - 10, y)
            c.moveTo(xPadding, y)
            c.lineTo(plotWidth + xPadding, y)
        }
        c.stroke()

        c.textAlign = "center"
        c.lineWidth = 1
        c.strokeStyle = darkMode ? 'rgba(0, 0, 0, 0.35)' : 'rgba(0, 0, 0, 0.15)'

        var xDivisions = xDuration / xDivisionWidth * 1000
        var xGridDistance = plotWidth / xDivisions
        var xTickPos, xTickDateTime, xTickDateStr, xTickTimeStr

        var currentDateTime = new Date()
        var lastDateStr = currentDateTime.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
        var hours = currentDateTime.getHours()
        var minutes = currentDateTime.getMinutes()
        var seconds = currentDateTime.getSeconds()
        var diff

        switch (xTicksAt) {
            case 1: diff = ((hours - 12) * 60 * 60 + minutes * 60 + seconds); break
            case 2: diff = (minutes * 60 + seconds); break
            case 4: diff = (minutes * 60 + seconds); break
            case 3: diff = ((minutes - 30) * 60 + seconds); break
            case 5: diff = ((minutes % 10) * 60 + seconds); break
            default: diff = 0
        }

        var xGridOffset = plotWidth * (diff / xDuration)
        var dateChanged = false
        var dashedLines = 50
        var dashedLineLength = plotHeight / dashedLines
        var dashedLineDutyCycle

        for (i = xDivisions; i >= -1; i--) {
            xTickPos = i * xGridDistance + xPadding - xGridOffset

            if ((xTickPos > xPadding) && (xTickPos < plotWidth + xPadding)) {
                xTickDateTime = new Date(currentUnixTime - (xDivisions - i) * xDivisionWidth - diff * 1000)
                xTickDateStr = xTickDateTime.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
                xTickTimeStr = xTickDateTime.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)

                if (lastDateStr !== xTickDateStr) dateChanged = true

                if ((i % 2 == 0) || (xDivisions < 10)) {
                    c.fillText(xTickTimeStr, xTickPos, canvas.height - yPadding / 2)
                    if (dateChanged || (xDuration > (60 * 60 * 48))) {
                        c.fillText(xTickDateStr, xTickPos, canvas.height - yPadding / 4)
                        dateChanged = false
                    }
                    c.moveTo(xTickPos, canvas.height - yPadding)
                    c.lineTo(xTickPos, canvas.height - (yPadding * 4) / 5)
                    dashedLineDutyCycle = 0.5
                } else {
                    dashedLineDutyCycle = 0.1
                }

                for (var j = 0; j < dashedLines; j++) {
                    c.moveTo(xTickPos, yPadding + j * dashedLineLength)
                    c.lineTo(xTickPos, yPadding + j * dashedLineLength + dashedLineDutyCycle * dashedLineLength)
                }
                lastDateStr = xTickDateStr
            }
        }
        c.stroke()
    }
}
