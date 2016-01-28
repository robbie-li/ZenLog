import QtQuick 2.5
import QtQuick.Layouts 1.1

import Material 0.2
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1

NavigationDrawer {
    View {
        anchors.top: parent.top

        width: parent.width
        height: column.implicitHeight + Units.dp(32)

        elevation: 1
        radius: Units.dp(2)

        ColumnLayout {
            id: column

            anchors {
                fill: parent
                topMargin: Units.dp(16)
                bottomMargin: Units.dp(16)
            }

            Label {
                id: titleLabel

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Units.dp(16)
                }

                style: "title"
                text: "个人信息"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Units.dp(8)
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_circle"
                }

                content: TextField {
                    anchors.centerIn: parent
                    width: parent.width
                    placeholderText: "姓名"
                    //text: "Alex Nelson"
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "maps/place"
                }

                content: TextField {
                    anchors.centerIn: parent
                    width: parent.width
                    placeholderText: "地址"
                    //text: "100 Main Street"
                }
            }

            ListItem.Standard {
                action: Item {}

                content: RowLayout {
                    anchors.centerIn: parent
                    width: parent.width

                    TextField {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.6 * parent.width
                        placeholderText: "城市"
                        //text: "New York"
                    }

                    /*
                    MenuField {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.2 * parent.width

                        model: ["NY", "NC", "ND"]
                    }
                    */

                    TextField {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.3 * parent.width
                        placeholderText: "邮编"
                        characterLimit: 6
                        validator: IntValidator {bottom: 0; top: 999999;}
                        //text: "10011"
                    }
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "communication/email"
                }

                content: TextField {
                    anchors.centerIn: parent
                    width: parent.width

                    placeholderText: "Email"
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "communication/business"
                }

                content: RowLayout {
                    anchors.centerIn: parent
                    width: parent.width

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.3 * parent.width
                        text: "主修功课"
                    }

                    MenuField {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.6 * parent.width
                        model: ["大悲咒", "佛号"]
                    }
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "action/assignment"
                }

                content: RowLayout {
                    anchors.centerIn: parent
                    width: parent.width

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.3 * parent.width
                        text: "今年目标"
                    }

                    TextField {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.6 * parent.width
                        placeholderText: "目标"
                        characterLimit: 20
                        //validator: IntValidator {bottom: 0; top: 99999999999999;}
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Units.dp(8)
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: Units.dp(8)

                anchors {
                    right: parent.right
                    margins: Units.dp(16)
                }

                /*
                Button {
                    text: "Cancel"
                    textColor: Theme.primaryColor
                }
                */

                Button {
                    text: "保存"
                    textColor: Theme.primaryColor
                }
            }
        }
    }
}
