import QtQuick 2.0

Item {
    id: container
    property string objectName: "button"
    property var bgColor: "RED"
    property alias bgRect: bg

    width: 200
    height: 50

    property var textbtn: undefined
    property var textSize: 24

    signal clicked()

    Rectangle {
        id: bg
        anchors.fill: parent
        color: bgColor
        opacity: 0.5
        border.color: "BLACK"
        radius: 3
    }

    Text {
        id: text
        anchors.centerIn: parent
        text: textbtn
        font.pixelSize: textSize
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Clicked on ", container.objectName)
            container.clicked()
        }
    }
}
