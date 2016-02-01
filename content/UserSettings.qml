import QtQuick 2.5
import QtQuick.Controls 1.3 as QuickControls
import QtQuick.Layouts 1.1

import Material 0.2
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import zenlog.sqlmodel 1.0

NavigationDrawer {
    SqlModel {
        id: sqlModel
    }

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
                    id: name_text
                    anchors.centerIn: parent
                    width: parent.width
                    placeholderText: "姓名"
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_circle"
                }

                content:  RowLayout {
                    anchors.centerIn: parent
                    width: parent.width

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.1 * parent.width
                        text: "群"
                    }

                    TextField {
                        id: group_text
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.35 * parent.width
                        placeholderText: "群号"
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.1 * parent.width
                        text: "组"
                    }

                    TextField {
                        id: index_text
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.35 * parent.width
                        placeholderText: "编号"
                        characterLimit: 6
                        validator: IntValidator {bottom: 0; top: 999999;}
                    }
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "maps/place"
                }

                content: TextField {
                    id: address_text
                    anchors.centerIn: parent
                    width: parent.width
                    placeholderText: "地址"
                }
            }

            ListItem.Standard {
                action: Item {}

                content: RowLayout {
                    anchors.centerIn: parent
                    width: parent.width

                    TextField {
                        id: city_text
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.45 * parent.width
                        placeholderText: "城市"
                    }

                    /*
                    MenuField {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.2 * parent.width

                        model: ["NY", "NC", "ND"]
                    }
                    */

                    TextField {
                        id: postcode_text
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        placeholderText: "邮编"
                        characterLimit: 6
                        validator: IntValidator {bottom: 0; top: 999999;}
                    }
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "communication/email"
                }

                content: TextField {
                    id: email_text
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

                    QuickControls.ExclusiveGroup { id: optionGroup }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.24 * parent.width
                        text: "主修功课"
                    }

                    RadioButton {
                        id: radio_dabeizhou
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.36 * parent.width
                        text: "大悲咒"
                        canToggle: true
                        exclusiveGroup: optionGroup
                    }

                    RadioButton {
                        id: radio_fohao
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.36 * parent.width
                        text: "佛号"
                        canToggle: true
                        exclusiveGroup: optionGroup
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
                        Layout.preferredWidth: 0.24 * parent.width
                        text: "今年目标"
                    }

                    TextField {
                        id: targetcount_text
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.7 * parent.width
                        placeholderText: "目标"
                        characterLimit: 20
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

                Button {
                    text: "保存"
                    textColor: Theme.primaryColor
                    onClicked: {
                        if( group_text.text != '' && index_text != '') {
                            var course = radio_dabeizhou.checked ? radio_dabeizhou.text : radio_fohao.text
                            sqlModel.saveUser(group_text.text, index_text.text, name_text.text, address_text.text, city_text.text, email_text.text, targetcount_text.text, course);
                        }
                    }
                }
            }
        }
    }

    function reload() {
        var user = sqlModel.getCurrentUser();
        if( user !== null) {
            group_text.text = user.group
            index_text.text = user.index
            name_text.text = user.name
            address_text.text = user.address
            city_text.text = user.city
            email_text.text = user.email
            targetcount_text.text = user.targetCount
            if (user.courseName === radio_dabeizhou.text) {
                radio_dabeizhou.checked = true;
            } else {
                radio_fohao.checked = true;
            }
        }
    }

    Component.onCompleted: {
        reload();
    }
}
