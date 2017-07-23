import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.user 1.0
import zenlog.usermodel 1.0

Frame {
    property User currentUser: UserModel.currentUser

    GridLayout {
        id: grid
        width: parent.width
        columns: 2
        rowSpacing: 10
        columnSpacing: 10

        Label {
            id: labelCourse
            text: qsTr("主修功课")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
        }

        ComboBox {
            id: comboCourse
            model: ["大悲咒","佛号"]
            Layout.fillHeight: true
            Layout.fillWidth: true
            currentIndex: currentUser.courseName === "大悲咒" ? 0 : 1
        }

        Label {
            id: labelName
            text: qsTr("名号")
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.preferredWidth: parent.width* 0.2
            Layout.fillHeight: true
        }

        TextField {
            id: textName
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: currentUser.name
        }

        Label {
            id: labelQQ
            text: qsTr("QQ")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
        }

        TextField {
            id: textQQ
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: currentUser.qq
        }

        Label {
            text: qsTr("班组")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
        }

        Row {
            ComboBox {
                id: comboClass
                Layout.preferredWidth: parent.width* 0.35
                model: ["一班","二班"]
                currentIndex: currentUser.classNum
            }

            ComboBox {
                id: comboGroup
                Layout.preferredWidth: parent.width* 0.35
                model: ["一组","二组"]
                currentIndex: currentUser.groupNum
            }
        }

        Label {
            text: qsTr("组内编号")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
        }

        TextField {
            id: textGroupIndex
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: currentUser.groupIdx
        }

        Label {
            text: qsTr("基本目标")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
        }

        TextField {
            id: textBaseTarget
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: comboCourse.currentText === "大悲咒" ? "108" : "10000"
        }

        Label {
            text: qsTr("奋斗目标")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
        }

        TextField {
            id: textTarget
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: currentUser.targetCount
        }
    }
}
