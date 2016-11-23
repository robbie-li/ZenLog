#include "sqlmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>
#include "user.h"

namespace {
static bool connected = false;
}

SqlModel::SqlModel() : QSqlQueryModel() {
    if(!connected) {
        connected = createConnection();
        if(connected) {
            createTables();
        } else {
            qFatal("failed to connect database.");
        }
    }
}

QObject* SqlModel::getCurrentUser()
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM User");

    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << ("failed to load user") << query.lastError();
    }

    if(query.first()) {
        User *user = new User(this);
        user->set_qq(query.value("qq").toInt());
        user->set_group(query.value("group_num").toInt());
        user->set_index(query.value("group_idx").toInt());
        user->set_name(query.value("name").toString());
        user->set_city(query.value("city").toString());
        user->set_email(query.value("email").toString());
        user->set_address(query.value("address").toString());
        user->set_targetCount(query.value("target_count").toInt());
        user->set_courseName(query.value("course_name").toString());
        return user;
    }

    return NULL;
}

bool SqlModel::saveUser(int qq, int group, int index, const QString& name,
                        const QString& email,
                        int targetCount, const QString& courseName) {
    const QString sqlSelect = QString::fromLatin1("SELECT * FROM User");

    QSqlQuery query;
    if (!query.exec(sqlSelect)) {
        qDebug() << "failed to query user for save" << query.lastError();
    }

    QString sqlSave;
    if(query.first()) {
        sqlSave  = QString::fromLatin1("update User set "
                                       "group_num='%2',"
                                       "group_idx='%3',"
                                       "name='%4',"
                                       "address='%5',"
                                       "target_count='%6',"
                                       "course_name='%7'"
                                       " where qq='%1'")
                .arg(QString::number(qq), QString::number(group), QString::number(index), name, email, QString::number(targetCount), courseName);
    } else {
        sqlSave = QString::fromLatin1("insert into User (qq, group_num, group_idx, name, email, target_count, course_name) values('%1', '%2', '%3', '%4', '%5', '%6', '%7')")
                .arg(QString::number(qq), QString::number(group), QString::number(index), name, email, QString::number(targetCount), courseName);
    }

    qDebug() << "Executing:" << sqlSave;

    bool success = query.exec(sqlSave);
    if(success) {
        qDebug() << "user saved.";
        emit userSaved();
    } else {
        qDebug() << "Failed to execute SQL:" << query.lastError();
    }

    return success;
}

int SqlModel::courseCountForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT sum(course_count) FROM Course WHERE '%1' == course_date").arg(date.toString("yyyy-MM-dd"));

    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug("Query failed");
    }

    int totalCount = 0;

    if (query.first()) {
        totalCount = query.value(0).toInt();
    }

    return totalCount;
}

int SqlModel::courseTotalForMonth(const int year, const int month)
{
    const QString queryStr = QString::fromLatin1("SELECT sum(course_count) FROM (SELECT course_count, strftime(\"%Y-%m\", course_date) as cd from Course) WHERE '%1-%2' == cd").arg(year, 4).arg(month, 2);

    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << "Query failed: " << query.lastError();
    }

    int totalCount = 0;

    if (query.first()) {
        totalCount = query.value(0).toInt();
    }

    return totalCount;
}

int SqlModel::courseTotalForYear(const int year)
{
    const QString queryStr = QString::fromLatin1("SELECT sum(course_count) FROM (SELECT course_count, strftime(\"%Y\", course_date) as cd from Course) WHERE '%1' == cd").arg(year, 4);

    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug("Query failed");
    }

    int totalCount = 0;

    if (query.first()) {
        totalCount = query.value(0).toInt();
    }

    return totalCount;
}

QList<int> SqlModel::monthlyCourseCountForYear(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT sum(course_count) as sm, strftime(\"%Y-%m\", course_date) as cd,strftime(\"%Y\", course_date) as cy from Course WHERE '%1' = cy group by cd ").arg(date.toString("yyyy"));

    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << "Query failed" << query.lastError();
    }

    QList<int> courses;
    for(int i = 0; i < 12; ++i ) {
        courses.append(0);
    }

    while (query.next()) {
        QString month = query.value("cd").toString();
        int m = month.right(2).toInt();
        int c = query.value("sm").toInt();
        courses[m-1] = c;
    }

    return courses;
}

