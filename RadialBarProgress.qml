import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Item {
    id:cell
    // property alias contentText: valueText.text
    property alias contentTextColor: valueText.color
    property alias contentTextSize: valueText.font.pointSize
    property alias contentUnit : unitText.text

    property alias title: measurement.text
    property alias titleColor:  measurement.color
    property alias titleSize:  measurement.font.pointSize

    property alias backgroundColor: container.color
    property alias progressLineColor: progressLine.strokeColor
    property alias foregroundColor: forceground.strokeColor

    property double arcLineRadius: Math.min(shape.width/2*0.9,shape.height/2*0.9)

    property double widthLine: 30

    property double maxValue: 100
    property double minValue: 0
    property double currentValue: 90

    property double startAngleArc: 135
    property double stopLengthAngle: 270

    property double progressLengthAngle: currentValue*stopLengthAngle/(maxValue-minValue)



    // property double maxTextRightMargin:  shape.width*(1-arcLineRadius*1.5/shape.width)/2
    // property double maxTextBottomMargin: shape.height*0.05
    // property double minTextLeftMargin:  shape.width*(1-arcLineRadius*1.5/shape.width)/2
    // property double minTextBottomMargin: shape.height*0.05
    property double maxTextRightMargin: container.width/2-arcLineRadius*1.45/2
    property double maxTextBottomMargin: 0
    property double minTextLeftMargin:  container.width/2-arcLineRadius*1.45/2
    property double minTextBottomMargin: 0

    // property alias  : value
    Rectangle{
        id: container
        anchors.fill: parent
        anchors.margins: 0
        // border.color: "blue"
        // border.width: 10


        Rectangle{
            id: title
            width: parent.width
            height: parent.height*0.2
            anchors.top: container.top
            anchors.left: container.left
            color: parent.color

            Text {
                id: measurement
                text: qsTr("Temperature")
                anchors.fill: parent

            }
        }
        Rectangle{
            id: shape
            // add propertyidht and heigh of arc
            width: parent.width
            height: parent.height*0.8

            anchors.top: title.bottom
            anchors.horizontalCenter: container.horizontalCenter
            color: parent.color

            Shape {

                anchors.fill: parent

                antialiasing: true
                ShapePath {
                    id:forceground
                    strokeColor: "grey"
                    strokeWidth: widthLine
                    fillColor: "transparent"
                    fillRule: ShapePath.OddEvenFill
                    capStyle: ShapePath.RoundCap
                    PathAngleArc {
                        centerX: shape.width/2; centerY: shape.height/2
                        radiusX: arcLineRadius; radiusY: arcLineRadius
                        startAngle:  startAngleArc
                        sweepAngle: stopLengthAngle
                    }
                }

                ShapePath {
                    id:progressLine
                    //////add property
                    strokeColor: "green"
                    strokeWidth: widthLine
                    fillColor: "transparent"
                    fillRule: ShapePath.OddEvenFill
                    capStyle: ShapePath.RoundCap
                    PathAngleArc {
                        centerX: shape.width/2; centerY: shape.height/2
                        radiusX: arcLineRadius; radiusY: arcLineRadius
                        startAngle:  startAngleArc
                        sweepAngle: progressLengthAngle
                    }
                }
            }
        }


        Text {
            id: minValueText
            text: qsTr("%1").arg(minValue)
            anchors.bottom: container.bottom
            anchors.left: container.left
            anchors.leftMargin: minTextLeftMargin
            anchors.bottomMargin: minTextBottomMargin
            //add property type name: value
            color: titleColor
            font.pointSize: contentTextSize*0.6

        }
        Text {
            id: maxValueText
            text: qsTr("%1").arg(maxValue)
            anchors.bottom: container.bottom
            anchors.right: container.right
            anchors.rightMargin: maxTextRightMargin
            anchors.bottomMargin: maxTextBottomMargin
            color: titleColor
            font.pointSize: contentTextSize*0.6

        }
        Text {
            id: valueText
            // anchors.centerIn: shape
            anchors.top: shape.top
            anchors.horizontalCenter: shape.horizontalCenter
            anchors.topMargin: shape.height*0.3

            text: qsTr("%1").arg(currentValue)
        }

        Text {
            id: unitText
            anchors.top: valueText.bottom
            anchors.horizontalCenter: valueText.horizontalCenter
            color: contentTextColor
            font.pointSize: contentTextSize*0.8
            text: qsTr(unitText)
        }



    }

    Behavior on progressLengthAngle {
        NumberAnimation {
            duration: 500 // Thời gian chạy của hoạt ảnh là 500ms (0.5 giây)
            easing.type: Easing.InOutQuad // Kiểu chuyển động là InOutQuad (tăng tốc rồi giảm tốc)
        }
    }


}
