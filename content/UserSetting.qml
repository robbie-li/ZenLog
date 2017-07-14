import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Frame {
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
            }

            ComboBox {
                id: comboGroup
                Layout.preferredWidth: parent.width* 0.35
                model: ["一组","二组"]
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
        }
    }
}
