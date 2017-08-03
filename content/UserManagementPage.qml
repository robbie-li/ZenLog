import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.usermodel 1.0
import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "controls"
import "dialogs"

Item {
    id: root

    property User currentUser: UserModel.getCurrentUser()
    property string title: qsTr("用户管理")
    property int currentIndex: -1

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

                    model: SqlModel.listUsers()
                    clip: true

                    delegate: UserDelegate {
                        id: delegate
                        width: listView.width

                        Connections {
                            target: delegate
                            onPressAndHold: listView.pressAndHold(index)
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
                onClicked: createUserDialog.open()
            }
        }
    }

    CreateUserDialog {
        id: createUserDialog
        width: root.width
        contentHeight: 500
        onAccepted: reload()
    }

    DeleteUserDialog {
        id: deleteUserDialog
        width: root.width
        contentHeight: 200
        onAccepted: {
            console.log("deleting user:" + deletedUserName)
            SqlModel.removeUser(deletedUserName)
            reload()
        }
    }

    function reload() {
        listView.model = SqlModel.listUsers();
    }
}
