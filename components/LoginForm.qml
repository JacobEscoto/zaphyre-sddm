import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: container
    implicitWidth: 380
    implicitHeight: 220

    property color accentColor: "#4169E1"
    property color cardBgColor: "#99151a26"
    property color inputBgColor: "#990f121b"
    property color inputBorderColor: "#2a3958"
    property color inputBorderActiveColor: "#5c82f2"
    property color btnSecondaryBgColor: "#222c3d"
    property color btnPrimaryBgColor: "#2c3e6b"
    property color textPrimaryColor: "#ffffff"
    property color textSecondaryColor: "#8ea8f6"
    property color placeholderColor: "#4A5B82"
    property color warningColor: "#E0AF68"

    property int userIndex: 0
    property bool isLoggingIn: false
    property int sessionIndex: 0
    property var sessionNames: []

    Component.onCompleted: {
        if (typeof userModel !== "undefined" && userModel.lastIndex >= 0)
            userIndex = userModel.lastIndex;
        if (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0)
            sessionIndex = sessionModel.lastIndex;
    }

    // Saves the real name of each session
    Repeater {
        model: (typeof sessionModel !== "undefined") ? sessionModel : null

        delegate: Item {
            visible: false
            Component.onCompleted: {
                var arr = container.sessionNames.slice();
                arr[index] = model.name;
                container.sessionNames = arr;
            }
        }
    }

    function cleanName(name) {
        if (!name)
            return "";
        var s = name.toString();
        if (s.endsWith("/"))
            s = s.substring(0, s.length - 1);
        if (s.indexOf("/") !== -1)
            s = s.substring(s.lastIndexOf("/") + 1);
        if (s.indexOf(".desktop") !== -1)
            s = s.substring(0, s.indexOf(".desktop"));
        s = s.replace(/[-_]/g, ' ');
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

    function sessionName(i) {
        var n = container.sessionNames[i];
        return (n && String(n).trim() !== "") ? String(n).trim() : "Session";
    }

    function getCurrentUserName() {
        if (typeof userModel !== "undefined" && userModel.count > 0) {
            var idx = container.userIndex;
            var modelIdx = userModel.index(idx, 0);
            var display = userModel.data(modelIdx, Qt.DisplayRole);
            var edit = userModel.data(modelIdx, Qt.EditRole);
            var nr = userModel.data(modelIdx, Qt.UserRole + 1);
            var realName = userModel.data(modelIdx, Qt.UserRole + 2);
            var finalName = display ? display.toString() : (realName ? realName.toString() : (nr ? nr.toString() : (edit ? edit.toString() : "User")));
            return cleanName(finalName);
        }
        return cleanName(typeof sddm !== "undefined" && sddm.lastUser ? sddm.lastUser : "USER");
    }

    function doLogin() {
        if (isLoggingIn)
            return;

        var user = "";
        if (typeof userModel !== "undefined" && userModel.count > 0) {
            var idx = container.userIndex;
            if (idx < 0 || idx >= userModel.count)
                idx = 0;

            var edit = userModel.data(userModel.index(idx, 0), Qt.EditRole);
            var nameRole = userModel.data(userModel.index(idx, 0), Qt.UserRole + 1);
            var display = userModel.data(userModel.index(idx, 0), Qt.DisplayRole);

            user = edit ? edit.toString() : (nameRole ? nameRole.toString() : (display ? display.toString() : ""));
        }

        if (!user || user === "" || user === "User") {
            user = typeof sddm !== "undefined" ? sddm.lastUser : "";
        }

        if (!user && typeof userModel !== "undefined" && userModel.count > 0) {
            var firstEdit = userModel.data(userModel.index(0, 0), Qt.EditRole);
            user = firstEdit ? firstEdit.toString() : "";
        }

        if (!user)
            return;

        container.isLoggingIn = true;
        var pass = passwordField.text;

        if (typeof sddm !== "undefined") {
            sddm.login(user.trim(), pass, container.sessionIndex);
        }
        loginTimeout.start();
    }

    Timer {
        id: loginTimeout
        interval: 5000
        onTriggered: container.isLoggingIn = false
    }

    Connections {
        target: typeof sddm !== "undefined" ? sddm : null
        function onLoginFailed() {
            container.isLoggingIn = false;
            loginTimeout.stop();
            passwordField.text = "";
            passwordField.forceActiveFocus();
        }
        function onLoginSucceeded() {
            loginTimeout.stop();
        }
    }

    // Login form: main card
    Rectangle {
        id: mainCard
        anchors.fill: parent
        color: container.cardBgColor
        radius: 20

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Image {
                  source: Qt.resolvedUrl("../assets/icons/user.svg")
                }

                // Username in upper case
                Text {
                    text: container.getCurrentUserName().toUpperCase()
                    color: container.textSecondaryColor
                    font.pixelSize: 11
                    font.bold: true
                    font.letterSpacing: 1.2
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            // Password field with pill style
            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                horizontalAlignment: Text.AlignHCenter
                echoMode: TextInput.Password
                font.pixelSize: 18
                color: container.textPrimaryColor
                enabled: !container.isLoggingIn
                placeholderText: "• • • • • •"
                placeholderTextColor: container.placeholderColor
                focus: true

                background: Rectangle {
                    color: container.inputBgColor
                    radius: passwordField.height / 2
                    border.width: passwordField.activeFocus ? 2 : 1
                    border.color: passwordField.activeFocus ? container.inputBorderActiveColor : container.inputBorderColor
                }

                onAccepted: container.doLogin()
            }

            // Indicator for Caps Lock / Num Lock
            Item {
                id: lockIndicator
                Layout.fillWidth: true
                Layout.preferredHeight: 12

                readonly property bool capsOn: typeof keyboard !== "undefined" && keyboard.capsLock === true
                readonly property bool numOn: typeof keyboard !== "undefined" && keyboard.numLock === true

                Text {
                    anchors.centerIn: parent
                    visible: lockIndicator.capsOn || lockIndicator.numOn
                    text: (lockIndicator.capsOn && lockIndicator.numOn)
                          ? "CAPS LOCK  ·  NUM LOCK ACTIVATED"
                          : (lockIndicator.capsOn ? "CAPS LOCK ACTIVATED" : "NUM LOCK ACTIVATED")
                    color: container.warningColor
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 1
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Button {
                    id: anotherUserButton
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    visible: typeof userModel !== "undefined" && userModel.count > 1

                    contentItem: Text {
                        text: "ANOTHER USER"
                        color: container.textSecondaryColor
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: anotherUserButton.pressed ? Qt.darker(container.btnSecondaryBgColor, 1.2) : container.btnSecondaryBgColor
                        radius: anotherUserButton.height / 2
                    }

                    onClicked: userPopup.open()
                }

                // Session selector (dropdown)
                Button {
                    id: sessionButton
                    Layout.preferredWidth: 96
                    Layout.preferredHeight: 42
                    visible: typeof sessionModel !== "undefined" && sessionModel.count > 1

                    contentItem: Text {
                        text: container.sessionName(container.sessionIndex).toUpperCase()
                        color: container.textSecondaryColor
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: sessionButton.pressed ? Qt.darker(container.btnSecondaryBgColor, 1.2) : container.btnSecondaryBgColor
                        radius: sessionButton.height / 2
                    }

                    onClicked: sessionPopup.open()
                }

                Button {
                    id: unlockButton
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42

                    contentItem: Text {
                        text: container.isLoggingIn ? "UNLOCKING..." : "UNLOCK"
                        color: container.textPrimaryColor
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: container.isLoggingIn ? container.btnSecondaryBgColor : (unlockButton.pressed ? Qt.darker(container.btnPrimaryBgColor, 1.2) : container.btnPrimaryBgColor)
                        radius: unlockButton.height / 2
                    }

                    onClicked: container.doLogin()
                }
            }
        }
    }

    Popup {
        id: userPopup
        width: 260
        height: (typeof userModel !== "undefined") ? Math.min(200, userModel.count * 40 + 20) : 100
        x: (parent ? (parent.width - width) / 2 : 0)
        y: (parent ? (parent.height - height) / 2 : 0)
        modal: true
        focus: true

        background: Rectangle {
            color: container.cardBgColor
            radius: 14
            border.color: container.inputBorderColor
            border.width: 1
        }

        ListView {
            id: userList
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof userModel !== "undefined") ? userModel : null
            spacing: 5
            clip: true
            currentIndex: container.userIndex

            delegate: ItemDelegate {
                width: parent.width
                height: 35

                background: Rectangle {
                    color: (index === container.userIndex) ? container.btnPrimaryBgColor : "transparent"
                    radius: 8
                }

                contentItem: Text {
                    text: {
                        var mIdx = userModel.index(index, 0);
                        var d = userModel.data(mIdx, Qt.DisplayRole);
                        var n_r = userModel.data(mIdx, Qt.UserRole + 1);
                        var r = userModel.data(mIdx, Qt.UserRole + 2);
                        var e = userModel.data(mIdx, Qt.EditRole);
                        return cleanName(d ? d : (r ? r : (n_r ? n_r : e)));
                    }
                    color: container.textPrimaryColor
                    font.pixelSize: 13
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    container.userIndex = index;
                    userPopup.close();
                }
            }
        }
    }

    Popup {
        id: sessionPopup
        width: 260
        height: (typeof sessionModel !== "undefined") ? Math.min(200, sessionModel.count * 40 + 20) : 100
        x: (parent ? (parent.width - width) / 2 : 0)
        y: (parent ? (parent.height - height) / 2 : 0)
        modal: true
        focus: true

        background: Rectangle {
            color: container.cardBgColor
            radius: 14
            border.color: container.inputBorderColor
            border.width: 1
        }

        ListView {
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof sessionModel !== "undefined") ? sessionModel : null
            spacing: 5
            clip: true

            delegate: ItemDelegate {
                width: parent.width
                height: 35

                background: Rectangle {
                    color: index === container.sessionIndex ? container.btnPrimaryBgColor : "transparent"
                    radius: 8
                }

                contentItem: Text {
                    text: model.name
                    color: container.textPrimaryColor
                    font.pixelSize: 13
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: {
                    container.sessionIndex = index;
                    sessionPopup.close();
                }
            }
        }
    }
}
