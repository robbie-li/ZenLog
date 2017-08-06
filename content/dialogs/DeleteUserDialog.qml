import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "../controls"

Dialog {
    id: dialog

    title: "删除用户"

    property string userName

    modal: true
    focus: true

    standardButtons: Dialog.Yes | Dialog.No

    contentItem: Text {
        text: "你确定要删除该用户:" + userName + "?"
    }

    onAccepted: {
        console.log("deleting user:" + userName)
        SqlModel.removeUser(userName);
    }
}
