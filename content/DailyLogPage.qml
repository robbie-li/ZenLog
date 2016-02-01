import QtQuick 2.5
import QtQuick.Layouts 1.1
import Material 0.2
import Material.Extras 0.1
import Material.ListItems 0.1 as ListItem
import zenlog.sqlmodel 1.0
import "."

Page {
    SqlModel {
        id: sqlModel
    }

    title: "精进修行"

    actions: [
        Action {
            iconName: "action/view_list"
            text: "History"
            onTriggered: pageStack.push(Qt.resolvedUrl("CalendarPage.qml"))
        }
    ]

    Column {
        id: input
        anchors {left: parent.left; right: parent.right; top: parent.top; }

        spacing: Units.dp(20)

        function reload() {
            contentReapter.model = sqlModel.coursesForDate(datepicker.currentDate)
            totalCount.text = sqlModel.courseCountForDate(datepicker.currentDate)
        }

        SimpleDatePicker {
            id: datepicker
            width: parent.width
            height: Units.dp(60)
            onCurrentDateChanged: {
                input.reload()
            }
        }

        Row {
            width: parent.width
            spacing: Units.dp(20)

            Label {
                id: labelName
                width: parent.width * 0.3
                style: "title"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                id: labelCount
                width: parent.width * 0.6
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
                id: totalCount
                width: parent.width * 0.6
                height: parent.height
                floatingLabel: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: sqlModel.courseCountForDate(datepicker.currentDate)
                readOnly: true
            }
        }
    }

    Column {
        id: content
        anchors {left: parent.left; right: parent.right; top: input.bottom; bottom: parent.bottom; topMargin: Units.dp(40) }

        Repeater {
            id: contentReapter
            model:  sqlModel.coursesForDate(datepicker.currentDate)

            delegate: ListViewDelegate {
                width: content.width
                onTrashButtonClicked: {
                    eventModel.delCourse(index)
                    input.reload()
                }
            }
        }
    }

    Rectangle {
        anchors {
            bottom: parent.bottom
        }
        width: parent.width
        height: Units.dp(60)
        color: Theme.primaryColor

        Button {
            anchors {
                centerIn: parent
            }

            text: "保存"

            onClicked: {
                if(labelCount.text != '') {
                    sqlModel.addCourse(datepicker.currentDate, labelName.text, labelCount.text)
                    labelCount.text = ''
                    input.reload();
                }
            }
        }
    }

    Component.onCompleted: {
        var user = sqlModel.getCurrentUser();
        labelName.text = user.courseName
    }
}
