import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Button {
    id: control
    property string source
    property color overlayColor: "#000000"

    contentItem: RowLayout {
        anchors.fill: control

        Image {
            id: image
            opacity: enabled ? 1.0 : 0.3
            source: control.source
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            smooth: true
            fillMode: Image.PreserveAspectFit
        }

        Text {
            Layout.fillHeight: true
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

    Component.onCompleted: {
        console.log("ImageTextButton height:" + control.height)
    }
}
