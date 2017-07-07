#include <QtCore>
#include <QtGui>
#include <QtQml>
#include <QQuickStyle>

#include "clipboard.h"
#include "course.h"
#include "mailclient.h"
#include "sqlmodel.h"
#include "user.h"
#include "excelreader.h"

// First, define the singleton type provider function (callback).
static QObject* sqlmodel_singletontype_provider(QQmlEngine* engine, QJSEngine* scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    SqlModel* model = new SqlModel;
    return model;
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

    qmlRegisterSingletonType<SqlModel> ("zenlog.sqlmodel",  1, 0, "SqlModel",  sqlmodel_singletontype_provider);
    qmlRegisterSingletonType<Clipboard>("zenlog.clipboard", 1, 0, "ClipBoard", clipboard_singletontype_provider);
    qmlRegisterType<MailClient>("zenlog.mailclient", 1, 0, "MailClient");
    qmlRegisterType<User>("zenlog.user", 1, 0, "User");
    qmlRegisterType<Course>("zenlog.course", 1, 0, "Course");

    engine.addImportPath(QStringLiteral("qrc:/modules/"));
    engine.addImportPath(QStringLiteral(":/"));

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
