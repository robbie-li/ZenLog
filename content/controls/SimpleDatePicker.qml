import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Rectangle {
    property date currentDate: new Date()
    height: 60
    color: "transparent"

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

    ImageButton {
        id: buttonPrevious
        anchors.left: parent.left
        height: parent.height
        width: 60
        text: "前一日"
        source: "qrc:/Material/icons/navigation/chevron_left.svg"
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
            font.pixelSize: 28
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Popup {
            id: datePickerDialog
            width: 300
            height: 300
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

            contentItem: ColumnLayout {
                id: settingsColumn
                spacing: 20

                Label {
                    text: "请选择日期"
                    font.bold: true
                }

                TumblerDatePicker {
                    id: datepicker
                    width: parent.width
                }

                RowLayout {
                    spacing: 10
                    height: 20

                    Button {
                        id: okButton
                        text: "确定"
                        onClicked: {
                            currentDate = datepicker.getSelectedDate()
                            datePickerDialog.close()
                        }

                        Layout.preferredWidth: 0
                        Layout.fillWidth: true
                    }

                    Button {
                        id: cancelButton
                        text: "取消"
                        onClicked: {
                            datePickerDialog.close()
                        }

                        Layout.preferredWidth: 0
                        Layout.fillWidth: true
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                datePickerDialog.open()
            }
        }
    }

    ImageButton {
        id: buttonNext
        height: parent.height
        width: 60
        anchors.right: parent.right
        text: "后一日"
        source: "qrc:/Material/icons/navigation/chevron_right.svg"
        onClicked: {
            currentDate = nextDayOf(currentDate)
            move_right.start()
        }
    }
}
