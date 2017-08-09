import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Button {
    id: control
    property string source
    property color overlayColor: "#000000"
    property color bgColor: "#B2E0E0"
    property color textColor: "#287B7B"
    property bool imageVisible: true

    contentItem: Rectangle {
        anchors.fill: control
        color: "transparent"

        RowLayout {
            anchors.centerIn: parent

            Image {
                id: image
                opacity: enabled ? 1.0 : 0.3
                source: control.source
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignRight
                smooth: true
                fillMode: Image.PreserveAspectFit
                Layout.preferredHeight: 32
                Layout.preferredWidth: 32
                visible: imageVisible
            }

            Text {
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignLeft
                text: control.text
                font: control.font
                opacity: enabled ? 1.0 : 0.3
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }

    background: Rectangle {
        anchors.fill: parent
        opacity: enabled ? 1 : 0.3
        color: bgColor
    }
}
