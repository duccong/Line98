import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml 2.12
import "layouts"
Window {
    width: 640
    height: 680
    visible: true
    title: qsTr("Hello World")

    StartGame {
        id: startGameLayout
        onCommand: {
            if (cmd === "StartGame") {
                startGameLayout.visible = false
                inGameLayout.visible = true
            }
        }
    }

    InGame {
        id: inGameLayout
        visible: false
    }

    Component.onCompleted: console.log("main.qml is created!")
}
