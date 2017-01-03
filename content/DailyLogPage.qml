import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0

Page {
    id: root

    signal courseChanged()

    Connections {
        target: SqlModel
        onCourseChanged: {
            console.log("course changed")
            root.courseChanged();
        }
    }

    title: "精进修行"

    function reloadUserSetting() {
        var user = SqlModel.getCurrentUser();
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
        contentReapter.model = SqlModel.courseDetailsForDate(datepicker.currentDate)
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
                text: qsTr("请在个人信息里先设定你的功课！")
                visible: labelName.text == ''
            }

            Rectangle {
                width: prompt.visible ? (parent.width - prompt.width) : parent.width

                Button {
                    background: Rectangle {
                        color: "#B2E0E0"
                        anchors.fill: parent
                        opacity: enabled ? 1 : 0.3
                    }

                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    width: 100
                    height: 40
                    enabled: labelCount.text != '' && labelName.text != ''

                    contentItem: Label {
                        anchors.fill: parent
                        opacity: enabled ? 1.0 : 0.3
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("保存")
                        color: "#287B7B"
                        font.pixelSize: 22
                    }

                    onClicked: {
                        if(SqlModel.addCourse(datepicker.currentDate, labelName.text, labelCount.text)) {
                            labelCount.text = '';
                            labelCount.focus = false;
                            root.reload();
                        }
                    }
                }
            }
        }
    }

    ListView {
        anchors { left: parent.left; right: parent.right; top: input.bottom; bottom: parent.bottom; topMargin: 20 }

        id: contentReapter
        model: SqlModel.courseDetailsForDate(datepicker.currentDate)
        clip: true

        delegate: ListViewDelegate {
            width: parent.width
            onTrashButtonClicked: {
                SqlModel.delCourse(index)
                root.reload()
            }
        }
    }

    Component.onCompleted: {
        reloadUserSetting();
    }
}
