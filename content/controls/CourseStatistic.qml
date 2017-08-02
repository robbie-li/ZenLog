import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.sqlmodel 1.0

Pane {
    id: statitisc_pane

    background: Rectangle {
        anchors.fill: parent
        color: "#EFEFEF"
    }

    Column {
        anchors.fill: parent
        anchors.topMargin: 2
        spacing: 10

        GridLayout {
            width: parent.width

            columns: 4
            rowSpacing: 20
            columnSpacing: 5

            Label {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: "当月总计"
                color: "#696969"
            }

            Label {
                id: monthly_total
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: SqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
                color: "#696969"
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: "当月日均"
                color: "#696969"
            }

            Label {
                id: monthly_average
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: SqlModel.courseAverageForMonth(calendar.visibleYear, calendar.visibleMonth)
                color: "#696969"
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: "当年总计"
                color: "#696969"
            }

            Label {
                id: yearly_total
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: SqlModel.courseTotalForYear(calendar.visibleYear)
                color: "#696969"
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: "当年平均"
                color: "#696969"
            }

            Label {
                id: yearly_average
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: SqlModel.courseAverageForYear(calendar.visibleYear)
                color: "#696969"
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: "历史总计"
                color: "#696969"
            }

            Label {
                id: historic_total
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: SqlModel.courseTotal()
                color: "#696969"
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: "历史平均"
                color: "#696969"
            }

            Label {
                id: historic_average
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 0.25 * parent.width
                text: SqlModel.courseAverage()
                color: "#696969"
            }
        }

        ColumnLayout {
            width: parent.width

            Button {
                background: Rectangle {
                    color: "#B2E0E0"
                    anchors.fill: parent
                    opacity: enabled ? 1 : 0.3
                }

                implicitHeight: 35
                width: parent.width
                Layout.margins: 4
                Layout.fillWidth: true

                contentItem: Label {
                    anchors.fill: parent
                    opacity: enabled ? 1.0 : 0.3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("复制当月记录")
                    height: 32
                    color: "#287B7B"
                    font.pixelSize: 22
                }

                onClicked: {
                    ClipBoard.copyMonthlyCourse(calendar.visibleYear, calendar.visibleMonth)
                    clipboard_status.status = true
                    clipboard_timer.start()
                    clipboard_status.open()
                }
            }
        }
    }

    function reload() {
        monthly_total.text = SqlModel.courseTotalForMonth(calendar.visibleYear, calendar.visibleMonth)
        monthly_average.text = SqlModel.courseAverageForMonth(calendar.visibleYear, calendar.visibleMonth)
        yearly_total.text = SqlModel.courseTotalForYear(calendar.visibleYear)
        yearly_average.text = SqlModel.courseAverageForYear(calendar.visibleYear)
        historic_average.text = SqlModel.courseAverage()
        historic_total.text = SqlModel.courseTotal()
    }
}
