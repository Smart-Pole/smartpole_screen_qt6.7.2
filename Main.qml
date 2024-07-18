import QtQuick
import SerialObserver 1.0
import QtQuick.Layouts
Window {
    id: window
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Hello World")
    // color:"#1d1d35"

    SerialObserver{
        id:observer

    }

    property int rowNumber: 1
    property int columnNumber: 6

    property double dashboardWidth: window.width
    property double dashboardHeight: window.height*0.2


    property double cellWidth: dashboardWidth/columnNumber
    property double cellHeight: dashboardHeight/rowNumber



    property var itemList: [
        {tagName:"Temp",    measuredValue: observer.temparatureValue, unit: "°C",      minLimit: 0, maxLimit: 100},
        {tagName:"Humi",    measuredValue: observer.humidityValue, unit: "%",       minLimit: 0, maxLimit: 100},
        {tagName:"PM2.5",   measuredValue: observer.pm25Value, unit: "µm/m3",   minLimit: 0, maxLimit: 1000},
        {tagName:"PM10",    measuredValue: observer.pm10Value, unit: "µm/m3",   minLimit: 0, maxLimit: 1000},
        {tagName:"Atm",     measuredValue: observer.atmValue, unit: "Kpa",     minLimit: 0, maxLimit: 120},
        {tagName:"Noise",   measuredValue: observer.noiseValue, unit: "dB",      minLimit: 30, maxLimit: 130}
    ]

Rectangle{
    id: dashboard
    width: dashboardWidth
    height: dashboardHeight
    color:"#4A148C"
    GridLayout{
        rows: window.rowNumber
        columns: window.columnNumber
        columnSpacing: 2
        rowSpacing: 0

        Repeater{
            model: itemList.length
            RadialBarProgress{
                // id: test
                width: window.cellWidth
                height: window.cellHeight
                // edit here
                title: itemList[index].tagName
                currentValue: itemList[index].measuredValue
                contentUnit: itemList[index].unit
                minValue: itemList[index].minLimit
                maxValue: itemList[index].maxLimit


                contentTextSize: 25
                titleSize: 20
                widthLine: 20

                titleColor: "#FAFAFA"
                contentTextColor: "red"
                backgroundColor: "#1d1d35"
                // backgroundColor: "transparent"
                progressLineColor:"#00ffc1"
                // foregroundColor:"#191a2f"
                foregroundColor: "#263238"
            }


        }


    }

}







    // RadialBarProgress{
    //     id: test
    //     width: 400
    //     height: 300
    //     // contentText: qsTr("50")
    //     currentValue: observer.value

    //     contentTextSize: 30
    //     contentTextColor: "red"
    //     contentUnit:"C degree"

    //     title: "Temperature"
    //     titleColor: "#FAFAFA"
    //     titleSize: 20

    //     backgroundColor: "#1d1d35"
    //     // backgroundColor: "transparent"
    //     progressLineColor:"#00ffc1"
    //     foregroundColor:"#191a2f"
    //     // startAngle: 145

    // }


}
