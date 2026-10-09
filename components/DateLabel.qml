/*
 * Date component
 * Format: dddd MMMM d, yyyy
 */
import QtQuick

Rectangle {
    id: mainDate
    color: mainDate.bgColor
    radius: 25
    
    property int padX: 32
    property int padY: 18
    property color bgColor: "#99151A26"
    property color textColor: "#CDD6F4"

    implicitWidth: textItem.implicitWidth + padX * 2
    implicitHeight: textItem.implicitHeight + padY * 2

    property string fontFamily: "Rubik"
    property string dateStr: ""

    function getDate() {
        var date = new Date();
        dateStr = Qt.formatDate(date, "dddd, MMM dd");
    }

    Component.onCompleted: {
        getDate();
    }

    Text {
        id: textItem
        text: mainDate.dateStr
        color: mainDate.textColor
        font.pixelSize: 24
        font.weight: Font.Medium
        font.family: mainDate.fontFamily
        anchors.centerIn: parent
    }
}
