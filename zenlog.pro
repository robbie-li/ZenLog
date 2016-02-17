QT += qml quick sql xml svg core gui
TARGET = ZenLog
!no_desktop: QT += widgets
!contains(sql-drivers, sqlite): QTPLUGIN += qsqlite

include(src/src.pri)

OTHER_FILES += \
    main.qml \
    content/Calendar.qml \
    content/CalendarPage.qml \
    content/UserSettings.qml \
    content/DailyLogPage.qml \
    content/MainPage.qml \
    content/ListViewDelegate.qml \
    content/SimpleDatePicker.qml \
    content/StatisticPage.qml \
    content/TumblerDatePicker.qml

RESOURCES += \
    resources.qrc \
    modules/FontAwesome.qrc \
    modules/FontRoboto.qrc \
    modules/Icons.qrc \
    modules/Material.qrc \
    modules/MaterialQtQuick.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
