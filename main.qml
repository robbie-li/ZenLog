import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Universal 2.2
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0
import zenlog.usermodel 1.0
import zenlog.user 1.0

import "content"
import "content/controls"
import "content/dialogs"

ApplicationWindow {
    id: window

    width: 540
    height: 960
    visible: true

    Universal.theme: Universal.Dark

    Material.theme: Material.Light
    Material.accent:     "#66BAB7"
    Material.primary:    "#66BAB7"
    Material.background: "white"

    property User currentUser: SqlModel.getCurrentUser()

    title: qsTr("精进修行")

    header: ToolBar {
        id: toolbar
        contentHeight: 32

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ImageButton {
                Layout.leftMargin: 4
                size: 28
                source: stack.depth > 1 ? "qrc:/Material/icons/navigation/chevron_left.svg" : "qrc:/Material/icons/navigation/menu.svg"
                onClicked: {
                    if (stack.depth > 1) {
                        stack.pop()
                    } else {
                        drawer.open()
                    }
                }
            }

            Label {
                id: titleLabel
                text: qsTr("精进修行")
                font.pixelSize: 18
                font.bold: true
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: "white"
            }

            ImageButton {
                Layout.rightMargin: 4
                size: 28
                source: "qrc:/Material/icons/navigation/more_vert.svg"
                onClicked: optionsMenu.open()
                visible: stack.depth === 1

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight
                    MenuItem {
                        text: qsTr("用户管理")
                        onTriggered: stack.push(userManagerment)
                    }
                    MenuItem {
                        text: qsTr("导入功课")
                        onTriggered: importDialog.open()
                    }
                    MenuItem {
                        text: qsTr("导出功课")
                        onTriggered: exportDialog.open()
                    }
                    MenuItem {
                        text: qsTr("关于")
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    UserManagementPage {
        id:userManagerment
    }

    AboutDialog {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 4 * 3
        contentHeight: 300
    }
    
    StackView {
        id: stack

        initialItem: CalendarPage {
            id: calendar
            onDaySelected: {
                daily.selectDate(selectedDate)
                stack.push(daily)
            }
        }

        anchors.fill: parent
    }

    DailyLogPage {
        id: daily
        visible: false
        onCourseChanged: {
            calendar.reload()
        }
    }

    Drawer {
        id: drawer
        width: window.width * 3 / 4
        height: window.height
        UserInformation {
            id: user_info
            anchors.fill: parent
        }
    }

    function reloadTitle() {
        var user = SqlModel.getCurrentUser()
        if(user) {
            titleLabel.text = user.name + "的" + user.courseName + "日志"
        } else {
            console.log("failed to get current user")
            titleLabel.text = "精进日志"
        }
    }

    Connections {
        target: SqlModel

        onUserUpdated: {
            console.log("user changed")
            reloadTitle()
        }
    }

    onClosing: {
        if(stack.depth > 1) {
            close.accepted = false;
            stack.pop();
        } else {
            return;
        }
    }

    Component.onCompleted: {
        reloadTitle()
    }
}
