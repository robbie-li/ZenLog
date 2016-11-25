import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0

Frame {
    id: root
    anchors { fill: parent; margins: 5 }

    SqlModel {
        id: sqlModel
    }

    signal userSettingsChanged()

    RowLayout {
        id: title
        width: parent.width
        Label {
            id: titleLabel
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            text: "个人信息"
            horizontalAlignment: Qt.AlignHCenter
        }

        Button {
            width: 20
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            text: "保存"
            onClicked: {
                if( qq_text.text != '' ) {
                    var course = radio_dabeizhou.checked ? radio_dabeizhou.text : radio_fohao.text
                    sqlModel.saveUser(qq_text.text, group_index.currentIndex+1, index_text.text, name_text.text, email_text.text, targetcount_text.text, course);
                    root.userSettingsChanged()
                }
            }
        }
    }

    ButtonGroup {
        buttons: subject_group.children
    }

    GridLayout {
        columns: 2
        width: parent.width
        anchors.top: title.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 10
        rowSpacing: 10
        columnSpacing: 10

        Label {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.24 * parent.width
            text: "主修功课"
        }

        Row {
            id: subject_group

            RadioButton {
                id: radio_dabeizhou
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.36 * parent.width
                text: "大悲咒"
            }

            RadioButton {
                id: radio_fohao
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.36 * parent.width
                text: "佛号"
            }
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            text: "QQ"
        }

        TextField {
            id: qq_text
            width: 50
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.5 * parent.width
            placeholderText: "QQ"
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            text: "姓名"
        }

        TextField {
            id: name_text
            width: 50
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.5 * parent.width
            placeholderText: "姓名"
            inputMethodHints: Qt.ImhNone
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            text: "精进群"
        }

        ComboBox {
            id: group_index
            width: 50
            model: ["一组", "二组", "三组"]
        }

        Label {
            Layout.alignment: Qt.AlignLeft
            text: "组内编号:"
        }

        TextField {
            id: index_text
            width: 50
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.5 * parent.width
            placeholderText: "编号"
            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator { bottom: 0; top: 10000; }
        }

        Label {
            Layout.alignment: Qt.AlignLeft
            text: "Email"
        }

        TextField {
            id: email_text
            width: parent.width
            placeholderText: "Email"
            inputMethodHints: Qt.ImhEmailCharactersOnly
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.24 * parent.width
            text: "今年目标"
        }

        TextField {
            id: targetcount_text
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.7 * parent.width
            placeholderText: "目标"
            inputMethodHints: Qt.ImhDigitsOnly
        }
    }

    function reload() {
        var user = sqlModel.getCurrentUser();
        if( user !== null) {
            qq_text.text = user.qq
            group_index.currentIndex = user.group - 1
            index_text.text = user.index
            name_text.text = user.name
            email_text.text = user.email
            targetcount_text.text = user.targetCount
            if (user.courseName === radio_dabeizhou.text) {
                radio_dabeizhou.checked = true;
            } else {
                radio_fohao.checked = true;
            }
        }
    }

    Component.onCompleted: {
        reload();
    }
}
