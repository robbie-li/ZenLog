import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import zenlog.sqlmodel 1.0

Page {
    id: root

    signal courseChanged()

    SqlModel {
        id: sqlModel
        onCourseChanged: {
            console.log("course changed")
            root.courseChanged();
        }
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
        root.reload()
    }

    function reload() {
        contentReapter.model = sqlModel.coursesForDate(datepicker.currentDate)
        totalCount.text = sqlModel.courseCountForDate(datepicker.currentDate)
    }

    Column {
        id: input
        anchors { left: parent.left; right: parent.right; top: parent.top; }
        spacing: 30

        SimpleDatePicker {
            id: datepicker
            width: parent.width
            height: 60
            onCurrentDateChanged: {
                root.reload()
            }
        }

        Row {
            width: parent.width
            height: 60
            spacing: 20

            Label {
                id: labelName
                width: parent.width * 0.3
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }

            TextField {
                id: labelCount
                width: parent.width * 0.6
                placeholderText: "输入次数:1-1000000"
                validator: IntValidator {bottom: 0; top: 1000000;}
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }

        Row {
            width: parent.width
            height: 60

            Label {
                id: prompt
                text:"请在左边的个人信息里先设定你的功课！"
                visible: labelName.text == ''
            }

            Rectangle {
                width: prompt.visible ? (parent.width - prompt.width) : parent.width

                Button {
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    width: 100
                    enabled: labelCount.text != '' && labelName.text != ''

                    text: "更新"

                    onClicked: {
                        if(sqlModel.updateCourse(datepicker.currentDate, labelName.text, labelCount.text)) {
                            labelCount.text = '';
                            labelCount.focus = false;
                            root.reload();
                        }
                    }
                }

                Button {
                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    width: 100
                    enabled: labelCount.text != '' && labelName.text != ''

                    text: "保存"

                    onClicked: {
                        if(sqlModel.addCourse(datepicker.currentDate, labelName.text, labelCount.text)) {
                            labelCount.text = '';
                            labelCount.focus = false;
                            root.reload();
                        }
                    }
                }
            }
        }
    }

    Column {
        anchors { left: parent.left; right: parent.right; top: input.bottom; bottom: parent.bottom; topMargin: 20 }

        Row {
            id: row_total
            width: parent.width
            height: 60
            spacing: 20

            Label {
                width: parent.width * 0.3
                height: parent.height
                text: "今日总计"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                id: totalCount
                width: parent.width * 0.6
                height: parent.height
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
                    root.reload()
                }
            }
        }
    }

    Component.onCompleted: {
        reloadUserSetting();
    }
}