QList<QObject*> SqlModel::coursesForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Course WHERE course_date = '%1'").arg(date.toString("yyyy-MM-dd"));

    //qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << "Failed to load course" << query.lastError();
    }

    QList<QObject*> courses;
    while (query.next()) {
        Course *course = new Course(this);
        course->set_index(query.value("id").toInt());
        course->set_name(query.value("course_name").toString());
        course->set_count(query.value("course_count").toInt());

        QDateTime date;
        date.setDate(query.value("course_date").toDate());
        course->set_date(date);
        courses.append(course);
    }

    return courses;
}

QVariantMap SqlModel::courseCountForMonth(const int year, const int month)
{
    const QString queryStr = QString::fromLatin1("SELECT sum(course_count) as sm, strftime('%d', course_date) as cd from Course WHERE strftime('%Y-%m', course_date) = '%1-%2' group by cd").arg(year, 4).arg(month + 1, 2);

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << "Failed to query course" << query.lastError();
    }

    QVariantMap courses;
    while (query.next()) {
        int course_day = query.value(1).toInt();
        int course_count = query.value(0).toInt();
        qDebug() << "Course Day:" << course_day << ", Sum:" << course_count;
        courses.insert(QString::number(course_day), QVariant::fromValue(course_count));
    }

    return courses;
}

bool SqlModel::createConnection()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("zenlog.db");
    return db.open();
}

bool SqlModel::createTables()
{
    QSqlQuery query;

    if(!query.exec("CREATE TABLE IF NOT EXISTS Course (id INTEGER PRIMARY KEY AUTOINCREMENT, course_name TEXT, course_date DATE, course_count INTEGER)")) {
        qDebug() << "Failed to create course table" << query.lastError();
    }

    if(!query.exec("CREATE TABLE IF NOT EXISTS User (qq INTEGER, group_num INTEGER, group_idx INTEGER, name TEXT, city TEXT, address TEXT, email TEXT, course_name TEXT, target_count INTEGER)")) {
        qDebug() << "Failed to create user table:" << query.lastError();
    }

    return true;
}

bool SqlModel::addCourse(const QDate &date, const QString& name, const int count)
{
    const QString queryStr = QString::fromLatin1("insert into Course (course_name,course_date,course_count) values('%1', '%2', '%3')").arg(name, date.toString("yyyy-MM-dd"), QString::number(count));
    qDebug() << "Executing:" << queryStr;
    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << query.lastError().text();
        return false;
    }

    emit courseChanged();
    return true;
}

bool SqlModel::updateCourse(const QDate &date, const QString& name, const int count)
{
    const QString sqlDelete = QString::fromLatin1("delete from Course where course_date = '%2' and course_name = '%1'").arg(name, date.toString("yyyy-MM-dd"));

    QSqlQuery query;
    qDebug() << "Executing:" << sqlDelete;

    if (!query.exec(sqlDelete)) {
        qDebug() << "Failed to execute SQL:" << query.lastError();
        return false;
    }

    const QString sqlUpdate = QString::fromLatin1("insert into Course (course_date, course_name, course_count) values('%1', '%2', '%3')")
            .arg(date.toString("yyyy-MM-dd"), name, QString::number(count));

    qDebug() << "Executing:" << sqlUpdate;

    if(!query.exec(sqlUpdate)) {
        qDebug() << "Failed to execute SQL:" << query.lastError();
        return false;
    }

    emit courseChanged();

    return true;
}

bool SqlModel::delCourse(const int index)
{
    const QString queryStr = QString::fromLatin1("delete from Course where id='%1'").arg(index);
    qDebug() << "executing:" << queryStr;
    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << query.lastError().text();
        return false;
    }

    emit courseChanged();
    return true;
}
