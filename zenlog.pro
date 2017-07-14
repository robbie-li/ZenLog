QT += qml quick sql xml svg core gui quickcontrols2 network axcontainer
TARGET = ZenLog
!no_desktop: QT += widgets
!contains(sql-drivers, sqlite): QTPLUGIN += qsqlite

include(src/src.pri)
include(smtpclient/smtpclient.pri)

OTHER_FILES += \
    main.qml \
    content/qmldir \
    content/CalendarPage.qml \
    content/DailyLogPage.qml \
    content/ListViewDelegate.qml \
    content/MyCalendar.qml \
    content/SimpleDatePicker.qml \
    content/TumblerDatePicker.qml\
    content/UserInformation.qml \
    content/UserSetting.qml \
    content/UserSettings.qml\
    content/controls/ImageButton.qml \
    content/controls/ImageTextButton.qml

RESOURCES += \
    modules/Icons.qrc \
    resources.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    +android/qtquickcontrols2.conf \
    +windows/qtquickcontrols2.conf


ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

