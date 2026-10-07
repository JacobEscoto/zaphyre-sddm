import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root
  implicitWidth: 260
  implicitHeight: 180
  color: "#000407"
  radius: 18

  property string username: typeof userModel !== "undefined" && userModel.lastUser ? userModel.lasUser : "Jacob"

  function getGreeting() {
    var hour = new Date().getHours();
    if (hour >= 5 && hour < 12) {
      return "Good morning,";
    } else if (hour >= 12 && hour <= 18) {
      return "Good afternoon,";
    } else {
      return "Good night,";
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 12

    ColumnLayout {
      spacing: 2

      Text {
        text: root.getGreeting()
        color: "#C0CAF5"
        font.family: "Rubik"
        font.pixelSize: 16
      }

      Text {
        text: root.username
        color: "#7AA2F7"
        font.family: "Rubik"
        font.bold: true
        font.pixelSize: 22
        elide: Text.ElideRight
        Layout.fillWidth: true
      }
    }
  }
}
