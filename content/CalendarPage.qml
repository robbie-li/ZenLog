import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.clipboard 1.0

import "controls"
import "dialogs"

Page {
    id: root
    title: qsTr("每月视图")

    signal daySelected(date selectedDate)

    Connections {
        target: SqlModel
        onUserUpdated: {
            console.log("user changed")
            reload()
        }
    }

    MyCalendar {
        id: calendar

        width: parent.width
        height: 2 * parent.height / 3
        anchors { top: parent.top }

        onDaySelected: {
            root.daySelected(selectedDate)
        }

        onMonthSelected: {
            updateStatistic()
        }
    }

    CourseStatistic {
        id: statitisc_pane
        anchors {
            topMargin: 0
            top: calendar.bottom; bottom: parent.bottom; left: parent.left; right: parent.right;
        }
    }

    ClipBoardStatusDialog {
        id: clipboard_status
    }

    Component.onCompleted:  reload()

    function reloadUser() {
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
        statitisc_pane.reload()
        calendar.reload()
        reloadUser()
    }
}
