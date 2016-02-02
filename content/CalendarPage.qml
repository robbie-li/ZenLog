import QtQuick 2.4
import Material 0.2
import zenlog.sqlmodel 1.0
import "."

Page {
    id: root
    title: "每月视图"

    signal daySelected(date selectedDate)
    Calendar {
        width: parent.width
        height: parent.height /2
        onDaySelected: {
            root.daySelected(selectedDate);
            pageStack.pop();
        }
    }
}
