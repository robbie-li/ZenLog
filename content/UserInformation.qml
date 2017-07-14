import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "./controls"

Frame {
    id: frame

    ListView {
        id: listView
        width: parent.width
        height: 40

        orientation: ListView.Horizontal
        flickableDirection: Flickable.HorizontalFlick

        anchors {
            top: parent.top;
            margins: 0
        }

        model: ListModel {
            ListElement {
                name: "张三"
                selected: false
            }

            ListElement {
                name: "李四"
                selected: false
            }

            ListElement {
                name: "王五"
                selected: true
            }

            ListElement {
                name: "朱六"
                selected: false
            }
        }
        delegate: Item {
            x: 5
            width: 80
            height: 20
            Row {
                id: row1
                spacing: 10
                Rectangle {
                    width: 20
                    height: 20
                    color: selected? "lightblue": "transparent"
                    border.width: 1
                    border.color: "black"
                }

                Text {
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
            }
        }
    }

    UserSetting {
        id: userSetting
        width: parent.width
        anchors {
            top: listView.bottom
            bottom: rowButtons.top
        }
    }

    RowLayout {
        id: rowButtons
        width: parent.width
        height: 40
        anchors {
            bottom: parent.bottom
            bottomMargin: 2
        }

        ImageTextButton {
            text: qsTr("新建")
            source: "qrc:/Material/icons/content/add.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.margins: 4
        }

        ImageTextButton {
            text: qsTr("保存")
            source: "qrc:/Material/icons/action/done.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.margins: 4
        }

        ImageTextButton {
            text: qsTr("删除")
            source: "qrc:/Material/icons/action/delete.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.margins: 4
        }
    }
}
