import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent
    property var    stack
    property string mode: "deposit"   // "deposit" | "withdraw" | "transfer"

    // ── Helpers ──
    readonly property string modeTitle: {
        if (mode === "deposit")  return "Deposit"
        if (mode === "withdraw") return "Withdraw"
        return "Transfer"
    }
    readonly property string modeIcon: {
        if (mode === "deposit")  return "⬆"
        if (mode === "withdraw") return "⬇"
        return "↗"
    }
    readonly property color modeColor: {
        if (mode === "deposit")  return "#4CAF50"
        if (mode === "withdraw") return "#FF5252"
        return "#6C63FF"
    }

    // ── Background accent ──
    Rectangle {
        width: 220; height: 220; radius: 110
        color: root.modeColor; opacity: 0.07
        x: parent.width - 80; y: -60
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 0

        // ── Header ──
        RowLayout {
            Layout.fillWidth: true

            // Back button
            Rectangle {
                width: 40; height: 40; radius: 12
                color: "#1A1A2E"
                border.color: "#2A2A3E"; border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    font.pixelSize: 20
                    color: "#FFFFFF"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: stack.pop()
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: modeTitle
                font.pixelSize: 20
                font.weight: Font.Bold
                color: "#FFFFFF"
            }

            Item { Layout.fillWidth: true }
            Item { width: 40 }
        }

        Item { Layout.preferredHeight: 40 }

        // ── Mode Icon ──
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 80; height: 80; radius: 24
            color: Qt.rgba(root.modeColor.r, root.modeColor.g, root.modeColor.b, 0.15)
            border.color: root.modeColor; border.width: 1.5

            Text {
                anchors.centerIn: parent
                text: root.modeIcon
                font.pixelSize: 34
                color: root.modeColor
            }
        }

        Item { Layout.preferredHeight: 8 }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Current balance: $" + wallet.balance.toFixed(2)
            font.pixelSize: 13
            color: "#9090B0"
        }

        Item { Layout.preferredHeight: 36 }

        // ── Transfer: Recipient field ──
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: root.mode === "transfer"

            Text {
                text: "Recipient username"
                font.pixelSize: 13
                color: "#9090B0"
            }

            Rectangle {
                Layout.fillWidth: true
                height: 52; radius: 14
                color: "#1A1A2E"
                border.color: recipientField.activeFocus ? "#6C63FF" : "#2A2A3E"
                border.width: recipientField.activeFocus ? 2 : 1
                Behavior on border.color { ColorAnimation { duration: 150 } }

                TextField {
                    id: recipientField
                    anchors.fill: parent; anchors.margins: 4
                    placeholderText: "e.g. john"
                    placeholderTextColor: "#555570"
                    color: "#FFFFFF"
                    font.pixelSize: 15
                    background: Item {}
                    leftPadding: 16
                    verticalAlignment: TextInput.AlignVCenter
                }
            }
        }

        Item {
            Layout.preferredHeight: 16
            visible: root.mode === "transfer"
        }

        // ── Amount field ──
        Text {
            text: "Amount"
            font.pixelSize: 13
            color: "#9090B0"
        }

        Item { Layout.preferredHeight: 6 }

        Rectangle {
            Layout.fillWidth: true
            height: 52; radius: 14
            color: "#1A1A2E"
            border.color: amountField.activeFocus ? root.modeColor : "#2A2A3E"
            border.width: amountField.activeFocus ? 2 : 1
            Behavior on border.color { ColorAnimation { duration: 150 } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 12
                spacing: 8

                Text {
                    text: "$"
                    font.pixelSize: 16
                    font.weight: Font.Medium
                    color: "#9090B0"
                }

                TextField {
                    id: amountField
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    placeholderText: "0.00"
                    placeholderTextColor: "#555570"
                    color: "#FFFFFF"
                    font.pixelSize: 18
                    font.weight: Font.Medium
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    background: Item {}
                    verticalAlignment: TextInput.AlignVCenter
                }
            }
        }

        Item { Layout.preferredHeight: 12 }

        // ── Message ──
        Text {
            Layout.fillWidth: true
            text: wallet.message
            font.pixelSize: 13
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            color: wallet.message.includes("success") || wallet.message.includes("Transfer") ||
                   wallet.message.includes("Deposit") || wallet.message.includes("Withdrawn")
                   ? "#4CAF50" : "#FF5252"
            visible: wallet.message !== ""
        }

        Item { Layout.fillHeight: true }

        // ── Confirm Button ──
        Rectangle {
            Layout.fillWidth: true
            height: 54; radius: 16
            color: confirmMouse.pressed
                   ? Qt.darker(root.modeColor, 1.2)
                   : root.modeColor

            Behavior on color { ColorAnimation { duration: 100 } }

            Text {
                anchors.centerIn: parent
                text: "Confirm " + root.modeTitle
                font.pixelSize: 16
                font.weight: Font.Medium
                color: "#FFFFFF"
            }

            MouseArea {
                id: confirmMouse
                anchors.fill: parent
                onClicked: {
                    var amount = parseFloat(amountField.text)
                    if (isNaN(amount) || amount <= 0) return

                    var ok = false
                    if (root.mode === "deposit")  ok = wallet.deposit(amount)
                    if (root.mode === "withdraw") ok = wallet.withdraw(amount)
                    if (root.mode === "transfer") ok = wallet.transfer(recipientField.text.trim(), amount)

                    if (ok) {
                        amountField.text = ""
                        recipientField.text = ""
                    }
                }
            }
        }

        Item { Layout.preferredHeight: 16 }
    }
}