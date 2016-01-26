import QtQuick 2.5
import Material 0.2
import Material.Extras 0.1
import Material.ListItems 0.1 as ListItem
import robbie.calendar 1.0
import "."

Page {
    SqlEventModel {
        id: eventModel
    }

    title: "精进修行"

    Column {
        id: input
        anchors {left: parent.left; right: parent.right; top: parent.top; }

        spacing: Units.dp(20)

        SimpleDatePicker {
            id: datepicker
            width: parent.width
            height: Units.dp(60)
            onCurrentDateChanged: {
                contentReapter.model = eventModel.coursesForDate(datepicker.currentDate)
            }
        }

        Row {
            width: parent.width
            spacing: Units.dp(20)

            Label {
                width: parent.width * 0.3
                id: labelName
                style: "title"
                text: "大悲咒"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                width: parent.width * 0.6
                id: labelCount
                placeholderText: "输入次数:1-1000000"
                floatingLabel: true
                characterLimit: 10
                validator: IntValidator {bottom: 0; top: 1000000;}
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }

        Row {
            width: parent.width
            height: Units.dp(60)
            spacing: Units.dp(20)

            Label {
                width: parent.width * 0.3
                height: parent.height
                style: "title"
                text: "今日总计"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                width: parent.width * 0.6
                height: parent.height
                floatingLabel: true
                characterLimit: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Column {
        id: content
        anchors {left: parent.left; right: parent.right; top: input.bottom; bottom: parent.bottom; topMargin: Units.dp(40) }

        Repeater {
            id: contentReapter
            model:  eventModel.coursesForDate(datepicker.currentDate)

            delegate: ListViewDelegate {
                width: content.width
                onTrashButtonClicked: {
                    eventModel.delCourse(index)
                    contentReapter.model = eventModel.coursesForDate(datepicker.currentDate)
                }
            }
        }
    }

    ActionButton {
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: Units.dp(32)
        }

        action: Action {
            id: saveButton
            text: "&Save"
            shortcut: "Ctrl+S"
            onTriggered: {
                console.log("save button clicked");
                if(labelCount.text != '') {
                    console.log("try to save")
                    eventModel.addCourse(datepicker.currentDate, labelName.text, labelCount.text)
                    labelCount.text = ''
                    contentReapter.model = eventModel.coursesForDate(datepicker.currentDate)
                }
            }
        }
        iconName: "content/save"
    }

    /*
    Rectangle {
        color: flatConstants.concrete
        anchors.fill: parent

        Row {
            id: option
            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 30 }
            spacing: 30
        }


        TextField {
            id: course_count
            height: 60
            anchors { top: option.bottom; left: parent.left; right: parent.right; margins: 30 }
            validator: IntValidator {bottom: 0; top: 1000000;}
            style: touchStyle
            placeholderText: "输入次数:1-1000000"
            verticalAlignment: Text.AlignVCenter
        }

        DatePicker {
            id: datepicker
            anchors { top: course_count.bottom; left: parent.left; right: parent.right; margins: 30; }
            onCurrentDateChanged: {
                eventsListView.model = eventModel.coursesForDate(datepicker.currentDate)
            }
        }

        Button {
            anchors { top: datepicker.bottom; left: parent.left; right: parent.right; margins: 30 }
            id: saveButton
            text: "Save"
            height: 60

            Behavior on y {
                NumberAnimation { duration: 1000 }
            }

            onClicked: {
                if(course_count.text != '') {
                    eventModel.addCourse(datepicker.currentDate, course_name.text, course_time.text, course_count.text)
                    course_count.text = ''
                    eventsListView.model = eventModel.coursesForDate(datepicker.currentDate)
                }
            }
        }

        ListView {
            anchors { top: saveButton.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; margins: 30 }
            id: eventsListView
            spacing: 4
            clip: true
            model: eventModel.coursesForDate(datepicker.currentDate)

            delegate: ListViewDelegate {
                width: eventsListView.width
                onTrashButtonClicked: {
                    eventModel.delCourse(index)
                    eventsListView.model = eventModel.coursesForDate(datepicker.currentDate)
                }
            }
        }
    }
    */
}
