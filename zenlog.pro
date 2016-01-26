QT += qml quick sql
TARGET = ZenLog
!no_desktop: QT += widgets
!contains(sql-drivers, sqlite): QTPLUGIN += qsqlite

include(src/src.pri)

OTHER_FILES += \
    main.qml \
    content/CalendarPage.qml \
    content/UserSettings.qml \
    content/DailyLogPage.qml \
    content/MainPage.qml \
    content/MyButton.qml \
    content/ListViewDelegate.qml \
    content/SimpleDatePicker.qml \
    content/StatisticPage.qml

RESOURCES += \
    resources.qrc \
    material.qrc
