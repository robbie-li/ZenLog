import QtQuick 2.5
import Material 0.2

Rectangle {
    property date currentDate: new Date()

    function previousDayOf(today) {
        var dateTime = today;
        dateTime.setDate(today.getDate() - 1);
        return dateTime;
    }

    function nextDayOf(today) {
        var dateTime = today;
        dateTime.setDate(today.getDate() + 1);
        return dateTime;
    }

    IconButton {
        id: buttonPrevious
        anchors.left: parent.left
        size: Units.dp(60)
        iconName: "navigation/chevron_left"
        onClicked: {
            currentDate = previousDayOf(currentDate)
            move_left.start();
        }
    }

    SequentialAnimation {
        id: move_left
        running: false
        ParallelAnimation {
            NumberAnimation { target: dateLabel; property: "x"; from: 0; to: -dateLabel.width/2; duration: 200 }
            NumberAnimation { target: dateLabel; property: "opacity"; from:1; to: 0; duration: 200 }
        }
        NumberAnimation { target: dateLabel; property: "x"; from: -dateLabel.width/2; to: dateLabel.width/2; duration: 1 }
        ParallelAnimation {
            NumberAnimation { target: dateLabel; property: "x"; from: dateLabel.width/2; to: 0; duration: 200 }
            NumberAnimation { target: dateLabel; property: "opacity"; from:0; to: 1; duration: 200 }
        }
    }

    SequentialAnimation {
        id: move_right
        running: false
        ParallelAnimation {
            NumberAnimation { target: dateLabel; property: "x"; from: 0; to: dateLabel.width/2; duration: 200 }
            NumberAnimation { target: dateLabel; property: "opacity"; from:1; to: 0; duration: 200 }
        }
        NumberAnimation { target: dateLabel; property: "x"; from: dateLabel.width/2; to: -dateLabel.width/2; duration: 1 }
        ParallelAnimation {
            NumberAnimation { target: dateLabel; property: "x"; from: -dateLabel.width/2; to: 0; duration: 200 }
            NumberAnimation { target: dateLabel; property: "opacity"; from:0; to: 1; duration: 200 }
        }
    }

    Rectangle {
        anchors { left: buttonPrevious.right; right: buttonNext.left }
        height: parent.height
        color: "transparent"

        Label {
            id: dateLabel
            width: parent.width
            height: parent.height
            text: Qt.formatDate(currentDate, "yyyy-MM-dd")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            style: "headline"
        }

        Dialog {
            id: datePickerDialog
            hasActions: true
            contentMargins: 0
            floatingActions: false
            positiveButtonText: "确定"
            negativeButtonText: "取消"

            TumblerDatePicker {
                height: Units.dp(250)
                id: datepicker
            }

            onAccepted: {
                currentDate = datepicker.getSelectedDate()
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                datePickerDialog.show()
            }
        }
    }

    IconButton {
        id: buttonNext
        anchors.right: parent.right
        size: Units.dp(60)
        iconName: "navigation/chevron_right"
        onClicked: {
            currentDate = nextDayOf(currentDate)
            move_right.start()
        }
    }
}
