import QtQuick 2.5
import Material 0.2
import Material.Extras 0.1
import robbie.calendar 1.0
import "."

Page {
    SqlEventModel {
        id: eventModel
    }

    title: "精进修行"

    ActionButton {
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: Units.dp(32)
        }

        action: Action {
            id: addContent
            text: "&Save"
            shortcut: "Ctrl+S"
            //onTriggered: eventModel.addCourse()
        }
        iconName: "content/save"
    }

    Flickable {
        anchors.fill: parent

        Column {
            anchors.centerIn: parent

            spacing: Units.dp(20)

            SimpleDatePicker {
                id: datepicker
                width: Units.dp(300)
                height: Units.dp(60)
            }

            Row {
                spacing: Units.dp(20)

                Label {
                    style: "title"
                    text: "大悲咒"
                    verticalAlignment: Text.AlignVCenter
                }

                TextField {
                    placeholderText: "输入次数:1-1000000"
                    floatingLabel: true
                    characterLimit: 10
                    validator: IntValidator {bottom: 0; top: 1000000;}
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ListView {
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
