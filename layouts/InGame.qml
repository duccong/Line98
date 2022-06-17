import QtQuick 2.0
import "../utils"

Item {
    anchors.fill: parent
    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/res/bkg.bmp"
    }

    Item {
        id: boardGame
        width: 630//parent.width
        height: 630//parent.height - 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2

        MouseArea {
            anchors.fill: parent

            onMouseXChanged: {
                console.log("x: ", mouseX, " - y: ", mouseY)
            }

            onClicked: {
                console.log("x: ", mouseX, " - y: ", mouseY)
                console.log("Clicked on: r = "
                            , Math.max(0,Math.floor((mouseY )/ 70))
                            , " - c = "
                            , Math.max(0,Math.floor((mouseX )/ 70)))
                findShortestPath(1, 9)
            }
        }

        Repeater {
            id: ballModel
            model: 9*9

            delegate: Ball {
                visible: ballValue !== -1
                x: (index % 9) * 70
                y: Math.floor(index / 9) * 70
                ballValue: x == y ? 1 : -1
                // Nulo {

                // }
                Component.onCompleted: {
                    // ballState = _SELECTED
                }

            }
        }
    }

    function findShortestPath(from, to) {
        console.log("from: ", from, " -> to: ", to)
        var r = [-1, 0, 1 , 0]
        var c = [0 ,-1, 0 , 1]

        let total = ballModel.count

        let distances = []
        let visited = {}

        let prev = []
        let pq = []

        for (var index = 0; index < 9*9; index++) {
                prev[index] = -1
                visited[index] = 0
                distances[index] = -1
        }

        pq.push(from)
        distances[from] = 0
        visited[from] = 0
        prev[from] = from

        let found = false
        let tmpPos = -1
        while (pq.length > 0 && found === false) {
            let minVal = pq.shift()
            visited[minVal] = 1
            let x = Math.floor(minVal / 9)
            let y = (minVal % 9)

            for (let i = 0; i < 4; i++) {
                let tmpX = x + r[i]
                let tmpY = y + c[i]
                if (tmpX < 0
                        || tmpX > 8
                        || tmpY < 0
                        || tmpY > 8)
                {
                    continue
                }

                tmpPos = tmpY + tmpX * 9
                console.log("tmpPosX: ", tmpX, ",", tmpY, " >> ", ballModel.itemAt(tmpPos).ballValue)
                if (ballModel.itemAt(tmpPos).ballValue === -1) {
                    let alt = distances[minVal] + 1
                    console.log("visited(",tmpPos,") = ", visited[tmpPos])
                    if (visited[tmpPos] === 0) {
                        pq.push(tmpPos)
                        console.log("Pushed", tmpPos)
                        // ballModel.itemAt(tmpPos).ballValue = 1
                        visited[tmpPos] = 1
                        distances[tmpPos] = alt
                        prev[tmpPos] = minVal
                    } else {
                        if (alt < distances[tmpPos]) {
                            distances[tmpPos] = alt
                            prev[tmpPos] = minVal
                        }
                    }
                    if (tmpPos === to) {
                        found = true
                        break;
                    }
                }
            }
        }

        console.log(">>> END: found: ", found)
        if (found) {
            tmpPos = to
            while (prev[tmpPos] !== tmpPos) {
                ballModel.itemAt(tmpPos).ballValue = 1
                tmpPos = prev[tmpPos]
            }
            ballModel.itemAt(tmpPos).ballValue = 1
        }

    }

}
