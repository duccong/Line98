import QtQuick 2.0
import QtQml 2.12
import "../MyScript.js" as MyScript
import "../utils"

Item {
    id: container
    anchors.fill: parent

    signal command(var cmd, var opt)

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "BLUE"
        opacity: 0.5
    }

    Repeater {
        model: 8
        delegate:
            Image {
                id: ball
                width: 50
                height: 50
                source: MyScript.getPathBall(index)

                x: (index + 1) * 50
                // NumberAnimation on x {
                    // running: true
                    // duration: 3000
                    // to: (index + 10) * 50
                // }

                NumberAnimation on y {
                    loops: 1000
                    running: visible
                    duration: (index % 9 +1) * (500 + ( 9 - index) * 100)
                    from: 0
                    to: 710//container.height
                    // onRunningChanged: {
                        // console.log("onRunningChanged: ", index, " : ", running)
                    // }
                }

                Component.onCompleted: {
                }
            }
    }


    Text {
        id: title
        anchors.top: parent.top
        anchors.margins: parent.height / 4
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Line 98"
        font.pixelSize: 48
    }

    Button {
        anchors.top: title.bottom
        anchors.topMargin: parent.height / 4
        anchors.horizontalCenter: parent.horizontalCenter
        textbtn: "Start game"

        onClicked: {
            command("StartGame", "")
        }
    }


}
