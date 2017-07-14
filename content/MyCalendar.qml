import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import "controls"

Calendar {
    id: calendar

    function reload() {
        dataArr = SqlModel.monthlyCourses(calendar.visibleYear, calendar.visibleMonth);
    }

    property var dataArr

    signal daySelected(date selectedDate)
    signal monthSelected(date selectedMonth)

    onVisibleYearChanged : {
        reload()
    }

    onVisibleMonthChanged : {
        reload()
    }

    frameVisible: false

    style: CalendarStyle {
        gridVisible: false

        property int calendarWidth: calendar.width
        property int calendarHeight: calendar.height

        background: Rectangle {
            color: "white"
            anchors.fill: parent
        }

        navigationBar: Rectangle {
            height: 60
            width: calendarWidth
            color: "transparent"

            ImageButton {
                id: previousMonth
                width: 60
                anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 0 }
                source: "qrc:/Material/icons/navigation/chevron_left.svg"
                onClicked: {
                    control.showPreviousMonth();
                    control.monthSelected(new Date(control.visibleYear, control.visibleMonth, 1));
                    reload()
                }
            }

            Label {
                anchors.centerIn: parent
                id: dayTitle
                font.weight: Font.DemiBold
                font.pixelSize: 28
                Layout.fillWidth: true
                lineHeight: 0.9
                wrapMode: Text.Wrap
                text: styleData.title
                color: "#323232"
            }

            ImageButton {
                id: nextMonth
                width: 60
                anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 0 }
                source: "qrc:/Material/icons/navigation/chevron_right.svg"
                onClicked: {
                    control.showNextMonth();
                    control.monthSelected(new Date(control.visibleYear, control.visibleMonth, 1))
                    reload()
                }
            }
        }

        dayOfWeekDelegate: Rectangle {
            color: "transparent"
            implicitHeight: 30
            Label {
                text: control.__locale.dayName(styleData.dayOfWeek, Locale.NarrowFormat)
                anchors.centerIn: parent
                color: "#696969"
            }
        }

        dayDelegate: Rectangle {
            visible: styleData.visibleMonth
            height: 64
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: styleData.selected ? Material.accent : "transparent"
            }

            Label {
                id: dayText
                height: parent.height * 6 / 10
                anchors {
                    top: parent.top;
                    horizontalCenter: parent.horizontalCenter
                }
                text: styleData.date.getDate()
                font.pixelSize: 18
                color: styleData.selected ? "white" : "#696969"
            }

            Label {
                id: dayCount
                anchors {
                    top: dayText.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottom:parent.bottom
                }

                function toDateString(day) {
                    return ("00" + day).slice(-2);
                }

                function getColor(count, selected) {
                    if (count) {
                        var user = SqlModel.getCurrentUser();
                        if(user.courseName === "大悲咒") {
                            if (count < 108)
                                return selected? "white" : "#EB7A77";
                            if (count >= user.targetCount)
                                return selected? "white" : "#2EA9DF";
                        }
                        if(user.courseName === "佛号" ) {
                            if(count < 10000)
                                return selected? "white" : "#EB7A77";
                            if(count >= user.targetCount)
                                return selected? "white" : "#2EA9DF";
                        }
                    }
                    if(selected) {
                        return "white"
                    } else {
                        return "#323232";
                    }
                }

                text: calendar.dataArr[toDateString(styleData.date.getDate())] ? calendar.dataArr[toDateString(styleData.date.getDate())] : ""
                font.pixelSize: 10
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                color: getColor(calendar.dataArr[toDateString(styleData.date.getDate())], styleData.selected)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    calendar.daySelected(styleData.date);
                }
            }
        }
    }

    Component.onCompleted: {
        reload()
    }
}
