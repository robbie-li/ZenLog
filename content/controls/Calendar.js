var ChartBarData = {
    labels: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
    datasets: [{
            fillColor: "rgba(220,220,220,0.5)",
            strokeColor: "rgba(220,220,220,1)",
            data: []
        }]
}

function getYearStatistic(curdate) {
    var c = sqlModel.monthlyCourseCountForYear(curdate);
    for( var i = 0; i < 12; ++i) {
        ChartBarData.datasets[0].data.push(c[i]);
    }

    // = [1,2,3,4,5,6,7,8,9,10,11,12]
    return ChartBarData;
}
