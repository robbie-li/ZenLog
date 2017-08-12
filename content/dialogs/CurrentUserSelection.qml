import QtQuick 2.9
import QtQuick.Controls 2.2
import zenlog.model 1.0

import "../controls"

Popup {
    id: popup

    /*
    ComboBox {
        id: combo
        width: parent.width
        model: SqlModel.listUserNames()
        Component.onCompleted: {
           combo.currentIndex = combo.find(SqlModel.getCurrentUser().name)
        }
    }
    */

    ListView {
        id: view
        anchors.fill: parent
        clip: true

        function closeView() {
            popup.close()
        }

        model: UserModel {
            id: userModel
        }

        delegate: Rectangle {
            id: itemDelegate
            width: view.width
            height: 42

            color: "transparent"

            ImageTextButton {
                id: button
                width: view.width
                text: name
                imageVisible: false
                bgColor: "lightgrey"
                onClicked: {
                    SqlModel.setDefaultUser(button.text)
                    itemDelegate.ListView.view.closeView()
                }
                font.pixelSize: 22
                anchors.top:parent.top
                anchors.bottom: separator.top
                anchors.margins: 0
            }

            Rectangle {
                id: separator
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "black"
            }
        }
    }
}
