import QtQuick 2.2
import QtQuick.Controls 1.2
import FlatUI 1.0
import "content"

ApplicationWindow {
    id: appWindow

    visible: true
    width: 800
    height: 1280

    property string current_page

    FlatConstants {
        id: flatConstants
    }

    Rectangle {
        color: flatConstants.concrete
        anchors.fill: parent
    }

    statusBar: Rectangle {
        width: parent.width
        height: 120
        color:  flatConstants.concrete

        Rectangle {
            id: status_separator
            height:1
            width: parent.width
            anchors.top: parent.top
            color:  flatConstants.orange
        }

        Text {
            anchors { bottom: parent.bottom; top: status_separator.bottom; left: parent.left; right: parent.right }
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignHCenter
            font.pointSize: 12
            text: "勤谓精进，于善恶品修断事中，勇悍为性，对治懈怠，满善为业。"
        }
    }

    toolBar: Rectangle {
        width: parent.width
        height: 120
        color:  flatConstants.concrete

        Rectangle {
            height:1
            width: parent.width
            anchors.bottom: parent.bottom
            color:  flatConstants.orange
        }

        Rectangle {
            id: backButton
            width: opacity ? 80 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 80
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            MyButton {
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                text:flatConstants.fontAwesome.fa_arrow_left
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: stackView.pop()
            }
        }

        Text {
            font.pixelSize: 42
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "精进"
        }

        Rectangle {
            id: calendar_button
            width: opacity ? 80 : 0
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 80
            color: calendar_mouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            MyButton {
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                text:flatConstants.fontAwesome.fa_calendar
            }
            MouseArea {
                id: calendar_mouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    if( stackView.currentItem.objectName != 'CalendarPage' ) {
                        stackView.pop()
                        stackView.push(Qt.resolvedUrl("content/CalendarPage.qml"))
                    }
                }
            }
        }

        Rectangle {
            id: chart_button
            width: opacity ? 80 : 0
            anchors.right: calendar_button.left
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 80
            color: chart_mouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            MyButton {
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                text:flatConstants.fontAwesome.fa_bar_chart_o
            }
            MouseArea {
                id: chart_mouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    if( stackView.currentItem.objectName != 'Statistic' ) {
                        stackView.pop()
                        stackView.push(Qt.resolvedUrl("content/StatisticPage.qml"))
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: {
            if (event.key === Qt.Key_Back && stackView.depth > 1) {
                stackView.pop();
                event.accepted = true;
            }
        }
        initialItem: DailyLogPage {
        }
    }
}
