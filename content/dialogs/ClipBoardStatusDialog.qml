import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
    id: clipboard_status

    property bool status

    x: 50
    y: 200

    width: parent.width - 100
    height: 60
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    function show(result) {
        clipboard_status.status = result;
        clipboard_timer.start();
        clipboard_status.open();
    }

    Timer {
        id: clipboard_timer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            clipboard_status.close()
        }
    }

    contentItem: Rectangle {
        RowLayout {
            anchors.centerIn: parent

            Image {
                source : "qrc:/Material/icons/action/check_circle.svg"
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                text: clipboard_status.status ? qsTr("复制成功") : qsTr("复制失败")
                font.pixelSize: 22
            }
        }
    }
}
