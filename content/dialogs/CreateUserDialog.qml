import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "../controls"

Dialog {
    id: dialog

    title: "创建用户"

    function guid() {
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    }

    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }

    User {
        id: currentUser
        userId: guid()
    }

    modal: true
    focus: true

    standardButtons: Dialog.Ok | Dialog.Cancel

    contentItem: UserSetting {
        id: userSetting
        currentUser: currentUser
    }

    onAccepted: {
        if(userSetting.valid()) {
            userSetting.updateUser(false)
            SqlModel.createUser(userSetting.currentUser);
        }
    }
}
