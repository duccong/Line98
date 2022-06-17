import QtQuick 2.0
import "../MyScript.js" as MyScript
Item {
    id: ball

    readonly property int _IDLE: 0
    readonly property int _SELECTED: 1

    property int ballValue: -1
    property int ballState: _IDLE
    property var ballStateName: ballState == _IDLE ? "IDLE" : "SELECTED"

    width: 70
    height: 70


    signal clicked(var opt)

    Image {
        id: imgBall
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width: 40
        sourceSize.height: 40
        y: 25 // 70 - 40
        source: MyScript.getPathBall(ballValue)//"qrc:/res/ball_blue.png"
        state: ballStateName

        Text {
            id: ballText
            text: (ball.ballValue)
            anchors.centerIn: parent
        }

        states: [
            State {
                name: "IDLE"
                PropertyChanges {
                    target: imgBall
                    sourceSize.width: 40
                    sourceSize.height: 40
                }
            },

            State {
                name: "SELECTED"
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "SELECTED"
                // reversible: true
                SequentialAnimation {
                    id: sqAnim
                    loops: Animation.Infinite
                    property int duration: 500

                    // NumberAnimation {
                        // target: imgBall
                        // property: "width"
                        // from: 40
                        // to: 50
                            // duration: 1000
                            // easing.type: Easing.InOutQuad
                    // }

                    ParallelAnimation {
                        NumberAnimation {
                            target: imgBall
                            property: "y"
                            from: 25
                            to: 10 // 50/2
                            duration: sqAnim.duration
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: imgBall
                            property: "width"
                            from: 50
                            to: 40
                            duration: sqAnim.duration
                            easing.type: Easing.InOutQuad
                        }
                    }

                    ParallelAnimation {
                        NumberAnimation {
                            target: imgBall
                            property: "y"
                            from: 10
                            to: 25 // 50/2
                            duration: sqAnim.duration
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            target: imgBall
                            property: "width"
                            from: 40
                            to: 50
                            duration: sqAnim.duration
                            easing.type: Easing.InOutQuad
                        }
                    }

                    // NumberAnimation {
                        // target: imgBall
                        // property: "width"
                        // from: 50
                        // to: 40
                        // duration: 1000
                        // easing.type: Easing.InOutQuad
                    // }
                }

            }
        ]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            ball.clicked("")
            // ballState = ballState ? 0 : 1
        }
    }

}
