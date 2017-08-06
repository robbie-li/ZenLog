import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "controls"
import "dialogs"

Item {
    id: root

    property User currentUser: SqlModel.getCurrentUser()
    property string title: qsTr("用户管理")
    property int currentIndex: -1

    signal editUser(string userId)
    signal removeUser(string userName)

    Connections {
        target: listView
        onPressAndHold: {
            currentIndex = index
            userMenu.open()
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Frame {
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                anchors {
                    fill:parent
                    margins: 0
                }

                RowLayout {
                    width: parent.width

                    Label {
                        Layout.preferredHeight: 36
                        text: "用户列表"
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        Layout.margins: 5
                    }
                }

                ListView {
                    id: listView

                    signal pressAndHold(int index)

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    orientation: ListView.Vertical
                    flickableDirection: Flickable.VerticalFlick

                    model: UserModel {
                    }

                    clip: true

                    delegate: UserDelegate {
                        id: delegate
                        width: listView.width

                        Connections {
                            target: delegate
                            onPressAndHold: listView.pressAndHold(index)
                        }

                        onEditUser: {
                            editDialog.currentUser = SqlModel.getUser(userId)
                            editDialog.open()
                        }

                        onRemoveUser: {
                            deleteUserDialog.userName = userName
                            deleteUserDialog.open()
                        }
                    }
                }
            }
        }

        RowLayout {
            width: parent.width

            ImageTextButton {
                Layout.preferredHeight: 48
                Layout.fillWidth: true
                text: qsTr("新建用户")
                source: "qrc:/Material/icons/content/add.svg"
                Layout.alignment: Qt.AlignCenter
                Layout.margins: 4
                onClicked: {
                    createUserDialog.reload()
                    createUserDialog.open()
                }
            }
        }
    }

    CreateUserDialog {
        id: createUserDialog
        width: root.width
        contentHeight: 500
    }

    DeleteUserDialog {
        id: deleteUserDialog
        width: root.width
        contentHeight: 200
    }

    UserDialog {
        id: editDialog
        width: root.width
        contentHeight: 500
    }
}
