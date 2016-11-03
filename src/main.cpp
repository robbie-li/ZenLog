#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQuickStyle>
#include "sqlmodel.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  //QQuickStyle::setStyle("material");

  qmlRegisterType<SqlModel>("zenlog.sqlmodel", 1, 0, "SqlModel");
  engine.addImportPath(QStringLiteral("qrc:/modules/"));
  engine.addImportPath(QStringLiteral(":/"));
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
  return app.exec();
}
