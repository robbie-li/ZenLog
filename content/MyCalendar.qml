/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Jordan Neidlinger <JNeidlinger@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import zenlog.sqlmodel 1.0

Calendar {
    id: calendar

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    Universal.theme: Universal.Dark
    Universal.accent: Universal.Pink

    SqlModel {
        id: sqlModel
    }

    function reload() {
        dataArr = sqlModel.courseCountForMonth(calendar.visibleYear, calendar.visibleMonth);
    }

    property var dataArr

    signal daySelected(date selectedDate)
    signal monthSelected(date selectedMonth)

    property int dayAreaBottomMargin : 0

    style: CalendarStyle {
        gridVisible: true

        property int calendarWidth: calendar.width
        property int calendarHeight: calendar.height

        background: Rectangle {
            color: "lightblue"
            implicitWidth: calendarWidth
            implicitHeight: calendarHeight
        }

        navigationBar: Rectangle {
            height: 60
            width: calendarWidth
            color: "lightgrey"

            ImageButton {
                id: previousMonth
                width: 60
                anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 0 }
                source: "qrc:/Material/icons/navigation/chevron_left.svg"
                onClicked: {
                    control.showPreviousMonth();
                    control.monthSelected(new Date(control.visibleYear, control.visibleMonth, 1));
                    reload()
                }
            }

            Label {
                anchors.centerIn: parent
                id: dayTitle
                font.weight: Font.DemiBold
                font.pixelSize: 36
                Layout.fillWidth: true
                lineHeight: 0.9
                wrapMode: Text.Wrap
                text: styleData.title
            }

            ImageButton {
                id: nextMonth
                width: 60
                anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 0 }
                source: "qrc:/Material/icons/navigation/chevron_right.svg"
                onClicked: {
                    control.showNextMonth();
                    control.monthSelected(new Date(control.visibleYear, control.visibleMonth, 1))
                    reload()
                }
            }
        }

        dayOfWeekDelegate: Rectangle {
            color: "transparent"
            implicitHeight: 30
            Label {
                text: control.__locale.dayName(styleData.dayOfWeek, Locale.NarrowFormat)
                color: "blue"
                anchors.centerIn: parent
            }
        }

        dayDelegate: Rectangle {
            visible: styleData.visibleMonth
            height: 60
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: styleData.selected ? "red" : "transparent"
            }

            Label {
                id: dayText
                height: parent.height * 6 / 10
                anchors {
                    top: parent.top;
                    horizontalCenter: parent.horizontalCenter
                }
                text: styleData.date.getDate()
                font.pixelSize: 22
                color: styleData.selected? "white" : styleData.today? "blue" : "black"
            }

            Label {
                id: dayCount
                anchors {
                    top: dayText.bottom
                    right: parent.right
                    bottom:parent.bottom
                }
                text: calendar.dataArr[styleData.date.getDate()] ? calendar.dataArr[styleData.date.getDate()] : ""
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                color: styleData.selected? "white" : "black"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    calendar.daySelected(styleData.date);
                }
            }
        }
    }

    Component.onCompleted: {
        reload()
    }
}
