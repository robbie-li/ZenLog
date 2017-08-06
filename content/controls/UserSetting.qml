import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.user 1.0

Item {
    property User currentUser

    function updateUser(isCurrent) {
        currentUser.name = textName.text
        currentUser.qq = textQQ.text
        currentUser.classNum = comboClass.currentIndex
        currentUser.groupNum = comboGroup.currentIndex
        currentUser.groupIdx = textGroupIndex.text
        currentUser.courseName = comboCourse.currentText
        currentUser.current = isCurrent
        currentUser.targetCount = textTarget.text
        currentUser.userType = userType.checked ? User.ExternalUser : User.GroupUser
    }

    function valid() {
        if( !textTarget.acceptableInput ) return false;
        if( !textGroupIndex.acceptableInput) return false;
        if( textQQ.text === '') return false;
        if( textName.text === '') return false;

        return true;
    }

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
            text: qsTr("")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
        }

        CheckBox {
            id: userType
            text: "群外莲友"
            checked: currentUser.userType === User.ExternalUser
        }

        Label {
            text: qsTr("班组")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
            visible: !userType.checked
        }

        RowLayout {
            visible: !userType.checked
            Layout.fillWidth: true

            ComboBox {
                id: comboClass
                Layout.preferredWidth: 90
                model: ["1班","2班","3班","4班","5班","6班","7班","8班"]
                currentIndex: currentUser.classNum
            }

            ComboBox {
                id: comboGroup
                Layout.preferredWidth: 90
                model: ["1组","2组","3组","4组","5组"]
                currentIndex: currentUser.groupNum
            }
        }

        Label {
            text: qsTr("群内编号")
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width* 0.2
            horizontalAlignment: Text.AlignRight
            visible: !userType.checked
        }

        TextField {
            id: textGroupIndex
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: currentUser.groupIdx
            inputMethodHints : Qt.ImhDigitsOnly
            validator: IntValidator { bottom: 0; top: 1000000 }
            visible: !userType.checked
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
            readOnly: true
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
            inputMethodHints : Qt.ImhDigitsOnly
            validator: IntValidator { bottom: textBaseTarget.text; top: 999999 }
        }
    }
}
