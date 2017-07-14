import QtQuick 2.9
import QtQuick.Controls 2.2

Button {
    id: control
    property var source
    property int size: 48

    implicitHeight: size
    implicitWidth: size

    background: Rectangle {
        implicitHeight: 20
        implicitWidth: 40
        color: "transparent"
        opacity: enabled ? 1 : 0.3
    }

    contentItem: Image {
        anchors.fill: parent
        opacity: enabled ? 1.0 : 0.3
        source: control.source
        ToolTip.text: control.text
        fillMode: Image.PreserveAspectFit
    }
}
