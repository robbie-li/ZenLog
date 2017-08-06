import QtQuick 2.9
import QtQuick.Controls 2.2

import zenlog.sqlmodel 1.0
import zenlog.user 1.0
import "../controls"

Dialog {
    id: root
    property User currentUser
    title: "编辑用户"
    modal: true
    focus: true

    standardButtons: Dialog.Ok | Dialog.Cancel

    contentItem: UserSetting {
        id: userSetting
        currentUser: root.currentUser
    }

    onAccepted: {
        userSetting.updateUser(root.currentUser.current)
        SqlModel.updateUser(userSetting.currentUser)
    }
}
