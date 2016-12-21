import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    id: root
    height: eventItemColumn.height + 1
    signal trashButtonClicked(int index)
    color: "transparent"
    border.color: "#21be2b"

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: "transparent"
    }

    Row {
        id: eventItemColumn
        anchors.top: parent.top
        width: parent.width
        height: 60
        spacing: 5

        Rectangle {
            width: (parent.width - parent.spacing) / 4
            height: parent.height
            color: "transparent"

            Label {
                anchors.fill: parent
                width: parent.width
                wrapMode: Text.Wrap
                text: modelData.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            width: (parent.width - parent.spacing) / 4
            height: parent.height
            color: "transparent"

            Label {
                anchors.fill: parent
                width: parent.width
                wrapMode: Text.Wrap
                text: modelData.inputTime.toTimeString()
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            width: (parent.width - parent.spacing) / 4
            height: parent.height
            color: "transparent"

            Label {
                anchors.fill: parent
                width: parent.width
                wrapMode: Text.Wrap
                text: modelData.count
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            width: (parent.width - parent.spacing) / 4
            height: parent.height
            color: "transparent"

            ImageButton {
                anchors.centerIn: parent
                anchors { top: parent.top; bottom: parent.bottom; right: parent.right; margins: 1}
                source: "qrc:/Material/icons/action/delete.svg"
                onClicked: root.trashButtonClicked(modelData.index)
            }
        }
    }
}
