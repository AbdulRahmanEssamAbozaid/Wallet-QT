import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 420
    height: 780
    visible: true
    title: "Wallet App"

    // ── Colors (Design System) ──
    readonly property color bgColor:      "#0F0F1A"
    readonly property color cardColor:    "#1A1A2E"
    readonly property color accentColor:  "#6C63FF"
    readonly property color accent2Color: "#FF6584"
    readonly property color textPrimary:  "#FFFFFF"
    readonly property color textSecondary:"#9090B0"
    readonly property color successColor: "#4CAF50"
    readonly property color errorColor:   "#FF5252"

    background: Rectangle { color: root.bgColor }

    // ── Stack Navigation ──
    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: loginScreen

        pushEnter: Transition {
            PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
            PropertyAnimation { property: "x"; from: 60; to: 0; duration: 250; easing.type: Easing.OutCubic }
        }
        pushExit: Transition {
            PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
        }
        popEnter: Transition {
            PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: 250 }
        }
        popExit: Transition {
            PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: 200 }
            PropertyAnimation { property: "x"; from: 0; to: 60; duration: 250; easing.type: Easing.InCubic }
        }
    }

    // ── Screen Components ──
    Component { id: loginScreen;       LoginScreen       { stack: stackView } }
    Component { id: homeScreen;        HomeScreen        { stack: stackView } }
    Component { id: transactionScreen; TransactionScreen { stack: stackView } }

    // ── Global: لما الـ login ينجح روح على HomeScreen ──
    Connections {
        target: wallet
        function onUserChanged() {
            if (wallet.loggedIn && stackView.depth === 1) {
                stackView.push(homeScreen)
            }
            if (!wallet.loggedIn && stackView.depth > 1) {
                stackView.pop(null)
            }
        }
    }
}