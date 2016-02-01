#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "sqlmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<SqlModel>("zenlog.sqlmodel", 1, 0, "SqlModel");
    engine.addImportPath(QStringLiteral("qrc:/modules/"));
    //engine.addImportPath(QStringLiteral("qrc:/Material/modules/"));
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    //engine.set

    return app.exec();
}
