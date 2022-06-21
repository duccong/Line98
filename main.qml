import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml 2.12
import "layouts"
import "MyScript.js" as MyScript
Window {
    width: 630
    height: 710
    visible: true
    title: qsTr("Hello World")

    property int currentLayout: 0


    StartGame {
        id: startGameLayout
        visible: true //currentLayout === 0
        onCommand: {
            if (cmd === "StartGame") {
                startGameLayout.visible = false
                inGameLayout.visible = true
            }
        }
    }

    InGame {
        id: inGameLayout
        visible: false //currentLayout === 1
    }

    Intro {
        id: introLayout
        visible: false //currentLayout === 2
    }

    onCurrentLayoutChanged: {
        startGameLayout.visible = false
        inGameLayout.visible = false
        introLayout.visible = false
        if (currentLayout === 0) {
            startGameLayout.visible = true
        } else if (currentLayout === 1) {
            inGameLayout.visible = true
        } else if (currentLayout === 2){
            introLayout.visible = true
        } else {
            startGameLayout.visible = true
        }
        // if (currentLayout === 0) {
            // loaderGame.active = false
            // loaderGame.source = "qrc:/layouts/StartGame.qml?"+Math.random()
            // loaderGame.active = true
        // } else if (currentLayout === 1) {
            // loaderGame.active = false
            // loaderGame.source = "qrc:/layouts/InGame.qml?"+Math.random()
            // loaderGame.active = true
        // } else if (currentLayout === 2){
            // loaderGame.active = false
            // loaderGame.source = "qrc:/layouts/Intro.qml?"+Math.random()
            // loaderGame.active = true
        // } else {
            // loaderGame.active = false
            // loaderGame.source = "qrc:/layouts/StartGame.qml?"+Math.random()
            // loaderGame.active = true
        // }
    }

    // Loader {
        // id: loaderGame
        // anchors.fill: parent
        // source: "qrc:/layouts/StartGame.qml"

        // Connections {
            // target: loaderGame.item
            // ignoreUnknownSignals: true
            // onCommand: {
                // if (cmd === "StartGame") {
                    // loaderGame.source = "qrc:/layouts/InGame.qml"
                // }
            // }
        // }
    // }

    // Timer {
        // id: timer
        // interval: 2000
        // running: true
        // repeat: true
        // onTriggered: {
            // currentLayout++
            // if (currentLayout > 2) {
                // currentLayout = 0
                // timer.stop()
            // }
        // }
    // }
/*
    property int rectangleWidth: 100
    property int rectangleHeight: 100
    Item {
        id: root
        property int rectangleWidth: 50
        property int rectangleHeight: 50
        Rectangle {
            property int rectangleWidth: parent.rectangleWidth
            width: rectangleWidth
            height: parent.rectangleHeight
            color: "RED"
            Rectangle {
                width: rectangleWidth / 2
                height: parent.height //parent.rectangleHeight
                color: "BLUE"
            }
        }
    }
*/

    Component.onCompleted: console.log("main.qml is created!")
}
