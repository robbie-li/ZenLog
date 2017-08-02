import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

//Draw an image where all pixels except transparent will be colored to a given color
Item {
    property color overlayColor: "#000000"
    property alias source: img.source

    Image {
        id: img
        height: parent.height
        width: parent.width
        smooth: true
        visible: false
    }

    ColorOverlay {
        anchors.fill: img
        source: img
        color: overlayColor  // make image like it lays under red glass
    }
}
