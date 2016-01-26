import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import Material 0.2

Rectangle {
    id: datePicker
    width: parent.width
    height: 60

    property var currentDate: new Date()
    property bool expanded: false

    function getCurrentDate() {
        return currentDate.getDate();
    }

    FlatConstants {
        id: flatConstants
    }

    onExpandedChanged: {
      if(expanded) {
        height += calendar.height
      } else {
        height -= calendar.height
      }
    }

    Rectangle {
        id: headerRect
        height: 50
        anchors { top: parent.top; left: parent.left; right: parent.right; margins: 5 }
        clip: true

        TextInput {
            id: dateText
            anchors { top: parent.top; bottom: parent.bottom; left: parent.left; }
            font.family: flatConstants.latoBlackFont.name
            font.pointSize: 20
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            readOnly: true
            text: datePicker.currentDate.toLocaleString(Qt.locale("zh_CN"), "yyyy-MM-dd")
        }

        Rectangle {
          id: dateSeparator
          width:1
          anchors { top: parent.top; bottom: parent.bottom; right: dateButton.left; margins:4}
          color: "black"
        }

        MyButton {
          id: dateButton
          width: 60
          anchors { top: parent.top; bottom: parent.bottom; right: parent.right; margins: 1}
          text: flatConstants.fontAwesome.fa_calendar
          defaultColor: "white"
          textColor: "black"
        }

        MouseArea {
          id: dateMouse
          anchors.fill: dateButton
          onClicked: datePicker.expanded = !datePicker.expanded
        }
    }

    Rectangle {
        id: calendarRect
        anchors { left: parent.left; right: parent.right; top: headerRect.bottom }

        color: "#FFFFFF"
        height: datePicker.expanded ? calendar.height + 2 : 0
        clip: true

        Behavior on height {
            NumberAnimation { duration: 100; easing.type: Easing.InQuad }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 1
            anchors.rightMargin: 1
            anchors.top: parent.top
            color: "#FFFFFF"
            height: 1
        }

        Calendar {
            id: calendar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: 420
            frameVisible: false

            style: CalendarStyle {
                gridVisible: false
                background: Rectangle { color: "transparent" }
                dayDelegate: Item {
                    implicitHeight: implicitWidth
                    implicitWidth: calendar.width / 7

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.implicitHeight / 2
                        color: dayArea.pressed && styleData.visibleMonth ? "#FF6C3B" : "transparent"
                    }

                    Text {
                        anchors.centerIn: parent
                        font.family: flatConstants.latoRegularFont.name
                        font.pointSize: 16
                        font.letterSpacing: -1
                        font.bold: dayArea.pressed
                        text: styleData.date.getDate()
                        color: {
                            if(!styleData.visibleMonth) return "#DBDBDB"
                            if(dayArea.pressed) return "#FFFFFF"
                            if(styleData.today) return "#FF6C3B"
                            return "#4A4848"
                        }
                    }

                    MouseArea {
                        id: dayArea
                        anchors.fill: parent
                        onClicked: {
                            if(styleData.visibleMonth) {
                                var date = styleData.date
                                datePicker.currentDate = date
                                datePicker.expanded = false
                            } else {
                                var date = styleData.date
                                if(date.getMonth() > calendar.visibleMonth)
                                    calendar.showNextMonth()
                                else calendar.showPreviousMonth()
                            }
                        }
                    }
                }

                dayOfWeekDelegate: Item {
                    implicitHeight: 60
                    implicitWidth: calendar.width / 7

                    Text {
                        anchors.centerIn: parent
                        elide: Text.ElideRight
                        font.family: flatConstants.latoRegularFont.name
                        font.pointSize: 16
                        font.letterSpacing: -1
                        color: "#535353"
                        text: {
                            var locale = Qt.locale()
                            return locale.dayName(styleData.dayOfWeek, Locale.ShortFormat)
                        }
                    }
                }

                navigationBar: Rectangle {
                    implicitWidth: calendar.width
                    implicitHeight: 80

                    Text {
                        anchors.centerIn: parent
                        font.family: flatConstants.latoRegularFont.name
                        font.pointSize: 16
                        font.letterSpacing: -1
                        color: "#4A4646"
                        text: styleData.title
                    }

                    Item {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: height

                        MyButton {
                            width: parent.width
                            height:parent.height
                            anchors.centerIn: parent
                            text: flatConstants.fontAwesome.fa_arrow_left
                            defaultColor: "white"
                            textColor: "black"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: calendar.showPreviousMonth()
                        }
                    }

                    Item {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: height

                        MyButton {
                            width: parent.width
                            height:parent.height
                            anchors.centerIn: parent
                            text: flatConstants.fontAwesome.fa_arrow_right
                            defaultColor: "white"
                            textColor: "black"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: calendar.showNextMonth()
                        }
                    }
                }
            }
        }
    }
}
