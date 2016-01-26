import QtQuick 2.5
import QtQuick.Controls 1.4
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
          width: (parent.width - parent.spacing) / 4
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
          width: (parent.width - parent.spacing) / 4
          height: parent.height

          Label {
              anchors.fill: parent
              width: parent.width
              wrapMode: Text.Wrap
              text: modelData.time
              verticalAlignment: Text.AlignVCenter
          }
      }

      Rectangle {
          width: (parent.width - parent.spacing) / 4
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
          width: (parent.width - parent.spacing) / 4
          height: parent.height

          MyButton {
            anchors.centerIn: parent
            width: parent.height
            height: width
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right; margins: 1}
            text: flatConstants.fontAwesome.fa_trash
            //defaultColor: "white"
            //textColor: "black"
            onClicked: root.trashButtonClicked(modelData.index)
          }
      }
  }
}
