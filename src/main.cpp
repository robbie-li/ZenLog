#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQuickStyle>
#include <QDebug>
#include "mailclient.h"
#include "sqlmodel.h"
#include "user.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setAttribute(Qt::AA_EnableHighDpiScaling);

  QQmlApplicationEngine engine;
  QQuickStyle::setStyle("Material");

  qmlRegisterType<SqlModel>("zenlog.sqlmodel", 1, 0, "SqlModel");
  qmlRegisterType<MailClient>("zenlog.mailclient", 1, 0, "MailClient");

  engine.addImportPath(QStringLiteral("qrc:/modules/"));
  engine.addImportPath(QStringLiteral(":/"));
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
