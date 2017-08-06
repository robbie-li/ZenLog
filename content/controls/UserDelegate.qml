import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import "../dialogs"

SwipeDelegate {
    id: delegate

    signal editUser(string userId)
    signal removeUser(string userName)

    checkable: true

    background: Rectangle {
        color: index % 2 == 0 ? "lightblue": "lightgrey"
    }

    contentItem: ColumnLayout {
        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            CheckBox {
                checked: current
                onToggled: {
                    if(toggled) {
                        SqlModel.setDefaultUser(name)
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                text: name
                font.pixelSize: 30
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
        color: "white"
        verticalAlignment: Label.AlignVCenter
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
        color: "white"
        verticalAlignment: Label.AlignVCenter
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
}
