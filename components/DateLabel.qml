/*
 * Date component
 * Format: dddd MMMM d, yyyy
 */
import QtQuick

Rectangle {
    id: mainDate
    color: "#99181518"
    radius: 25
    property int padX: 32
    property int padY: 18
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
        color: config.textColor
        font.pixelSize: 24
        font.weight: Font.Medium
        font.family: mainDate.fontFamily
        anchors.centerIn: parent
    }
}
