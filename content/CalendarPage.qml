import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.mailclient 1.0

Page {
    id: root
    title: qsTr("每月视图")

    SqlModel {
        id: sqlModel
    }

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
                text: popup.status ? "邮件发送成功" : "邮件发送失败"
                font.bold: true
                font.pixelSize: 30
            }

            Button {
                text: "确定"
                anchors { bottom: content.bottom; bottomMargin: 4; horizontalCenter: content.horizontalCenter }
                onClicked: {
                    popup.close()
                }
            }
        }
    }

    function reload() {
        console.log("reload CalendarPage")
        mounth_count.text = sqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
        year_count.text = sqlModel.courseTotalForYear(calendar.visibleYear)
        calendar.reload()
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
            mounth_count.text = sqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
            year_count.text = sqlModel.courseTotalForYear(calendar.visibleYear)
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
                        text: sqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
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
                        text: sqlModel.courseTotalForYear(calendar.visibleYear)
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
                    onClicked: {
                        mailclient.sendMail(calendar.visibleYear, calendar.visibleMonth)
                    }
                }
            }
        }
    }
}
