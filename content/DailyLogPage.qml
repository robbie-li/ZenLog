import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.usermodel 1.0

import "./controls"

Page {
    id: root

    signal courseChanged()

    Connections {
        target: SqlModel
        onCourseChanged: {
            console.log("course changed")
            root.courseChanged();
        }
        onUserUpdated: {
            console.log("user changed")
            reloadUserSetting()
        }
    }

    Connections {
        target: UserModel
        onModelChanged: {
            console.log("user model changed")
            reloadUserSetting();
        }
    }

    title: "精进修行"

    function reloadUserSetting() {
        console.log("reload current user setting")
        var user = UserModel.getCurrentUser()

        if(user) {
            labelName.text = user.courseName
            if(user.courseName === "") {
                alert_column.visible = true;
                input_row.visible = false;
                confirm_button.visible = false;
            } else {
                alert_column.visible = false;
                input_row.visible = true;
                confirm_button.visible = true;
            }
        } else {
            alert_column.visible = true;
            input_row.visible = false;
            confirm_button.visible = false;
        }
    }

    function selectDate(selectedDate) {
        datepicker.currentDate = selectedDate;
        root.reload()
    }

    function reload() {
        contentReapter.model = SqlModel.listCourse(datepicker.currentDate)
    }

    Column {
        id: input
        anchors { left: parent.left; right: parent.right; top: parent.top; }
        spacing: 20

        SimpleDatePicker {
            id: datepicker
            width: parent.width
            height: 60
            onCurrentDateChanged: {
                root.reload()
            }
        }

        ColumnLayout {
            width: parent.width
            id: alert_column

            Row {
                width: parent.width
                Layout.alignment: Qt.AlignHCenter
                spacing: 0

                Label {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    text: "请点击顶部左上角的"
                }

                Rectangle {
                    width: 28
                    height: 28
                    color: "#66BAB7"
                    Image {
                        anchors.fill: parent
                        source: "qrc:/Material/icons/navigation/menu.svg"
                    }
                }

                Label {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    text: "，设定你的个人信息。"
                }
            }

            Label {
                id: label2
                width: parent.width * 0.3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
                text: "保存个人信息后，才能录入功课哦~";
                color: "#C0C0C0"
            }
        }

        Row {
            id: input_row
            width: parent.width
            height: 60
            spacing: 20
            visible: labelName.text != ""

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

        Button {
            id: confirm_button

            background: Rectangle {
                color: "#B2E0E0"
                anchors.fill: parent
                opacity: enabled ? 1 : 0.3
            }

            anchors.right: parent.right
            anchors.rightMargin: 40
            width: 80
            height: 32

            contentItem: Label {
                anchors.fill: parent
                opacity: enabled ? 1.0 : 0.3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("保存")
                color: "#287B7B"
                font.pixelSize: 18
            }

            onClicked: {
                var user = UserModel.currentUser

                if(SqlModel.createCourse(datepicker.currentDate, labelName.text, labelCount.text)) {
                    labelCount.text = '';
                    labelCount.focus = false;
                    root.reload();
                }
            }
        }
    }

    ListView {
        anchors { left: parent.left; right: parent.right; top: input.bottom; bottom: parent.bottom; topMargin: 20 }

        id: contentReapter
        model: SqlModel.listCourse(datepicker.currentDate)
        clip: true

        delegate: ListViewDelegate {
            width: parent.width
            onTrashButtonClicked: {
                SqlModel.deleteCourse(index)
                root.reload()
            }
        }
    }

    Component.onCompleted: {
        reloadUserSetting();
    }
}
