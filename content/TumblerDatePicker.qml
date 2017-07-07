import QtQuick 2.8
import QtQuick.Controls 2.1

Rectangle {
    id: root
    height: 200
    width: columnWidth*3 + 20
    border.width: 1
    color: "transparent"

    property int columnWidth: 80
    property int minYear: 2000
    property int maxYear: 2050

    property alias year: yearColumn.currentIndex
    property alias month: monthColumn.currentIndex
    property alias day: dayColumn.currentIndex

    function getSelectedDate() {
        return  new Date(year+minYear, month, day+1);
    }

    function _updateYearList() {
        for (var i = root.minYear; i <= root.maxYear; ++i)
            yearList.append({"value" : i})
    }

    function _getDaysInMonth(m, y) {
        return /8|3|5|10/.test(--m)?30:m===1?(!(y%4)&&y%100)||!(y%400)?29:28:31;
    }

    function _handleTumblerChanges() {
        var curYear = yearColumn.currentIndex + yearList.get(0).value;
        var curMonth = monthColumn.currentIndex + 1;

        var d = _getDaysInMonth(curMonth, curYear);
        if (dayColumn.currentIndex >= d)
            dayColumn.currentIndex = d - 1
        while (dayList.count > d)
            dayList.remove(dayList.count - 1)
        while (dayList.count < d)
            dayList.append({"value" : dayList.count + 1})
    }

    Row {
        anchors.fill: parent

        Tumbler {
            id: yearColumn
            width: root.columnWidth
            height: root.height
            model: ListModel {
                id: yearList
            }
            onCurrentIndexChanged: {
                root._handleTumblerChanges()
                getSelectedDate();
            }
        }

        Tumbler {
            id: monthColumn
            width: root.columnWidth
            height: root.height
            model: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
            onCurrentIndexChanged: {
                root._handleTumblerChanges()
                getSelectedDate();
            }
        }

        Tumbler {
            id: dayColumn
            width: root.columnWidth
            height: root.height
            model: ListModel {
                id: dayList
            }
            onCurrentIndexChanged: {
                getSelectedDate();
            }
        }
    }

    Component.onCompleted: {
        _updateYearList();
        var curDate = new Date();
        yearColumn.currentIndex = curDate.getFullYear() - root.minYear;
        monthColumn.currentIndex = curDate.getMonth();
        dayColumn.currentIndex = curDate.getDate() - 1;
    }
}
