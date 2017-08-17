import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

import zenlog.model 1.0

import "controls"
import "dialogs"
import "pages"

ApplicationWindow {
    id: window

    property User currentUser: SqlModel.getCurrentUser()

    width: 540
    height: 960
    visible: true
    title: qsTr("精进修行")
    flags: Qt.FramelessWindowHint | Qt.Window

    Material.theme: Material.Light
    Material.accent:     "#66BAB7"
    Material.primary:    "#66BAB7"
    Material.background: "white"

    header: ToolBar {
        id: toolbar

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ImageButton {
                Layout.leftMargin: 4
                Layout.preferredHeight: 32
                Layout.preferredWidth: 32
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
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                color: "white"

                MouseArea {
                    anchors.fill: titleLabel
                    onClicked: {
                        currentUserSelection.open()
                    }
                }
            }

            ImageButton {
                Layout.rightMargin: 4
                Layout.preferredHeight: 32
                Layout.preferredWidth: 32
                source: "qrc:/Material/icons/navigation/more_vert.svg"
                onClicked: optionsMenu.open()
                opacity: stack.depth === 1 ? 1 : 0
                enabled: stack.depth === 1

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
                        enabled: false
                        onTriggered: importDialog.open()
                    }
                    MenuItem {
                        text: qsTr("导出功课")
                        enabled: false
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

    Drawer {
        id: drawer
        width: window.width * 3 / 4
        height: window.height
        UserInformation {
            id: user_info
            anchors.fill: parent
            onUserSaved: {
                drawer.close()
            }
        }
    }

    StackView {
        id: stack
        anchors.fill: parent

        initialItem: CalendarPage {
            id: calendar
            onDaySelected: {
                daily.selectDate(selectedDate)
                stack.push(daily)
            }
        }
    }

    DailyLogPage {
        id: daily
        visible: false
        onCourseChanged: {
            calendar.reload()
        }
    }

    CurrentUserSelection {
        id: currentUserSelection
        modal: true
        focus: true
        x: 50
        y: 0
        width: window.width - 100
        contentHeight: 230
    }

    UserManagementPage {
        id:userManagerment
        visible: false
    }

    AboutDialog {
        id: aboutDialog
        modal: true
        focus: true
        x: 0
        y: window.height / 12
        width: window.width
        contentHeight: 600
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

        onUserChanged: {
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
        if(currentUser === null) {
            stack.push(userManagerment)
        }
    }
}
