.pragma library

function getPathBall(ballValue) {
    if (ballValue === 0) return "qrc:/res/ball_blue.png";
    if (ballValue === 1) return "qrc:/res/ball_blue_light.png";
    if (ballValue === 2) return "qrc:/res/ball_green.png";
    if (ballValue === 3) return "qrc:/res/ball_green_light.png";
    if (ballValue === 4) return "qrc:/res/ball_red.png";
    if (ballValue === 5) return "qrc:/res/ball_red_light.png";
    if (ballValue === 6) return "qrc:/res/ball_white_light.png";
    if (ballValue === 7) return "qrc:/res/ball_yellow.png";
    return ""
}

function getPosition(r, c) {
    return r*9 + c
}
