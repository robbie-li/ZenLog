import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.model 1.0

import "../controls"

Dialog {
    id: dialog

    title: "创建用户"

    function reload() {
        currentUser.reset()
        userSetting.reload()
    }

    User {
        id: currentUser
    }

    modal: true
    focus: true

    Rectangle {
        anchors.fill:  parent

        UserSetting {
            anchors.top: parent.top
            anchors.bottom: buttonBox.top
            width: parent.width

            id: userSetting
            currentUser: currentUser
            currentEditable: true
        }

        DialogButtonBox {
            id: buttonBox

            height: 32

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            ImageTextButton {
                text: "取消"
                imageVisible: false
                width: 120
                height: 30
                font.pixelSize: 18
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }

            ImageTextButton {
                text: "创建"
                imageVisible: false
                width: 120
                height: 30
                font.pixelSize: 18
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }

            onAccepted: {
                if(userSetting.valid()) {
                    userSetting.updateUser()
                    if (!SqlModel.createUser(userSetting.currentUser)) {
                        console.log("failed to create user");
                    }
                }
                dialog.close()
            }

            onRejected: {
                dialog.close()
            }
        }
    }
}
