QT += qml quick sql xml svg core gui quickcontrols2 network axcontainer
TARGET = ZenLog
!no_desktop: QT += widgets
!contains(sql-drivers, sqlite): QTPLUGIN += qsqlite

include(src/src.pri)
include(smtpclient/smtpclient.pri)

OTHER_FILES += \
    main.qml

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

