import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.mailclient 1.0
import zenlog.clipboard 1.0

Page {
    id: root
    title: qsTr("每月视图")

    MailClient {
        id: mailclient
        onMailSent: {
            popup.status = status
            popup.open();
        }
    }

    Popup {
        id: popup

        property bool status

        x: 100
        y: 100

        width: 300
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        contentItem: Rectangle {
            id: content

            Label {
                anchors.centerIn: content
                text: popup.status ? qsTr("邮件发送成功") : qsTr("邮件发送失败")
                font.bold: true
                font.pixelSize: 30
            }

            Button {
                text: qsTr("确定")
                anchors { bottom: content.bottom; bottomMargin: 4; horizontalCenter: content.horizontalCenter }
                onClicked: {
                    popup.close()
                }
            }
        }
    }

    function reload() {
        console.log("reload CalendarPage")
        monthly_total.text = SqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
        monthly_average.text = SqlModel.courseAverageForMonth(calendar.visibleYear, calendar.visibleMonth)
        yearly_total.text = SqlModel.courseTotalForYear(calendar.visibleYear)
        yearly_average.text = SqlModel.courseAverageForYear(calendar.visibleYear)
        calendar.reload()
    }

    MyCalendar {
        id: calendar

        width: parent.width
        height: parent.height / 2
        anchors { top: parent.top }

        onDaySelected: {
            swipeView.setCurrentIndex(1)
            daily.selectDate(selectedDate)
        }

        onMonthSelected: {
            monthly_total.text = SqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
            monthly_average.text = SqlModel.courseAverageForMonth(calendar.visibleYear, calendar.visibleMonth)
            yearly_total.text = SqlModel.courseTotalForYear(calendar.visibleYear)
            yearly_average.text = SqlModel.courseAverageForYear(calendar.visibleYear)
        }
    }

    Popup {
        id: clipboard_status

        property bool status

        x: 50
        y: 50

        width: parent.width - 100
        height: 200
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        Timer {
            id: clipboard_timer
            interval: 2000
            running: false
            repeat: false
            onTriggered: {
                console.log("timer: close popup")
                clipboard_status.close()
            }
        }

        contentItem: Rectangle {
            Label {
                anchors.centerIn: parent
                text: clipboard_status.status ? qsTr("复制成功") : qsTr("复制失败")
                font.bold: true
                font.pixelSize: 30
            }

            Button {
                text: qsTr("确定")
                anchors { bottom: parent.bottom; bottomMargin: 4; horizontalCenter: parent.horizontalCenter }
                onClicked: {
                    clipboard_status.close()
                }
            }
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

                    columns: 4
                    rowSpacing: 2
                    columnSpacing: 4

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: "当月总计"
                    }

                    Label {
                        id: monthly_total
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: SqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: "当月日均"
                    }

                    Label {
                        id: monthly_average
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: SqlModel.courseAverageForMonth(calendar.visibleYear, calendar.visibleMonth)
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: "年度总计"
                    }

                    Label {
                        id: yearly_total
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: SqlModel.courseTotalForYear(calendar.visibleYear)
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: "年度平均"
                    }

                    Label {
                        id: yearly_average
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.25 * parent.width
                        text: SqlModel.courseAverageForYear(calendar.visibleYear)
                    }
                }
            }

            GroupBox {
                id: column_tool
                width: parent.width

                title: "工具"

                Column {
                    anchors.fill: parent
                    Button {
                        width: parent.width
                        Layout.fillWidth: true
                        text: "上传日志"
                        visible: false
                        onClicked: {
                            mailclient.sendMail(calendar.visibleYear, calendar.visibleMonth)
                        }
                    }

                    Button {
                        width: parent.width
                        Layout.fillWidth: true
                        text: qsTr("复制当月记录")
                        onClicked: {
                            ClipBoard.copyMonthlyCourse(calendar.visibleYear, calendar.visibleMonth)
                            clipboard_status.status = true
                            clipboard_timer.start()
                            clipboard_status.open()
                        }
                    }
                }
            }
        }
    }
}
