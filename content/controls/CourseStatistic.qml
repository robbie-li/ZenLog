import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import zenlog.model 1.0
import zenlog.utils 1.0

Pane {
    id: statitisc_pane

    property User currentUser: SqlModel.getCurrentUser()
    property int year
    property int month

    onYearChanged: {
        reload()
    }

    onMonthChanged: {
        reload()
    }

    Connections {
        target: SqlModel
        onUserChanged: {
            currentUser = SqlModel.getCurrentUser()
            if(currentUser != null) {
                reload()
            }
        }
    }

    visible: currentUser != null

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
                text: SqlModel.courseTotalForMonth(currentUser.userId, year, month)
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
                text: SqlModel.courseAverageForMonth(currentUser.userId, year, month)
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
                text: SqlModel.courseTotalForYear(currentUser.userId, year)
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
                text: SqlModel.courseAverageForYear(currentUser.userId, year)
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
                text: SqlModel.courseTotal(currentUser.userId)
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
                text: SqlModel.courseAverage(currentUser.userId)
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
                    var res = ClipBoard.copyMonthlyCourse(year, month)
                    clipboard_status.show(res)
                }
            }
        }
    }

    function reload() {
        if(currentUser === null) return;

        monthly_total.text = SqlModel.courseTotalForMonth(currentUser.userId, year, month)
        monthly_average.text = SqlModel.courseAverageForMonth(currentUser.userId, year, month)
        yearly_total.text = SqlModel.courseTotalForYear(currentUser.userId, year)
        yearly_average.text = SqlModel.courseAverageForYear(currentUser.userId, year)
        historic_average.text = SqlModel.courseAverage(currentUser.userId)
        historic_total.text = SqlModel.courseTotal(currentUser.userId)
    }
}
