import QtQuick 2.0

Item {
    id: container

    width: 200
    height: 50

    property var textbtn: undefined
    property var textSize: 24

    signal clicked()

    Rectangle {
        anchors.fill: parent
        color: "RED"
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
            container.clicked()
        }
    }

}
