import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    id: root

    title: "请选择个人类别:"

    standardButtons: Dialog.Ok

    Frame {
        anchors.fill: parent

        ButtonGroup {
            id: button_group
        }

        Column {
            id: radio_column
            anchors{ top: parent.top }

            RadioButton {
                checked: true
                Layout.fillWidth: true
                text: "精进群"
                ButtonGroup.group: button_group
            }

            RadioButton {
                text: "普渡群"
                ButtonGroup.group: button_group
            }

            RadioButton　{
                text: "群外居士"
                ButtonGroup.group: button_group
            }
        }
    }
}
