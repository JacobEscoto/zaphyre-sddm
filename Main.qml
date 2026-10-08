import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "components"

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: config.backgroundColor

    //Fonts (Rubik)
    FontLoader {
        id: rubikRegular
        source: "assets/fonts/Rubik/Rubik-Regular.ttf"
    }

    FontLoader {
        id: rubikMedium
        source: "assets/fonts/Rubik/Rubik-Medium.ttf"
    }

    FontLoader {
        id: rubikBold
        source: "assets/fonts/Rubik/Rubik-Bold.ttf"
    }

    readonly property string rubikRegularFont: rubikRegular.name !== "" ? rubikRegular.name : "Roboto, Inter, sans-serif"
    readonly property string rubikMediumFont: rubikMedium.name !== "" ? rubikMedium.name : "Roboto, Inter, sans-serif"
    readonly property string rubikBoldFont: rubikBold.name !== "" ? rubikBold.name : "Roboto, Inter, sans-serif"

    Image {
        id: backgroundImage
        source: config.background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
    }

    FastBlur {
        anchors.fill: backgroundImage
        source: backgroundImage
        radius: 64
        transparentBorder: false
    }

    Column {
        id: mainContainer
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.verticalCenter: parent.verticalCenter
        spacing: 24

        Clock {
            id: mainClock
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundSource: config.background
            fontFamily: root.rubikBoldFont
        }

        DateLabel {
            id: mainDate
            anchors.horizontalCenter: parent.horizontalCenter
            fontFamily: root.rubikMediumFont
        }
    }
}
