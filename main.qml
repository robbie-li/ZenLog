import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0
import Qt.labs.settings 1.0
import "content"

ApplicationWindow {
    id: window

    visible: true
    height: 960
    width: 540
    //width: Screen.desktopAvailableWidth
    //height: Screen.desktopAvailableHeight

    title: "精进修行"

    header: ToolBar {
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/Material/icons/navigation/menu.svg"
                }
                onClicked: drawer.open()
            }

            Label {
                id: titleLabel
                text: "精进修行"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/Material/icons/navigation/more_vert.svg"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "设置"
                        onTriggered: settingsPopup.open()
                    }
                    MenuItem {
                        text: "关于"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height

        UserSettings {
            onUserSettingsChanged: {
                daily.reloadUserSetting()
            }
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
}
