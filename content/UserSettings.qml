import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0

Frame {
    id: root
    anchors { fill: parent; margins: 5 }

    signal userSettingsChanged()

    background: Rectangle {
        y: root.topPadding - root.padding
        width: parent.width
        height: parent.height - root.topPadding + root.padding
        color: "white"
    }

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
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }

            height: 32

            background: Rectangle {
                color: "#B2E0E0"
                anchors.fill: parent
                opacity: enabled ? 1 : 0.3
            }

            contentItem: Label {
                text: qsTr("保存")
                color: "#287B7B"
            }

            onClicked: {
                if( qq.text != '' ) {
                    SqlModel.saveUser(course.currentText,
                                      qq.text,
                                      name.text,
                                      class_num.currentIndex + 1,
                                      group_num.currentIndex + 1,
                                      group_idx.text,
                                      target_count.text);
                    root.userSettingsChanged()
                }
            }
        }
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

        ComboBox {
            id: course
            model: ["大悲咒","佛号"]
            Layout.preferredWidth: 0.7 * parent.width
            onCurrentIndexChanged: {
                if(course.currentIndex == 0) {
                    basic_target.text = "108"
                } else {
                    basic_target.text = "10000"
                }
            }
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("名号")
        }

        TextField {
            id: name
            width: 50
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.7 * parent.width
            placeholderText: qsTr("名号")
            inputMethodHints: Qt.ImhNone
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            text: "QQ"
        }

        TextField {
            id: qq
            width: 50
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.7 * parent.width
            placeholderText: "QQ"
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("班组")
        }

        Row {
            Layout.preferredWidth: 0.7 * parent.width
            spacing: 10
            ComboBox {
                id: class_num
                width: 80
                model: [qsTr("1班"), qsTr("2班"), qsTr("3班"), qsTr("4班"), qsTr("5班"), qsTr("6班"), qsTr("7班"), qsTr("8班"), qsTr("9班")]
            }
            ComboBox {
                id: group_num
                width: 80
                model: [qsTr("1组"), qsTr("2组"), qsTr("3组"), qsTr("4组"), qsTr("5组")]
            }
        }

        Label {
            Layout.alignment: Qt.AlignLeft
            text: qsTr("群内编号")
        }

        TextField {
            id: group_idx
            width: 50
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.7 * parent.width
            placeholderText: qsTr("群内编号")
            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator { bottom: 0; top: 10000; }
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.24 * parent.width
            text: qsTr("基本目标")
        }

        TextField {
            id: basic_target
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.7 * parent.width
            placeholderText: qsTr("基本目标")
            inputMethodHints: Qt.ImhDigitsOnly
            readOnly: true
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.24 * parent.width
            text: qsTr("奋斗目标")
        }

        TextField {
            id: target_count
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 0.7 * parent.width
            placeholderText: qsTr("奋斗目标")
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Item {
            Layout.fillHeight: true
        }
    }

    function reload() {
        var user = SqlModel.getCurrentUser();
        if( user !== null) {
            if(user.courseName === "大悲咒") {
                course.currentIndex = 0
                basic_target.text = 108
            } else {
                course.currentIndex = 1
                basic_target.text = 10000
            }
            qq.text = user.qq
            name.text = user.name
            class_num.currentIndex = user.classNum - 1
            group_num.currentIndex = user.groupNum - 1
            group_idx.text = user.groupIdx
            target_count.text = user.targetCount
        }
    }

    Component.onCompleted: {
        reload();
    }
}
