import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.mailclient 1.0
import zenlog.clipboard 1.0

import "./controls"

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

    function updateStatistic() {
        monthly_total.text = SqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
        monthly_average.text = SqlModel.courseAverageForMonth(calendar.visibleYear, calendar.visibleMonth)
        yearly_total.text = SqlModel.courseTotalForYear(calendar.visibleYear)
        yearly_average.text = SqlModel.courseAverageForYear(calendar.visibleYear)
        historic_average.text = SqlModel.courseAverage()
        historic_total.text = SqlModel.courseTotal()
    }

    function reloadStatistic() {
        var user = SqlModel.getCurrentUser();
        if(user) {
            calendar.enabled = true
            statitisc_pane.visible = true
        } else {
            calendar.enabled = false
            statitisc_pane.visible = false
        }
    }

    function reload() {
        console.log("reload CalendarPage")
        updateStatistic()
        calendar.reload()
        reloadStatistic()
    }

    MyCalendar {
        id: calendar

        width: parent.width
        height: 2 * parent.height / 3
        anchors { top: parent.top }

        onDaySelected: {
            swipeView.setCurrentIndex(1)
            daily.selectDate(selectedDate)
        }

        onMonthSelected: {
            updateStatistic()
        }
    }

    Popup {
        id: clipboard_status

        property bool status

        x: 50
        y: 200

        width: parent.width - 100
        height: 60
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        Timer {
            id: clipboard_timer
            interval: 2000
            running: false
            repeat: false
            onTriggered: {
                clipboard_status.close()
            }
        }

        contentItem: Rectangle {
            RowLayout {
                anchors.centerIn: parent

                Image {
                    source : "qrc:/Material/icons/action/check_circle.svg"
                    Layout.alignment: Qt.AlignVCenter
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    text: clipboard_status.status ? qsTr("复制成功") : qsTr("复制失败")
                    font.pixelSize: 22
                }
            }
        }
    }

    Pane {
        id: statitisc_pane
        anchors {
            topMargin: 0
            top: calendar.bottom; bottom: parent.bottom; left: parent.left; right: parent.right;
        }

        background: Rectangle {
            anchors.fill: parent
            color: "#EFEFEF"
        }

        Column {
            anchors.fill: parent
            anchors.topMargin: 2
            spacing: 10

            GridLayout {
                width: parent.width

                columns: 4
                rowSpacing: 20
                columnSpacing: 5

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: "当月总计"
                    color: "#696969"
                }

                Label {
                    id: monthly_total
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: SqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
                    color: "#696969"
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: "当月日均"
                    color: "#696969"
                }

                Label {
                    id: monthly_average
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: SqlModel.courseAverageForMonth(calendar.visibleYear, calendar.visibleMonth)
                    color: "#696969"
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: "当年总计"
                    color: "#696969"
                }

                Label {
                    id: yearly_total
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: SqlModel.courseTotalForYear(calendar.visibleYear)
                    color: "#696969"
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: "当年平均"
                    color: "#696969"
                }

                Label {
                    id: yearly_average
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: SqlModel.courseAverageForYear(calendar.visibleYear)
                    color: "#696969"
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: "历史总计"
                    color: "#696969"
                }

                Label {
                    id: historic_total
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: SqlModel.courseTotal()
                    color: "#696969"
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: "历史平均"
                    color: "#696969"
                }

                Label {
                    id: historic_average
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 0.25 * parent.width
                    text: SqlModel.courseAverage()
                    color: "#696969"
                }
            }

            ColumnLayout {
                width: parent.width

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
                    background: Rectangle {
                        color: "#B2E0E0"
                        anchors.fill: parent
                        opacity: enabled ? 1 : 0.3
                    }

                    implicitHeight: 35
                    width: parent.width
                    Layout.margins: 4
                    Layout.fillWidth: true

                    contentItem: Label {
                        anchors.fill: parent
                        opacity: enabled ? 1.0 : 0.3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("复制当月记录")
                        height: 32
                        color: "#287B7B"
                        font.pixelSize: 22
                    }

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

    Component.onCompleted:  reloadStatistic()
}
