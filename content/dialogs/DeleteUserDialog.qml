import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.usermodel 1.0
import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "../controls"

Dialog {
    id: dialog

    property User currentUser: UserModel.getCurrentUser()

    title: "用户管理"

    modal: true
    focus: true

    Frame {
        width: parent.width
        height: 300

        anchors {
            top: parent.top;
            margins: 0
        }

        ColumnLayout {
            anchors {
                fill:parent
                margins: 0
            }

            Label {
                text: "用户列表"
            }

            ListView {
                id: listView

                Layout.fillHeight: true
                Layout.fillWidth: true

                orientation: ListView.Vertical
                flickableDirection: Flickable.VerticalFlick

                model: UserModel.listUserNames()

                ButtonGroup {
                    id: userGroup
                }

                delegate: Rectangle {
                    width: listView.width
                    height: 40
                    color: "lightblue"

                    Row {
                        anchors.fill: parent

                        RadioButton {
                            id: btnSelect
                            height: parent.height
                            width: parent.width - btnDelete.width
                            text: modelData
                            font.pixelSize: 32
                            checked: modelData === currentUser.name
                            ButtonGroup.group: userGroup
                        }

                        ImageButton {
                            id: btnDelete
                            text: qsTr("删除")
                            height: parent.height
                            source: "qrc:/Material/icons/action/delete.svg"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.margins: 4
                        }
                    }
                }
            }
        }
    }

    RowLayout {
        id: rowButtons
        width: parent.width
        height: 40
        anchors {
            bottom: parent.bottom
            bottomMargin: 2
        }

        ImageTextButton {
            text: qsTr("新建用户")
            source: "qrc:/Material/icons/content/add.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.margins: 4
            onClicked: createUserDialog.open()
        }
    }

    CreateUserDialog {
        id: createUserDialog
    }
}
