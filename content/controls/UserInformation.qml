import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.usermodel 1.0
import zenlog.sqlmodel 1.0
import zenlog.user 1.0

Frame {
    id: frame

    RowLayout {
        id: rowButtons
        width: parent.width
        height: 40
        anchors {
            top: parent.top
            bottomMargin: 2
        }

        Label {
            text: "个人信息"
            font.pixelSize: 32
        }

        ImageTextButton {
            text: qsTr("保存")
            source: "qrc:/Material/icons/action/done.svg"
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredHeight: 48
            Layout.margins: 2
            onClicked: {
                userSetting.updateUser(true)
                SqlModel.updateUser(userSetting.currentUser)
            }
        }
    }

    UserSetting {
        id: userSetting
        width: parent.width
        currentUser: SqlModel.getCurrentUser()
        anchors {
            top: rowButtons.bottom
            bottom: parent.bottom
        }
    }

    Connections {
        target: UserModel
        onModelChanged: userSetting.currentUser = SqlModel.getCurrentUser()
    }

    Connections {
        target: SqlModel
        onUserUpdated: userSetting.currentUser = SqlModel.getCurrentUser()
    }
}
