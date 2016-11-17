#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQuickStyle>
#include <QDebug>
#include "sqlmodel.h"
#include "user.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  //QQuickStyle::setStyle("material");

  qmlRegisterType<SqlModel>("zenlog.sqlmodel", 1, 0, "SqlModel");

  /*
  User* user = (User*)(new SqlModel())->getCurrentUser();
  if(user) {
      qDebug() << "Course Name" << user->courseName();
      engine.rootContext()->setContextProperty("currentUser", user);
  }
  */

  engine.addImportPath(QStringLiteral("qrc:/modules/"));
  engine.addImportPath(QStringLiteral(":/"));
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
