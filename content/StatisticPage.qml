import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.2
import robbie.calendar 1.0
import "../modules/QCharts"
import "../modules/QCharts/QChart.js"        as Charts

Rectangle {
    objectName: 'Statistic'
    visible: true
    width: 640
    height: 400

    color: "#f4f4f4"

    SqlEventModel {
        id: eventModel
    }

    property int chart_width: 300
    property int chart_height: 300

    function getLineData() {
        var ChartLineData = {
            labels: ["January","February","March","April","May","June","July"],
            datasets: [
                {
                    fillColor: "rgba(220,220,220,0.5)",
                    strokeColor: "rgba(220,220,220,1)",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#ffffff",
                    data: [65,59,90,81,56,55,40]
                },
                {
                    fillColor: "rgba(151,187,205,0.5)",
                    strokeColor: "rgba(151,187,205,1)",
                    pointColor: "rgba(151,187,205,1)",
                    pointStrokeColor: "#ffffff",
                    data: [28,48,40,19,96,27,100]
                }
            ]
        }
        return ChartLineData;
    }

    QChart {
        id: chart_line
        anchors.fill: parent
        chartAnimated: true
        chartAnimationEasing: Easing.InOutElastic
        chartAnimationDuration: 2000
        chartData: getLineData()
        chartType: Charts.ChartType.LINE
    }
}
