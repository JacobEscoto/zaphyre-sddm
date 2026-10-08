import QtQuick

Item {
    id: clock

    property string backgroundSource: ""
    property color defaultTimeColor: config.textColor
    property string fontFamily: "Rubik"
    property string timeStr: ""

    function updateTime() {
        var date = new Date();
        var hours = date.getHours();
        var mins = date.getMinutes();

        // If 24-hour is not true, transform to 12-hour format
        if (config.use24HourClock !== "true") {
            hours = hours % 12;
            if (hours === 0) {
                hours = 12;
            }
        }

        var hrStr = hours < 10 ? "0" + hours : "" + hours;
        var minStr = mins < 10 ? "0" + mins : "" + mins;

        clock.timeStr = hrStr + minStr;
    }

    Component.onCompleted: {
        updateTime();
    }

    Row {
        anchors.centerIn: parent
        spacing: 10

        Column {
            spacing: -70
            Text {
                text: clock.timeStr.substring(0, 2)
                color: clock.defaultTimeColor
                font.pixelSize: 200
                font.family: clock.fontFamily
                font.weight: Font.Bold
                width: 130
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
            Text {
                text: clock.timeStr.slice(-2)
                color: clock.defaultTimeColor
                font.pixelSize: 200
                font.family: clock.fontFamily
                font.weight: Font.Bold
                width: 130
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }
}
