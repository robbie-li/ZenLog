import QtQuick 2.5
import QtQuick.Controls 1.3 as QuickControls
import QtQuick.Layouts 1.1

import Material 0.2
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1

import zenlog.sqlmodel 1.0

import "../modules/QCharts"
import "../modules/QCharts/QChart.js" as Charts
import "Calendar.js" as Data

Page {
    id: root
    title: "每月视图"

    SqlModel {
        id: sqlModel
    }

    Calendar {
        id: calendar

        width: parent.width
        height: parent.height /2
        onDaySelected: {
            pageStack.pop();
            pageStack.currentItem.selectDate(selectedDate)
        }
        onMonthSelected: {
            mounth_count.text = sqlModel.courseCountForMonth(selectedMonth)
            year_count.text = sqlModel.courseCountForYear(selectedMonth)
        }
    }

    View {
        anchors.top: calendar.bottom

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
                        text: "统计"
                        style: "title"
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
                    name: "awesome/calendar"
                }

                content:  RowLayout {
                    anchors.centerIn: parent
                    width: parent.width
                    spacing: Units.dp(2)

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.2 * parent.width
                        text: "当月总计"
                    }

                    Label {
                        id: mounth_count
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        text: sqlModel.courseCountForMonth(calendar.selectedDate)
                    }
                }
            }

            ListItem.Standard {
                action: Icon {
                    anchors.centerIn: parent
                    name: "awesome/calendar"
                }

                content:  RowLayout {
                    anchors.centerIn: parent
                    width: parent.width
                    spacing: Units.dp(2)

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.2 * parent.width
                        text: "年度总计"
                    }

                    Label {
                        id: year_count
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: 0.5 * parent.width
                        text: sqlModel.courseCountForYear(calendar.selectedDate)
                    }
                }
            }

            Chart {
                  id: chart_bar
                  width: 300
                  height: 300
                  chartAnimated: true
                  chartAnimationEasing: Easing.OutBounce
                  chartAnimationDuration: 2000
                  chartData: Data.getYearStatistic(calendar.selectedDate)
                  chartType: Charts.ChartType.BAR
            }
        }
    }
}
