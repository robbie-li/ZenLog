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
                    implicitHeight: 48
                    color: index % 2 == 0 ? "lightblue" : "lightgrey"

                    RowLayout {
                        anchors.fill: parent

                        RadioButton {
                            id: btnSelect
                            implicitHeight: parent.height
                            text: modelData
                            font.pixelSize: 32
                            checked: modelData === currentUser.name
                            ButtonGroup.group: userGroup
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        }

                        ImageButton {
                            id: btnDelete
                            text: qsTr("删除")
                            implicitHeight: parent.height
                            source: "qrc:/Material/icons/action/delete.svg"
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
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
        width: dialog.width
        contentHeight: 500
    }
}
