import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import zenlog.sqlmodel 1.0

Page {
    id: root
    title: "每月视图"

    SqlModel {
        id: sqlModel
    }

    MyCalendar {
        id: calendar

        width: parent.width
        height: parent.height /2
        anchors { top: parent.top }

        onDaySelected: {
            swipeView.setCurrentIndex(1)
            daily.selectDate(selectedDate)
        }

        onMonthSelected: {
            mounth_count.text = sqlModel.courseCountForMonth(selectedMonth)
            year_count.text = sqlModel.courseCountForYear(selectedMonth)
        }
    }

    Pane {
        anchors { top: calendar.bottom; bottom: parent.bottom; left: parent.left; right: parent.right; }

        Column {
            anchors.fill: parent
            spacing: 10

            GroupBox {
                id: statistic
                width: parent.width
                title: "统计"

                GridLayout {
                    anchors { fill: parent }

                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 10

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.2 * parent.width
                        text: "当月总计"
                    }

                    Label {
                        id: mounth_count
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        text: sqlModel.courseCountForMonth(calendar.selectedDate)
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.2 * parent.width
                        text: "年度总计"
                    }

                    Label {
                        id: year_count
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        text: sqlModel.courseCountForYear(calendar.selectedDate)
                    }
                }
            }

            GroupBox {
                id: column_tool
                width: parent.width

                title: "工具"

                Button {
                    width: parent.width
                    Layout.fillWidth: true
                    text: "上传日志"
                }
            }
        }
    }
}

