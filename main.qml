import QtQuick 2.8
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0

import "content"

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
                        text: qsTr("设置")
                        onTriggered: settingsPopup.open()
                    }
                    MenuItem {
                        text: qsTr("关于")
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                text: qsTr("关于")
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: "精进群修行日志."
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }

            Label {
                width: aboutDialog.availableWidth
                text: "主页: http://www.github.com/robbie-li/zenlog"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("日历")
        }
        TabButton {
            text: qsTr("日志")
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
        UserSettings {
            onUserSettingsChanged: {
                console.log("user setting saved")
                daily.reloadUserSetting()
                drawer.close()
                reloadTitle()
                calendar.reloadStatistic()
            }
        }
    }

    function reloadTitle() {
        var user = SqlModel.getCurrentUser()
        if(user) {
            titleLabel.text = user.name + "的" + user.courseName + "日志"
        } else {
            titleLabel.text = "精进日志"
        }
    }

    Component.onCompleted: {
        reloadTitle()
        daily.reloadUserSetting()
    }
}
