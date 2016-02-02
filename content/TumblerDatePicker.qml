import QtQuick 2.5
//import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Extras 1.4
import Material 0.2

Tumbler {
  id: root
  height: Units.dp(200)

  property int columnWidth: Units.dp(80)
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
    return /8|3|5|10/.test(--m)?30:m==1?(!(y%4)&&y%100)||!(y%400)?29:28:31;
  }

  function _handleTumblerChanges() {
    var curYear = yearColumn.currentIndex + yearList.get(0).value;
    var curMonth = monthColumn.currentIndex + 1;

    var d = _getDaysInMonth(curMonth, curYear);
    if (dayColumn.currentIndex >= d)
      root.setCurrentIndexAt(0, d-1);
    while (dayList.count > d)
      dayList.remove(dayList.count - 1)
    while (dayList.count < d)
      dayList.append({"value" : dayList.count + 1})
  }

  TumblerColumn {
    id: dayColumn
    width: root.columnWidth
    model: ListModel {
      id: dayList
    }
    onCurrentIndexChanged: {
      getSelectedDate();
    }
  }

  TumblerColumn {
    id: monthColumn
    width: root.columnWidth
    model: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    onCurrentIndexChanged: {
      root._handleTumblerChanges()
      getSelectedDate();
    }
  }

  TumblerColumn {
    id: yearColumn
    width: root.columnWidth
    model: ListModel {
      id: yearList
    }
    onCurrentIndexChanged: {
      root._handleTumblerChanges()
      getSelectedDate();
    }
  }

  Component.onCompleted: {
    _updateYearList();
    var curDate = new Date();
    root.setCurrentIndexAt(2, curDate.getFullYear() - root.minYear);
    root.setCurrentIndexAt(1, curDate.getMonth());
    root.setCurrentIndexAt(0, curDate.getDate()-1);
  }
}
