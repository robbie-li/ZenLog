import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

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
        }

        Label {
            text: "个人信息"
            font.pixelSize: 24
        }

        ImageTextButton {
            text: qsTr("保存")
            source: "qrc:/Material/icons/action/done.svg"
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: 90
            Layout.preferredHeight: 32
            Layout.margins: 2
            onClicked: {
                userSetting.updateUser(true)
                SqlModel.updateUser(userSetting.currentUser)
            }
            enabled: userSetting.valid()
        }
    }

    UserSetting {
        id: userSetting
        width: parent.width
        currentUser: SqlModel.getCurrentUser()
        anchors {
            topMargin: 20
            top: rowButtons.bottom
            bottom: parent.bottom
        }
    }

    Connections {
        target: SqlModel
        onUserChanged: userSetting.currentUser = SqlModel.getCurrentUser()
    }
}
