import QtQuick 2.7
import QtQuick.Controls 2.0

import "."

Button {
    id: control
    property var source
    property var size: Units.dp(32)

    width: size
    height: size

    contentItem: Image {
        opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        source: control.source
        ToolTip.text: control.text
    }
}
