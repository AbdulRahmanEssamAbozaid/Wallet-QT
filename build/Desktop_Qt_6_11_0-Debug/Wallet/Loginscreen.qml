import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent
    property var stack

    // ── Background gradient circles (decoration) ──
    Rectangle {
        width: 300; height: 300
        radius: 150
        color: "#6C63FF"
        opacity: 0.08
        x: -80; y: -80
    }
    Rectangle {
        width: 200; height: 200
        radius: 100
        color: "#FF6584"
        opacity: 0.07
        x: parent.width - 120
        y: parent.height - 200
    }

    // ── Content ──
    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.82
        spacing: 0

        // Logo / Icon
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 80; height: 80
            radius: 24
            color: "#6C63FF"

            Text {
                anchors.centerIn: parent
                text: "💳"
                font.pixelSize: 36
            }

            layer.enabled: true
            layer.effect: null
        }

        Item { Layout.preferredHeight: 24 }

        // Title
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Wallet"
            font.pixelSize: 32
            font.weight: Font.Bold
            color: "#FFFFFF"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Sign in or create a new account"
            font.pixelSize: 14
            color: "#9090B0"
        }

        Item { Layout.preferredHeight: 40 }

        // ── Username Field ──
        Text {
            text: "Username"
            font.pixelSize: 13
            color: "#9090B0"
        }
        Item { Layout.preferredHeight: 6 }
        Rectangle {
            Layout.fillWidth: true
            height: 52
            radius: 14
            color: "#1A1A2E"
            border.color: usernameField.activeFocus ? "#6C63FF" : "#2A2A3E"
            border.width: usernameField.activeFocus ? 2 : 1

            Behavior on border.color { ColorAnimation { duration: 150 } }

            TextField {
                id: usernameField
                anchors.fill: parent
                anchors.margins: 4
                placeholderText: "Enter your username"
                placeholderTextColor: "#555570"
                color: "#FFFFFF"
                font.pixelSize: 15
                background: Item {}
                leftPadding: 16
                verticalAlignment: TextInput.AlignVCenter
            }
        }

        Item { Layout.preferredHeight: 16 }

        // ── Password Field ──
        Text {
            text: "Password"
            font.pixelSize: 13
            color: "#9090B0"
        }
        Item { Layout.preferredHeight: 6 }
        Rectangle {
            Layout.fillWidth: true
            height: 52
            radius: 14
            color: "#1A1A2E"
            border.color: passwordField.activeFocus ? "#6C63FF" : "#2A2A3E"
            border.width: passwordField.activeFocus ? 2 : 1

            Behavior on border.color { ColorAnimation { duration: 150 } }

            TextField {
                id: passwordField
                anchors.fill: parent
                anchors.margins: 4
                placeholderText: "Enter your password"
                placeholderTextColor: "#555570"
                color: "#FFFFFF"
                font.pixelSize: 15
                echoMode: TextInput.Password
                background: Item {}
                leftPadding: 16
                verticalAlignment: TextInput.AlignVCenter
                onAccepted: loginBtn.clicked()
            }
        }

        Item { Layout.preferredHeight: 12 }

        // ── Error / Info Message ──
        Text {
            id: msgText
            Layout.fillWidth: true
            text: wallet.message
            font.pixelSize: 13
            color: wallet.message.startsWith("Welcome") || wallet.message.startsWith("Account")
                   ? "#4CAF50" : "#FF5252"
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            visible: wallet.message !== ""
        }

        Item { Layout.preferredHeight: 24 }

        // ── Login Button ──
        Rectangle {
            id: loginBtn
            Layout.fillWidth: true
            height: 54
            radius: 16
            color: loginMouse.pressed ? "#5550DD" : "#6C63FF"

            Behavior on color { ColorAnimation { duration: 100 } }

            Text {
                anchors.centerIn: parent
                text: "Continue"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: "#FFFFFF"
            }

            MouseArea {
                id: loginMouse
                anchors.fill: parent
                onClicked: {
                    if (usernameField.text.trim() === "" || passwordField.text === "") {
                        return
                    }
                    wallet.login(usernameField.text.trim(), passwordField.text)
                }
            }
        }
    }
}