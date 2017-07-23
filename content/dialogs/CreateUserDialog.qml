import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.usermodel 1.0
import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "../controls"

Dialog {
    id: dialog

    title: "创建用户"

    modal: true
    focus: true

    standardButtons: Dialog.Ok | Dialog.Cancel

    UserSetting {
        id: userSetting
        anchors.fill: parent
        currentUser: UserModel.createUser()
    }

    onAccepted: {
        userSetting.updateUser();
        var user = userSetting.currentUser;
        UserModel.saveUser(user);
    }
}
