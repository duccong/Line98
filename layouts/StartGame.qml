import QtQuick 2.0
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
