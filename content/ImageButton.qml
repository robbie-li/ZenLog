import QtQuick 2.8
import QtQuick.Controls 2.1

Button {
    id: control
    property var source
    property int size: 48

    implicitHeight: size
    implicitWidth: size

    background: Rectangle {
        color: "transparent"
        anchors.fill: parent
        opacity: enabled ? 1 : 0.3
    }

    contentItem: Image {
        anchors.fill: parent
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        source: control.source
        ToolTip.text: control.text
    }
}
