import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.model 1.0

SwipeDelegate {
    id: delegate

    signal editUser(string userId)
    signal removeUser(string userName)
    signal setDefaultUser(string userName)

    checkable: true

    background: Rectangle {
        color: current ? "#EFEFEF": "white"
        Rectangle {
            width: delegate.width
            height: 1
            color: Qt.lighter("grey")
            anchors.bottom: parent.bottom
        }
    }

    contentItem: ColumnLayout {
        spacing: 5

        RowLayout {
            Layout.fillWidth: true

            CheckBox {
                id: cb
                checked: current

                onToggled: {
                    if(toggled) {
                        delegate.setDefaultUser(name)
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                text: name
                font.pixelSize: 22
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
                text: QQ
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("功课:")
                Layout.leftMargin: 60
            }

            Label {
                text: course
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("目标:")
                Layout.leftMargin: 60
            }

            Label {
                text: targetCount
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
        padding: 12
        height: parent.height
        anchors.right: parent.right

        SwipeDelegate.onClicked: {
            delegate.removeUser(name)
        }

        background: Rectangle {
            color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
        }
    }

    swipe.left: Label {
        id: editLabel
        text: qsTr("编辑")
        padding: 12
        height: parent.height
        anchors.left: parent.left

        SwipeDelegate.onClicked: {
            delegate.editUser(userId)
        }

        background: Rectangle {
            color: editLabel.SwipeDelegate.pressed ? Qt.darker("deepskyblue", 1.1) : "deepskyblue"
        }
    }

    Component.onCompleted: {
        console.log("Loading +windows/UserDelegate")
    }
}
