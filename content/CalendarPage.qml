import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.2
import robbie.calendar 1.0
import "."

Rectangle {
    objectName: 'CalendarPage'
    visible: true
    width: 640
    height: 400

    color: "#f4f4f4"

    SystemPalette {
        id: systemPalette
    }

    SqlEventModel {
        id: eventModel
    }

    Flow {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10
        layoutDirection: Qt.RightToLeft

        Calendar {
            id: calendar
            width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)
            frameVisible: false
            weekNumbersVisible: false
            //selectedDate: new Date(2014, 0, 1)
            focus: true

            style: CalendarStyle {
                dayDelegate: Item {
                    readonly property color sameMonthDateTextColor: "#444"
                    readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "#bbb"
                    readonly property color invalidDatecolor: "#dddddd"

                    Rectangle {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Image {
                        visible: eventModel.coursesForDate(styleData.date).length > 0
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: 30
                        height: width
                        source: "qrc:/res/images/eventindicator.png"
                    }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                }
            }
        }

        Component {
            id: eventListHeader

            Row {
                id: eventDateRow
                width: parent.width
                height: eventDayLabel.height
                spacing: 10

                Label {
                    id: eventDayLabel
                    text: calendar.selectedDate.getDate()
                    font.pointSize: 35
                }

                Column {
                    height: eventDayLabel.height

                    Label {
                        readonly property var options: { weekday: "long" }
                        text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                        font.pointSize: 18
                    }
                    Label {
                        text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                              + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                        font.pointSize: 12
                    }
                }
            }
        }

        Rectangle {
            width: (parent.width > parent.height ? parent.width * 0.4 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.4 - parent.spacing : parent.height)
            border.color: Qt.darker(color, 1.2)

            ListView {
                id: eventsListView
                spacing: 4
                clip: true
                header: eventListHeader
                anchors.fill: parent
                anchors.margins: 10
                model: eventModel.coursesForDate(calendar.selectedDate)

                delegate: ListViewDelegate {
                    width: eventsListView.width
                    onTrashButtonClicked: {
                        eventModel.delCourse(index)
                        eventsListView.model = eventModel.coursesForDate(datepicker.currentDate)
                    }
                }
            }
        }
    }
}
