import QtQuick 2.9
import QtQuick.Controls 2.2

import zenlog.model 1.0

import "../controls"

Dialog {
    id: root
    property User currentUser
    title: "编辑用户"
    modal: true
    focus: true

    Rectangle {
        anchors.fill:  parent

        UserSetting {
            id: userSetting

            anchors.top: parent.top
            anchors.bottom: buttonBox.top
            width: parent.width

            currentUser: root.currentUser
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
                text: "保存"
                imageVisible: false
                width: 120
                height: 30
                font.pixelSize: 18
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }

            onAccepted: {
                userSetting.updateUser(root.currentUser.current)
                SqlModel.updateUser(userSetting.currentUser)
                root.close()
            }

            onRejected: {
                root.close()
            }
        }
    }
}
