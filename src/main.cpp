#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "sqleventmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<SqlEventModel>("robbie.calendar", 1, 0, "SqlEventModel");
    engine.addImportPath(QStringLiteral("qrc:/modules/"));
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
