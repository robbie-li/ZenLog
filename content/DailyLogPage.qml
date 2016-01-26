import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import robbie.calendar 1.0
import Material 0.2

Item {
    objectName: 'DailyLog'
    width: parent.width
    height: parent.height

    SqlEventModel {
        id: eventModel
    }

    Rectangle {
        color: flatConstants.concrete
        anchors.fill: parent

        Row {
            id: option
            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 30 }
            spacing: 30

            FlatSelect {
                id: course_name
                width: (parent.width - option.spacing) /2
                height: 60
                dropdownItemHeight: height
                dropdownWidth: width
                dropdownRadius: 0

                model: ListModel {
                    ListElement {item: "大悲咒";}
                    ListElement {item: "佛号"; separator: true}
                    ListElement {item: "心经"; separator: true}
                    ListElement {item: "六字真言"; separator: true}
                }
            }

            FlatSelect {
                id: course_time
                width: (parent.width - option.spacing) /2
                height: 60
                dropdownItemHeight: height
                dropdownWidth: width
                dropdownRadius: 0

                model: ListModel {
                    ListElement {item: "全天";}
                    ListElement {item: "早课"; separator: true}
                    ListElement {item: "午课"; separator: true}
                    ListElement {item: "晚课"; separator: true}
                }
            }
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

        FlatButton {
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

    Component {
        id: touchStyle

        TextFieldStyle {
            textColor: "white"
            font.pixelSize: 28
            background: Item {
                implicitHeight: 50
                implicitWidth: 480
                BorderImage {
                    source: "qrc:/res/images/textinput.png"
                    border.left: 8
                    border.right: 8
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
        }
    }
}
