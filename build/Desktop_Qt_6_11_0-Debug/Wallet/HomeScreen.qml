import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent
    property var stack

    // ── Background accents ──
    Rectangle {
        width: 250; height: 250; radius: 125
        color: "#6C63FF"; opacity: 0.06
        x: parent.width - 100; y: -80
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 0

        // ── Header ──
        RowLayout {
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 2
                Text {
                    text: "Hello, " + wallet.username + " 👋"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }
                Text {
                    text: "Manage your wallet"
                    font.pixelSize: 13
                    color: "#9090B0"
                }
            }

            Item { Layout.fillWidth: true }

            // Logout button
            Rectangle {
                width: 40; height: 40; radius: 12
                color: "#1A1A2E"
                border.color: "#2A2A3E"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "⏻"
                    font.pixelSize: 18
                    color: "#FF5252"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: wallet.logout()
                }
            }
        }

        Item { Layout.preferredHeight: 28 }

        // ── Balance Card ──
        Rectangle {
            Layout.fillWidth: true
            height: 160
            radius: 24
            color: "#6C63FF"

            // Inner glow
            Rectangle {
                width: 180; height: 180; radius: 90
                color: "#FFFFFF"; opacity: 0.06
                x: parent.width - 60; y: -40
            }
            Rectangle {
                width: 120; height: 120; radius: 60
                color: "#FFFFFF"; opacity: 0.04
                x: -30; y: parent.height - 60
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 28
                spacing: 4

                Text {
                    text: "Total Balance"
                    font.pixelSize: 13
                    color: "#FFFFFF"
                    opacity: 0.75
                }

                Text {
                    text: "$" + wallet.balance.toFixed(2)
                    font.pixelSize: 38
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                }

                Item { Layout.fillHeight: true }

                Text {
                    text: "● Active Account"
                    font.pixelSize: 12
                    color: "#FFFFFF"
                    opacity: 0.6
                }
            }
        }

        Item { Layout.preferredHeight: 28 }

        // ── Quick Actions ──
        Text {
            text: "Quick Actions"
            font.pixelSize: 15
            font.weight: Font.Medium
            color: "#9090B0"
        }

        Item { Layout.preferredHeight: 12 }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Deposit
            Rectangle {
                Layout.fillWidth: true
                height: 90; radius: 18
                color: "#1A1A2E"
                border.color: "#2A2A3E"; border.width: 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "⬆"
                        font.pixelSize: 22
                        color: "#4CAF50"
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Deposit"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#FFFFFF"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: stack.push("qrc:/TransactionScreen.qml",
                                         { stack: root.stack, mode: "deposit" })
                }
            }

            // Withdraw
            Rectangle {
                Layout.fillWidth: true
                height: 90; radius: 18
                color: "#1A1A2E"
                border.color: "#2A2A3E"; border.width: 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "⬇"
                        font.pixelSize: 22
                        color: "#FF6584"
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Withdraw"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#FFFFFF"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: stack.push("qrc:/TransactionScreen.qml",
                                         { stack: root.stack, mode: "withdraw" })
                }
            }

            // Transfer
            Rectangle {
                Layout.fillWidth: true
                height: 90; radius: 18
                color: "#1A1A2E"
                border.color: "#2A2A3E"; border.width: 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "↗"
                        font.pixelSize: 22
                        color: "#6C63FF"
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Transfer"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#FFFFFF"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: stack.push("qrc:/TransactionScreen.qml",
                                         { stack: root.stack, mode: "transfer" })
                }
            }
        }

        Item { Layout.preferredHeight: 28 }

        // ── Transaction History ──
        Text {
            text: "Recent Transactions"
            font.pixelSize: 15
            font.weight: Font.Medium
            color: "#9090B0"
        }

        Item { Layout.preferredHeight: 12 }

        // History List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10
            model: wallet.getHistory().reverse()

            delegate: Rectangle {
                width: ListView.view.width
                height: 64
                radius: 14
                color: "#1A1A2E"
                border.color: "#2A2A3E"; border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 14

                    // Icon
                    Rectangle {
                        width: 38; height: 38; radius: 11
                        color: {
                            if (modelData.type === "Deposit")  return "#1A3A1A"
                            if (modelData.type === "Withdrawal") return "#3A1A1A"
                            return "#1A1A3A"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: {
                                if (modelData.type === "Deposit")    return "⬆"
                                if (modelData.type === "Withdrawal") return "⬇"
                                return "↗"
                            }
                            font.pixelSize: 16
                            color: {
                                if (modelData.type === "Deposit")    return "#4CAF50"
                                if (modelData.type === "Withdrawal") return "#FF5252"
                                return "#6C63FF"
                            }
                        }
                    }

                    // Type + Date
                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: modelData.type
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "#FFFFFF"
                        }
                        Text {
                            text: modelData.date
                            font.pixelSize: 12
                            color: "#9090B0"
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Amount
                    Text {
                        text: (modelData.type === "Deposit" ? "+" : "-") +
                              "$" + modelData.amount.toFixed(2)
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        color: modelData.type === "Deposit" ? "#4CAF50" : "#FF5252"
                    }
                }
            }

            // Empty state
            Text {
                anchors.centerIn: parent
                text: "No transactions yet"
                font.pixelSize: 14
                color: "#555570"
                visible: parent.count === 0
            }
        }
    }
}