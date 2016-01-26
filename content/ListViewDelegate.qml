import QtQuick 2.5
import Material 0.2
import "."

Rectangle {
  id: root
  height: eventItemColumn.height
  signal trashButtonClicked(int index)

  Rectangle {
      width: parent.width
      height: 1
      color: "#eee"
  }

  Row {
      id: eventItemColumn
      anchors.left: parent.left
      anchors.leftMargin: 8
      anchors.right: parent.right
      height: 60
      spacing: 10

      Rectangle {
          width: (parent.width - parent.spacing) / 3
          height: parent.height

          Label {
              anchors.fill: parent
              width: parent.width
              wrapMode: Text.Wrap
              text: modelData.name
              verticalAlignment: Text.AlignVCenter
          }
      }


      Rectangle {
          width: (parent.width - parent.spacing) / 3
          height: parent.height

          Label {
              anchors.fill: parent
              width: parent.width
              wrapMode: Text.Wrap
              text: modelData.count
              verticalAlignment: Text.AlignVCenter
          }
      }

      Rectangle {
          width: (parent.width - parent.spacing) / 3
          height: parent.height

          IconButton {
            anchors.centerIn: parent
            width: parent.height
            height: width
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right; margins: 1}
            iconName: "action/delete"
            onClicked: root.trashButtonClicked(modelData.index)
          }
      }
  }
}
