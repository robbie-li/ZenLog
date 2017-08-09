#include <QtCore>
#include <QtGui>
#include <QtQml>
#include <QQuickStyle>

#include "model/course.h"
#include "model/course_model.h"
#include "model/sql_model.h"
#include "model/user.h"
#include "model/user_model.h"

#include "utils/clipboard.h"
#include "utils/mail_client.h"
#include "utils/excel_reader.h"

// First, define the singleton type provider function (callback).
static QObject* sqlmodel_singletontype_provider(QQmlEngine* engine, QJSEngine* scriptEngine) {
  Q_UNUSED(engine)
  Q_UNUSED(scriptEngine)

  return SqlModel::instance();
}

static QObject* clipboard_singletontype_provider(QQmlEngine* engine, QJSEngine* scriptEngine) {
  Q_UNUSED(engine)
  Q_UNUSED(scriptEngine)

  Clipboard* clipboard = new Clipboard;
  return clipboard;
}

int main(int argc, char* argv[]) {
  QGuiApplication::setApplicationName("ZenLog");
  QGuiApplication::setOrganizationName("com.github/robbie-li");
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  QQuickStyle::setStyle("Material");

  qmlRegisterSingletonType<SqlModel> ("zenlog.model",  1, 0, "SqlModel",  sqlmodel_singletontype_provider);
  qmlRegisterSingletonType<Clipboard>("zenlog.utils", 1, 0, "ClipBoard", clipboard_singletontype_provider);
  qmlRegisterType<Course>("zenlog.model", 1, 0, "Course");
  qmlRegisterType<CourseModel>("zenlog.model", 1, 0, "CourseModel");
  qmlRegisterType<User>("zenlog.model", 1, 0, "User");
  qmlRegisterType<UserModel>("zenlog.model", 1, 0, "UserModel");

  QQmlFileSelector* selector = new QQmlFileSelector(&engine);
  //selector->setSelector()


  QFileSelector sel;
  qDebug() << sel.allSelectors();

  engine.addImportPath(QStringLiteral("qrc:/modules/"));
  engine.addImportPath(QStringLiteral(":/"));

  engine.load(QUrl(QStringLiteral("qrc:/content/main.qml")));
  if (engine.rootObjects().isEmpty())
    return -1;

  return app.exec();
}
