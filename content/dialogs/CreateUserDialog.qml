import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "../controls"

Dialog {
    id: dialog

    title: "创建用户"

    User {
        id: currentUser
    }

    modal: true
    focus: true

    standardButtons: Dialog.Ok | Dialog.Cancel

    contentItem: UserSetting {
        id: userSetting
        currentUser: currentUser
    }

    onAccepted: {
        userSetting.updateUser(false)
        SqlModel.createUser(userSetting.currentUser);
    }
}
