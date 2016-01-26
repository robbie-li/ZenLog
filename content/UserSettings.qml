import QtQuick 2.5
import Material 0.2

NavigationDrawer {
    Column {
        anchors.centerIn: parent
        Button {
          text: "Simple Button"
          anchors.horizontalCenter: parent.horizontalCenter
          //onClicked: snackbar.open("Simple, isn't it?")
        }

        Button {
          text: "Raised Button"
          elevation: 1
          anchors.horizontalCenter: parent.horizontalCenter
          //onClicked: snackbar.open("This is a snackbar")
        }
    }
}
