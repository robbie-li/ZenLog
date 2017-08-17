import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id: banner

    property alias message : messageText.text

    height: 70

    Rectangle {
        id: background

        anchors.fill: banner
        color: "darkblue"
        smooth: true
        opacity: 0.8
    }

    Text {
        font.pixelSize: 24
        renderType: Text.QtRendering
        width: 150
        height: 40
        id: messageText


        anchors.fill: banner
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap

        color: "white"
    }

    states: State {
        name: "portrait"
        PropertyChanges { target: banner; height: 100 }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            messages.state = ""
        }
    }
}
