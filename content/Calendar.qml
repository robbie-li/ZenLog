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
import QtQuick.Controls 1.3 as Controls
import QtQuick.Controls.Styles.Material 0.1 as MaterialStyle
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Private 1.0
import Material 0.2
import zenlog.sqlmodel 1.0

Controls.Calendar {
    id: calendar

    SqlModel {
        id: sqlModel
    }

    signal daySelected(date selectedDate)
    signal monthSelected(date selectedMonth)

    property int dayAreaBottomMargin : 0

    style: CalendarStyle {
        gridVisible: false

        property int calendarWidth: calendar.width
        property int calendarHeight: calendar.height

        background: Rectangle {
            color: "white"
            implicitWidth: calendarWidth
            implicitHeight: calendarHeight
        }

        navigationBar: Rectangle {
            height: Units.dp(60)
            width: calendarWidth
            color: Theme.accentColor

            IconButton {
                id: previousMonth
                anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: Units.dp(16) }
                size: Units.dp(48)
                iconName: "navigation/chevron_left"
                onClicked: {
                    control.showPreviousMonth();
                    control.monthSelected(new Date(control.visibleYear, control.visibleMonth, 1));
                }
            }

            Label {
                anchors.centerIn: parent
                id: dayTitle
                font.weight: Font.DemiBold
                font.pixelSize: Units.dp(36)
                Layout.fillWidth: true
                lineHeight: 0.9
                wrapMode: Text.Wrap
                color: Theme.dark.textColor
                text: styleData.title
            }

            IconButton {
                id: nextMonth
                anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: Units.dp(16) }
                size: Units.dp(48)
                iconName: "navigation/chevron_right"
                onClicked: {
                    control.showNextMonth();
                    control.monthSelected(new Date(control.visibleYear, control.visibleMonth, 1))
                }
            }
        }

        dayOfWeekDelegate: Rectangle {
            color: "transparent"
            implicitHeight: Units.dp(30)
            Label {
                text: control.__locale.dayName(styleData.dayOfWeek, Locale.NarrowFormat)
                color: Theme.light.subTextColor
                anchors.centerIn: parent
            }
        }

        dayDelegate: Rectangle {
            visible: styleData.visibleMonth
            height: Units.dp(60)

            Rectangle {
                anchors.fill: parent
                color: styleData.selected ? Theme.accentColor : "transparent"
            }

            Label {
                id: dayText
                height: parent.height * 6 / 10
                anchors {
                    top: parent.top;
                    horizontalCenter: parent.horizontalCenter
                }
                text: styleData.date.getDate()
                color: styleData.selected? "white" : styleData.today? Theme.accentColor : "black"
            }

            Label {
                id: dayCount
                width: parent.width
                anchors {
                    top: dayText.bottom
                    bottom:parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                style: "caption"
                function getText(date) {
                    var value = sqlModel.courseCountForDate(date);
                    //console.log("query date:"+date, "got:"+value);
                    if( value === 0) return ""
                    else return value.toString()
                }
                text:  getText(styleData.date)
                //elide: Text.ElideRight
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
}
