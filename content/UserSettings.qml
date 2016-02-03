import QtQuick 2.5
import QtQuick.Controls 1.3 as QuickControls
import QtQuick.Layouts 1.1

import Material 0.2
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import zenlog.sqlmodel 1.0

NavigationDrawer {
    id: root

    SqlModel {
        id: sqlModel
    }

    signal userSettingsChanged()

    globalMouseAreaEnabled: false

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

            ListItem.Standard {
                content:  RowLayout {
                    anchors.centerIn: parent
                    width: parent.width
                    spacing: Units.dp(2)

                    Label {
                        Layout.alignment: Qt.AlignLeft
                        text: "个人信息"
                        style: "title"
                    }

                    Button {
                        Layout.alignment: Qt.AlignRight
                        Layout.preferredWidth: 0.2 * parent.width
                        text: "保存"
                        textColor: "black"
                        backgroundColor: Theme.primaryColor
                        onClicked: {
                            if( qq_text.text != '' ) {
                                var course = radio_dabeizhou.checked ? radio_dabeizhou.text : radio_fohao.text
                                sqlModel.saveUser(qq_text.text, group_index.selectedIndex+1, index_text.text, name_text.text, address_text.text, city_text.text, email_text.text, targetcount_text.text, course);
                                root.userSettingsChanged()
                                root.toggle()
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Units.dp(8)
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "awesome/qq"
                }

                content:  RowLayout {
                    anchors.centerIn: parent
                    width: parent.width
                    spacing: Units.dp(2)

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        text: "QQ"
                    }

                    TextField {
                        id: qq_text
                        width: Units.dp(50)
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        placeholderText: "QQ"
                        inputMethodHints: Qt.ImhDigitsOnly
                    }
                }
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
                    name: "awesome/anchor"
                }

                content:  RowLayout {
                    anchors.centerIn: parent
                    width: parent.width
                    spacing: Units.dp(2)

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: "精进群"
                    }

                    MenuField {
                        id: group_index
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.2 * parent.width
                        model: ["一组", "二组", "三组"]
                    }

                    Label {
                        Layout.alignment: Qt.AlignLeft
                        text: "组内编号:"
                    }

                    TextField {
                        id: index_text
                        width: Units.dp(50)
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        placeholderText: "编号"
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: IntValidator {bottom: 0; top: 10000;}
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
                height: Units.dp(72)

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

                    TextField {
                        id: postcode_text
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        placeholderText: "邮编"
                        inputMethodHints: Qt.ImhDigitsOnly
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
                    name: "awesome/graduation_cap"
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
                height: Units.dp(72)

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
                        inputMethodHints: Qt.ImhDigitsOnly
                    }
                }
            }
        }
    }

    function reload() {
        var user = sqlModel.getCurrentUser();
        if( user !== null) {
            qq_text.text = user.qq
            group_index.selectedIndex = user.group - 1
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
