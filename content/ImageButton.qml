import QtQuick 2.7
import QtQuick.Controls 2.0

Button {
    id: control
    property var source

    contentItem: Image {
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        source: control.source
        ToolTip.text: control.text
    }
}
