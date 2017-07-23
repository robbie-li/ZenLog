import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.usermodel 1.0
import zenlog.sqlmodel 1.0
import zenlog.user 1.0

import "./controls"

Frame {
    id: frame

    property User currentUser: UserModel.currentUser

    UserSetting {
        id: userSetting
        width: parent.width
        anchors {
            top: parent.top
            bottom: rowButtons.top
        }
    }

    RowLayout {
        id: rowButtons
        width: parent.width
        height: 40
        anchors {
            bottom: parent.bottom
            bottomMargin: 2
        }

        ImageTextButton {
            text: qsTr("保存")
            source: "qrc:/Material/icons/action/done.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.margins: 4
            onClicked: UserModel.update()
        }
    }
}
