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

    property User currentUser: UserModel.getCurrentUser()

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
                source: "qrc:/Material/icons/navigation/menu.svg"
                onClicked: drawer.open()
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

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight
                    MenuItem {
                        text: qsTr("用户管理")
                        onTriggered: userDialog.open()
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

    UserManagementDialog {
        id: userDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height *1 /12
        width: Math.min(window.width, window.height) / 4 * 3
        contentHeight: 400
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
    
    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("统计")
        }
        TabButton {
            text: qsTr("记录")
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        CalendarPage {
            id: calendar
        }

        DailyLogPage {
            id: daily
            onCourseChanged: {
                calendar.reload()
            }
        }
    }

    Drawer {
        id: drawer
        width: window.width * 3 / 4
        height: window.height
        UserInformation {
            anchors.fill: parent
        }
    }

    function reloadTitle() {
        var user = UserModel.getCurrentUser()
        if(user) {
            titleLabel.text = user.name + "的" + user.courseName + "日志"
        } else {
            titleLabel.text = "精进日志"
        }
    }

    Component.onCompleted: {
        reloadTitle()
        daily.reloadUserSetting()

        if(currentUser === null) {
            drawer.open()
        }
    }
}
