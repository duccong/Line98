import QtQuick 2.12

Item{
    id: root
    height: 0
    width: 0
    // visible: ccfLoader.isEnableNulo

    property string color: randomColor
    property string text: ""

    property var colorList: ["red", "deeppink", "fuchsia", "firebrick", "gold", "lime"
        , "limegreen", "mediumvioletred", "orangered", "royalblue", "springgreen"
        , "#16a085", "#27ae60", "#2980b9", "#8e44ad"
        , "#f1c40f", "#e67e22", "#e74c3c", "#ecf0f1"]

    property color itemColor: "red"
    property color mouseAreaColor: "deeppink"
    property color randomColor: colorList[Math.floor(Math.random()*(colorList.length - 1))]
    property bool grid: false
    property bool ruler: false


    Rectangle {
        id: rec
        height: root.parent.height
        width: root.parent.width
        color: "transparent"
        border.color: root.color

        Canvas{
            id: grid
            visible: root.grid
            anchors.fill : parent
            property int wgrid: 50
            onPaint: {
                var ctx = getContext("2d")
                ctx.lineWidth = 1
                ctx.strokeStyle = root.color
                ctx.beginPath()
                var nrows = height/wgrid;
                for(var i=0; i < nrows+1; i++){
                    ctx.moveTo(0, wgrid*i);
                    ctx.lineTo(width, wgrid*i);
                }

                var ncols = width/wgrid
                for(var j=0; j < ncols+1; j++){
                    ctx.moveTo(wgrid*j, 0);
                    ctx.lineTo(wgrid*j, height);
                }
                ctx.closePath()
                ctx.stroke()
            }
        }

        Canvas{
            id: ruler
            visible: root.ruler
            anchors.fill : parent

            onPaint: {
                var ctx = getContext("2d")
                ctx.lineWidth = 1
                ctx.strokeStyle = root.color
                ctx.fillStyle = root.color
                ctx.font = '30pt sans-serif'
                ctx.beginPath()
                var nrows = height/50
                for(var i=0; i < nrows+1; i++){
                    ctx.moveTo(width, 50*i);
                    ctx.lineTo(width-10, 50*i);
                }

                var ncols = width/50
                for(var j=0; j < ncols+1; j++){
                    ctx.moveTo(50*j, 0);
                    ctx.lineTo(50*j, 10);
                }

                nrows = height/100
                for(i=0; i < nrows+1; i++){
                    ctx.moveTo(width, 100*i);
                    ctx.lineTo(width-20, 100*i);
                    ctx.fillText(String(100*i), width-30, 100*i)
                }

                ncols = width/50
                for(j=0; j < ncols+1; j++){
                    ctx.moveTo(100*j, 0);
                    ctx.lineTo(100*j, 20);
                    ctx.fillText(String(100*j), 100*j, 30)
                }
                ctx.closePath()
                ctx.stroke()
            }
        }

        Text{
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: parent.height
            color: root.color
            rotation: -90
        }
        Text{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: parent.width
            color: root.color
        }
        Text{
            anchors.centerIn: parent
            opacity: 0.5
            text: root.text
            color: root.color
        }
        Text {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            font.pixelSize: 10
            text: root.parent.x
            color: root.color
        }

    }
}
