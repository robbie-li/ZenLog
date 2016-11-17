import QtQuick 2.5
import QtQuick.Layouts 1.1

import Material 0.2
import Material.Extras 0.1

import zenlog.sqlmodel 1.0

Page {
    id: root

    SqlModel {
        id: sqlModel
    }

    title: "精进修行"

    function reloadUserSetting() {
        var user = sqlModel.getCurrentUser();
        if(user) {
            labelName.text = user.courseName
            console.log(labelName.text)
        }
    }

    function selectDate(selectedDate) {
        datepicker.currentDate = selectedDate;
        input.reload()
    }

    actions: [
        Action {
            iconName: "awesome/bar_chart"
            text: "统计"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("CalendarPage.qml"))
            }
        }
    ]

    Column {
        id: input
        anchors {left: parent.left; right: parent.right; top: parent.top; }
        spacing: Units.dp(40)

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
            id: input_row
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

        RowLayout {
            width: parent.width

            Label {
                Layout.alignment: Qt.AlignLeft
                text:"请在左边的个人信息里先设定你的功课！"
                visible: labelName.text == ''
            }

            Button {
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: Units.dp(40)
                width: Units.dp(100)
                backgroundColor: Theme.primaryColor
                elevation: 1
                enabled: labelCount.text != '' && labelName.text != ''

                text: "保存"

                onClicked: {
                    if(sqlModel.addCourse(datepicker.currentDate, labelName.text, labelCount.text)) {
                        labelCount.text = '';
                        labelCount.focus = false;
                        input.reload();
                    }
                }
            }
        }
    }

    Column {
        anchors { left: parent.left; right: parent.right; top: input.bottom; bottom: parent.bottom; topMargin: Units.dp(40) }

        Row {
            id: row_total
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

            Label {
                id: totalCount
                width: parent.width * 0.6
                height: parent.height
                style: "title"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: sqlModel.courseCountForDate(datepicker.currentDate)
            }
        }

        ListView {
            width: parent.width
            height: root.height - input.height - row_total.height
            id: contentReapter
            model: sqlModel.coursesForDate(datepicker.currentDate)
            clip: true

            delegate: ListViewDelegate {
                width: parent.width
                onTrashButtonClicked: {
                    sqlModel.delCourse(index)
                    input.reload()
                }
            }
        }
    }

    Component.onCompleted: {
        reloadUserSetting();
    }
}
