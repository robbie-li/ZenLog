import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Button {
    id: control
    property string source

    contentItem: RowLayout {
        anchors.fill: parent
        Image {
            Layout.fillHeight: true
            opacity: enabled ? 1.0 : 0.3
            fillMode: Image.PreserveAspectFit
            source: control.source
        }

        Text {
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? "#17a81a" : "#21be2b"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    background: Rectangle {
        anchors.fill: parent
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? "#17a81a" : "#21be2b"
        border.width: 1
    }
}
