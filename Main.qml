import QtQuick
import SerialObserver 1.0
import QtQuick.Layouts
import QtMultimedia

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
        // color:"#4A148C"
        color:"black"
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



    Rectangle{
        id: videoWindow
        width:  window.width
        height: window.height*0.8
        color: "black"
        anchors.top: dashboard.bottom
        anchors.left: dashboard.left
        MediaPlayer {
            id: player
            // source: "https://www.youtube.com/watch?v=rKn4EQ3-Ns0"
            source:"https://video-weaver.hkg06.hls.ttvnw.net/v1/playlist/CusFlGavpvBGI5rY6PqesGKKMmSnqfTNqUDE8zbM1DOuYvn0Guk4GtQxvWY2AE0R_bGQd7RPbcIptp0Jw_fF5X-JkAvaQl1DYs7v561XLiaEG19TCwYzO5yIxuC2UR_5DQEJ-fbi3lR5YWRR8A5a7L_Cc9OWa-mnZ_V9_3kgtiaNSs7ccJOebr3QUJ0V0-9KeDoHwCbA0_arltBJ-V9RdJRekxS_rTpZ5XtWCJHXcyjfgZw-1vdmpwKLVSAdXbvgAWgzsO4i-TDQhwpXU6Vf79Xf4o30T7BxluoKyVs1Zq1wXe_fWUL5Daw_du_anELdXDfFPt6l8_qlQdYe4guHe0O5t5hiUVvCdzbLdTTMKo7G4Awn4YrwG2yV1x5BIPdV5r9H1GfnTLR64IinTZae9cOy6OFFT9Xlpa4W8NEE50P4hUStHUniLfqu1lQwqi5dyScsML4RKRyS6RSkesJmwgSJBwSVU8zRn5M6soQLB4tMwsCEqlQza5y4D5FLKUnPcGVZ2iNfahC2b1xWPw8fkE3CxuvLcqQ6GyYgeApVP_6tB5pCEvYGyx9bTrLgubQPvUHlTy3ThRtEaTv6VEOksVvS9BxgrGfyXs8sR_fIe8xAWo74XAUbTk5ykDHedu56kBR6XAVu7ajI5q8knMKFOP0PVPQ2zhE1cqxghdQkT-fGP8E_gOF2cvgAkA4gKCl0WOJ2orLu2WSBKOBQ93pP-mpYJiHLokRuBIe3BtjnG8Igcu2p_tDiwt-vU5ijypYvwQRRJnE-VveVzDBzZ5Oog1hcXm1bxnxqxhxnf2hGhYH_J5zvFXEAnTakA0iickR-pmdWWtO1htQORhFHR2FEQaKwtTlHt6ZtVNqnXGvJ2zsy7BKc50r-ZbEqtxBh9BdxLaiTjjE8EZbIdh8VH595yiODVQOG1_lHGacqFrWRIWiDGLzL0GuySWM6xv9Uci55XE1loBj-mDiph2eddqqSPeWZxp-4adqebhFAZC3KGgx1DvKF-ByaWpat-JggASoJdXMtd2VzdC0yMPYJ.m3u8"
            videoOutput: videoOutput
            audioOutput: AudioOutput {}
            // onErrorOccurred: error => console.log('Error occurred:', errorString, error)
        }
        VideoOutput{
            id: videoOutput
            anchors.fill: parent
        }
    }

    Component.onCompleted: {
        player.play()
    }


}
