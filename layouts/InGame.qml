import QtQuick 2.0
import QtQml 2.12
import "../utils"
import "../MyScript.js" as MyScript

Item {
    id: container
    property var score: 0
    property var totalBall: 0
    property var fromPos: -1
    property var toPos: -1
    property var tracks
    anchors.fill: parent
    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/res/bkg.bmp"
    }

    Item {
        id: boardInfo
        width: 630 //parent.width
        height: 80
        Text {
            id: txtScore
            anchors.centerIn: parent
            width: 90
            height: 60
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "LightBLue"
            font.pixelSize: 48
            text: score
        }

        Text {
            id: resetText

            property bool isHighlighted: false

            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            width: 90
            height: 60
            text: "Reload\nTotal:" + totalBall
            font.pixelSize: 24
            color: !resetText.isHighlighted ? "LightBLue" : "Red"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // reset game
                    resetGame()
                }
            }

            Timer {
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    resetText.isHighlighted = !resetText.isHighlighted
                }
            }
        }

    }

    Item {
        id: boardGame
        width: 630//parent.width
        height: 630//parent.height - 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2

        MouseArea {
            anchors.fill: parent

            onClicked: {
                // console.log("x: ", mouseX, " - y: ", mouseY)
                if (fromPos === -1 || animPos.running) return;
                let r = Math.max(0,Math.floor((mouseY )/ 70))
                let c = Math.max(0,Math.floor((mouseX )/ 70))

                let posClicked = MyScript.getPosition(r, c)
                let to = posClicked
                console.log("posClicked:", posClicked)
                let from = fromPos
                tracks = findShortestPath(from, to)
                if (tracks.length > 0) {
                    toPos = to
                    // start animation
                    animPos.duration = Math.min(100,1000/tracks.length)
                    tracks.pop()
                    let nextPos = tracks.pop()
                    animPos.toX = (nextPos % 9) * 70
                    animPos.toY = Math.floor(nextPos / 9) * 70
                    animPos.start()
                }
            }
        }

        Repeater {
            id: ballModel
            model: 9*9

            delegate: Ball {
                id: item
                visible: ballValue !== -1 && index !== fromPos
                x: (index % 9) * 70
                y: Math.floor(index / 9) * 70
                ballValue: index % 8 //(index % 9) % 2 === 0 ? (index % 8) : -1
                ballState: _IDLE //index === fromPos ? _SELECTED : _IDLE

                onClicked: {
                    // ballState = ballState === _IDLE ? _SELECTED : _IDLE
                    if (animPos.running) return
                    fromPos = index
                }

                Component.onCompleted: {
                    if (ballValue !== -1) {
                        totalBall++;
                    }

                    // ballState = _SELECTED
                }
            }
        }

        Ball {
            id: runningBall

            property var ballData: container.fromPos === -1 ? undefined : ballModel.itemAt(fromPos)

            visible: ballData !== undefined //ballValue !== -1
            x: !runningBall.visible ? 0 : ballData.x //(index % 9) * 70
            y: !runningBall.visible ? 0 : ballData.y //Math.floor(index / 9) * 70
            ballValue: !runningBall.visible ? -1 : ballData.ballValue //x == y ? 1 : -1
            ballState: runningBall.visible ? _SELECTED : _IDLE
            // Nulo {

            // }
            Component.onCompleted: {
                // ballState = _SELECTED
            }


            ParallelAnimation {
                id: animPos
                property int toX: 0
                property int toY: 0
                property int duration: 100
                alwaysRunToEnd: true
                NumberAnimation {
                    id: animX
                    target: runningBall
                    property: "x"
                    to: animPos.toX
                    duration: animPos.duration
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    id: animY
                    target: runningBall
                    property: "y"
                    duration: animPos.duration
                    to: animPos.toY
                    easing.type: Easing.InOutQuad
                }

                onStopped: {
                    if (tracks.length > 0) {
                        // start next animation
                        let nextPos = tracks.pop()
                        animPos.toX = (nextPos % 9) * 70
                        animPos.toY = Math.floor(nextPos / 9) * 70
                        animPos.start()
                    } else {
                        ballModel.itemAt(toPos).ballValue = ballModel.itemAt(fromPos).ballValue
                        ballModel.itemAt(fromPos).ballValue = -1
                        calculationAt(toPos)
                        fromPos = -1
                        toPos = -1
                        var newBallCount = 1
                        generateNewBall(newBallCount)
                    }
                }
            }
        }
    }

    function resetGame() {
        ballModel.model = 0
        score = 0
        totalBall = 0
        fromPos = -1
        toPos = -1
        tracks = []
        ballModel.model = 9*9
    }

    function generateNewBall(n) {
        if (totalBall + n>= 9*9) {
            console.log("END GAME")
            return false
        }
        totalBall += n
        while (n > 0) {
            var rd = Math.floor(Math.random()*81);
            var checkBall = ballModel.itemAt(rd)
            if (checkBall.ballValue === -1) {
                n--;
                checkBall.ballValue = Math.floor(Math.random()*8)
            }
        }
        return true
    }

    function calculationAt(index) {
        var currentBallValue = ballModel.itemAt(index).ballValue
        // console.log("cal at: ", index, " - value: ", currentBallValue)
        let x = Math.floor(index / 9)
        let y = (index % 9)

        var r = [-1, 1]

        let checkLeftCol = true
        let checkLeftRow = true

        let checkRightCol = true
        let checkRightRow = true

        let checkLeftDiagonal1 = true //(left to right)
        let checkRightDiagonal1 = true

        let checkLeftDiagonal2 = true // right to left
        let checkRightDiagonal2 = true

        let minLeftCol = y
        let minLeftRow = x

        let minLeftDiagonal1 = x
        let minLeftDiagonal2 = x
        let rowVal = 1
        let colVal = 1
        let leftDiagonalVal1 = 1
        let leftDiagonalVal2 = 1
        for (var loop = 1; loop < 5; loop++) {
            // check row
            if (checkLeftRow) {
                var tmpX = x + r[0]*loop
                if (tmpX < 0
                        || tmpX > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(tmpX, y)).ballValue)
                {
                    checkLeftRow = false
                } else {
                    colVal++
                    minLeftRow = tmpX
                }
            }
            if (checkRightRow) {
                let tmpX = x + r[1]*loop
                if (tmpX < 0
                        || tmpX > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(tmpX, y)).ballValue)
                {
                    checkRightRow = false
                } else {
                    colVal++
                }
            }
            // check Col
            if (checkLeftCol) {
                var tmpY = y + r[0]*loop
                if (tmpY < 0
                        || tmpY > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(x, tmpY)).ballValue)
                {
                    checkLeftCol = false
                } else {
                    rowVal++
                    minLeftCol = tmpY
                }
            }
            if (checkRightCol) {
                let tmpY = y + r[1]*loop
                if (tmpY < 0
                        || tmpY > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(x, tmpY)).ballValue)
                {
                    checkRightCol = false
                } else {
                    rowVal++
                }
            }
            // check left diagonal 1
            if (checkLeftDiagonal1) {
                // var r = [-1, 1]
                tmpY = y + r[1]*loop
                tmpX = x + r[0]*loop
                if (tmpY < 0
                        || tmpY > 8
                        || tmpX < 0
                        || tmpX > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(tmpX, tmpY)).ballValue)
                {
                    checkLeftDiagonal1 = false
                } else {
                    leftDiagonalVal1++
                    minLeftDiagonal1 = tmpX
                }
            }
            if (checkRightDiagonal1) {
                tmpY = y + r[0]*loop
                tmpX = x + r[1]*loop
                if (tmpY < 0
                        || tmpY > 8
                        || tmpX < 0
                        || tmpX > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(tmpX, tmpY)).ballValue)
                {
                    checkRightDiagonal1 = false
                } else {
                    leftDiagonalVal1++
                }
            }
            // check left diagonal 2
            if (checkLeftDiagonal2) {
                // var r = [-1, 1]
                tmpY = y + r[0]*loop
                tmpX = x + r[0]*loop
                if (tmpY < 0
                        || tmpY > 8
                        || tmpX < 0
                        || tmpX > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(tmpX, tmpY)).ballValue)
                {
                    checkLeftDiagonal2 = false
                } else {
                    leftDiagonalVal2++
                    minLeftDiagonal2 = tmpX
                }
            }
            if (checkRightDiagonal2) {
                tmpY = y + r[1]*loop
                tmpX = x + r[1]*loop
                if (tmpY < 0
                        || tmpY > 8
                        || tmpX < 0
                        || tmpX > 8
                        || currentBallValue !== ballModel.itemAt(MyScript.getPosition(tmpX, tmpY)).ballValue)
                {
                    checkRightDiagonal2 = false
                } else {
                    leftDiagonalVal2++
                }
            }

        }

        // console.log("col: ", colVal, " - minLeftRow: ", minLeftRow)
        // console.log("row: ", rowVal, " - minLeftCol: ", minLeftCol)
        // console.log("diagonal1: ", leftDiagonalVal1, " - minLeftCol: ", minLeftDiagonal1)
        // console.log("diagonal2: ", leftDiagonalVal2, " - minLeftCol: ", minLeftDiagonal2)

        if (colVal >= 5) {
            score += colVal*colVal
            for (loop = minLeftRow; loop < minLeftRow + colVal ; loop++) {
                ballModel.itemAt(MyScript.getPosition(loop, y)).ballValue = -1
            }
            totalBall -= colVal
        }

        if (rowVal >= 5) {
            score += rowVal*rowVal
            for (loop = minLeftCol; loop < minLeftCol + rowVal ; loop++) {
                ballModel.itemAt(MyScript.getPosition(x, loop)).ballValue = -1
            }
            totalBall -= rowVal
        }

        if (leftDiagonalVal1 >=5) {
            score += leftDiagonalVal1*leftDiagonalVal1
            tmpX = minLeftDiagonal1
            tmpY = y + x - minLeftDiagonal1
            // console.log("tmpX: ", tmpX, ", tmpY:", tmpY)
            for (loop = 0; loop < leftDiagonalVal1 ; loop++) {
                ballModel.itemAt(MyScript.getPosition(tmpX + loop, tmpY - loop)).ballValue = -1
            }
            totalBall -= leftDiagonalVal1
        }

        if (leftDiagonalVal2 >=5) {
            score += leftDiagonalVal2*leftDiagonalVal2
            tmpX = minLeftDiagonal2
            tmpY = y - (x - minLeftDiagonal2)
            // console.log("tmpX: ", tmpX, ", tmpY:", tmpY)
            for (loop = 0; loop < leftDiagonalVal2 ; loop++) {
                ballModel.itemAt(MyScript.getPosition(tmpX + loop, tmpY + loop)).ballValue = -1
            }
            totalBall -= leftDiagonalVal2
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
                // console.log("tmpPosX: ", tmpX, ",", tmpY, " >> ", ballModel.itemAt(tmpPos).ballValue)
                if (ballModel.itemAt(tmpPos).ballValue === -1) {
                    let alt = distances[minVal] + 1
                    // console.log("visited(",tmpPos,") = ", visited[tmpPos])
                    if (visited[tmpPos] === 0) {
                        pq.push(tmpPos)
                        // console.log("Pushed", tmpPos)
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

        // console.log(">>> END: found: ", found)
        if (!found) {
            prev.length = 0
        }
        console.log(">>> END: prevTrack: ", prev.length)

        // return prev
        let path = []

        if (found) {
            tmpPos = to
            path.push(tmpPos)
            while (prev[tmpPos] !== tmpPos) {
                tmpPos = prev[tmpPos]
                path.push(tmpPos)
            }
        }
        return path//.reverse()

    }

}
