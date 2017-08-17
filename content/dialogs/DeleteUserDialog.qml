import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.model 1.0

import "../controls"

Dialog {
    id: dialog

    title: "删除用户"

    property string userName

    modal: true
    focus: true

    Rectangle {
        anchors.fill:  parent

        Text {
            text: "你确定要删除该用户:" + userName + "?"
            anchors.top: parent.top
            anchors.bottom: buttonBox.top
            width: parent.width
            font.pixelSize: 18
        }

        DialogButtonBox {
            id: buttonBox

            height: 40

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            ImageTextButton {
                text: "取消"
                imageVisible: false
                width: 120
                height: 35
                font.pixelSize: 22
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }

            ImageTextButton {
                text: "删除"
                imageVisible: false
                width: 120
                height: 35
                font.pixelSize: 22
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }

            onAccepted: {
                console.log("deleting user:" + userName)
                SqlModel.removeUser(userName);
                dialog.close()
            }

            onRejected: {
                dialog.close()
            }
        }
    }
}
