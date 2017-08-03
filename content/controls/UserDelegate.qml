import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

SwipeDelegate {
    id: delegate

    checkable: true

    background: Rectangle {
        color: index % 2 == 0 ? "lightblue": "lightgrey"
    }

    contentItem: ColumnLayout {
        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            Image {
                Layout.preferredHeight: 24
                Layout.preferredWidth: 24
                fillMode:Image.PreserveAspectFit
                source: modelData.current ? "qrc:/Material/icons/toggle/check_box.svg" : "qrc:/Material/icons/toggle/check_box_outline_blank.svg"
            }

            Text {
                Layout.fillWidth: true
                elide: Text.ElideRight
                text: modelData.name
                font.bold: true
                font.pixelSize: 20
            }
        }

        GridLayout {
            id: grid
            visible: false

            columns: 2
            rowSpacing: 10
            columnSpacing: 10

            Label {
                text: qsTr("QQ:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.qq
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("功课:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.courseName
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("目标:")
                Layout.leftMargin: 60
            }

            Label {
                text: modelData.targetCount
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }

    states: [
        State {
            name: "expanded"
            when: delegate.checked

            PropertyChanges {
                target: grid
                visible: true
            }
        }
    ]

    swipe.right: Label {
        id: deleteLabel
        text: qsTr("删除")
        color: "white"
        verticalAlignment: Label.AlignVCenter
        padding: 12
        height: parent.height
        anchors.right: parent.right

        SwipeDelegate.onClicked: listView.model.remove(index)

        background: Rectangle {
            color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
        }
    }

    swipe.left: Label {
        id: editLabel
        text: qsTr("编辑")
        color: "white"
        verticalAlignment: Label.AlignVCenter
        padding: 12
        height: parent.height
        anchors.left: parent.left

        SwipeDelegate.onClicked: listView.model.remove(index)

        background: Rectangle {
            color: editLabel.SwipeDelegate.pressed ? Qt.darker("deepskyblue", 1.1) : "deepskyblue"
        }
    }
}
