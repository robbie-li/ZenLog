import QtQuick 2.9
import QtQuick.Controls 2.2

Button {
    id: control
    property var source

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
        opacity: enabled ? 1 : 0.3
    }

    contentItem: Image {
        anchors.fill: parent
        opacity: enabled ? 1.0 : 0.3
        source: control.source
        ToolTip.text: control.text
        fillMode: Image.PreserveAspectFit
        smooth: true
    }
}
