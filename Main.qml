import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "components"

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: root.bgColor

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

    function themeColor(key, fallback) {
      var value = (typeof config !== "undefined" && config !== null) ? config[key] : undefined;

      if (value === undefined || value === null || String(value).trim() === "") {
        console.warn("[theme] '" + key + "' undefined at theme.conf, using " + fallback);
        return fallback;
      }

      var str = String(value).trim();
      if (!/^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/.test(str)) {
        console.warn("[theme] '" + key  + "' has invalid format (" + str + "), using " + fallback);
        return fallback;
      }
      return str;
    }

    readonly property color accentColor: themeColor("accentColor", "#4169E1")
    readonly property color bgColor: themeColor("backgroundColor", "#00001A")
    readonly property color txtPrimaryColor: themeColor("textPrimaryColor", "#CDD6F4")
    readonly property color txtSecondaryColor: themeColor("textSecondaryColor", "#FFFFFF")
    readonly property color txtTertiaryColor: themeColor("textTertiaryColor", "#8EA8F6")

    readonly property color placeholderColor: themeColor("placeholderColor", "#4A5B82")
    readonly property color warnColor: themeColor("warnColor", "#E0AF68")

    readonly property color cardBgColor: themeColor("cardBgColor", "#99151A26")
    readonly property color inputBgColor: themeColor("inputBgColor", "#990F121B")

    readonly property color inputBorderColor: themeColor("inputBorderColor", "#2A3958")
    readonly property color inputBorderActiveColor: themeColor("inputBorderActiveColor", "#5C82F2")

    readonly property color btnPrimaryBgColor: themeColor("btnPrimaryBgColor", "#2C3E6B")
    readonly property color btnSecondaryBgColor: themeColor("btnSecondaryBgColor", "#222C3D")


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
        id: leftContainer
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.verticalCenter: parent.verticalCenter
        spacing: 24

        Clock {
            id: mainClock
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundSource: config.background
            fontFamily: root.rubikBoldFont
            timeColor: root.txtPrimaryColor
        }

        DateLabel {
            id: mainDate
            anchors.horizontalCenter: parent.horizontalCenter
            fontFamily: root.rubikMediumFont
            bgColor: root.cardBgColor
            textColor: root.txtPrimaryColor
        }
    }

    // Settings + Login Form
    Column {
        id: middleContainer
        anchors.left: leftContainer.right
        anchors.leftMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18

        Text {
            id: settingsLabel
            opacity: 0.85
            text: "SETTINGS"
            color: root.txtPrimaryColor
            font.pixelSize: 16
            font.weight: Font.Medium
            font.family: root.rubikMediumFont
        }

        LoginForm {
            id: loginForm
            accentColor: root.accentColor
            cardBgColor: root.cardBgColor
            
            inputBgColor: root.inputBgColor
            inputBorderColor: root.inputBorderColor
            inputBorderActiveColor: root.inputBorderActiveColor
            placeholderColor: root.placeholderColor
            
            btnPrimaryBgColor: root.btnPrimaryBgColor
            btnSecondaryBgColor: root.btnSecondaryBgColor
            
            textPrimaryColor: root.txtSecondaryColor
            textSecondaryColor: root.txtTertiaryColor
            warningColor: root.warnColor


        }
    }
}
