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

    //qDebug() << "Executing:" << queryStr;

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("failed to query user for load");

    if(query.first()) {
        User *user = new User(this);
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


bool SqlModel::saveUser(int group, int index, const QString& name,
                        const QString& address, const QString& city, const QString& email,
                        int targetCount, const QString& courseName) {
    const QString queryStr = QString::fromLatin1("SELECT * FROM User");

    //qDebug() << "Executing:" << queryStr;

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("failed to query user for save");

    QString sql;
    if(query.first()) {
        sql  = QString::fromLatin1("update User set "
                                   "name='%3',"
                                   "address='%4',"
                                   "city='%5',"
                                   "email='%6',"
                                   "target_count='%7',"
                                   "course_name='%8'"
                                   " where group_num='%1' and group_idx='%2'")
                .arg(QString::number(group), QString::number(index), name, address, city, email, QString::number(targetCount), courseName);
    } else {
        sql = QString::fromLatin1("insert into User (group_num, group_idx, name, address, city, email, target_count, course_name) values('%1', '%2', '%3', '%4', '%5', '%6', '%7', '%8')")
                .arg(QString::number(group), QString::number(index), name, address, city, email, QString::number(targetCount), courseName);
    }

    QSqlQuery queryUpdate(sql);
    return queryUpdate.exec();
}

int SqlModel::courseCountForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Course WHERE '%1' == date").arg(date.toString("yyyy-MM-dd"));

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    int totalCount = 0;

    while (query.next()) {
        totalCount += query.value("count").toInt();
    }

    return totalCount;
}


QList<QObject*> SqlModel::coursesForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Course WHERE '%1' == date").arg(date.toString("yyyy-MM-dd"));

    //qDebug() << "Executing:" << queryStr;

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("failed to query for load course");

    QList<QObject*> courses;
    while (query.next()) {
        Course *course = new Course(this);
        course->set_index(query.value("id").toInt());
        course->set_name(query.value("name").toString());
        course->set_count(query.value("count").toInt());

        QDateTime date;
        date.setDate(query.value("date").toDate());
        course->set_date(date);
        courses.append(course);
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

    if(!query.exec("create table Course (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date DATE, count INTEGER)")) {
        qDebug() << "Failed to create course table";
    }

    if(!query.exec(
                "create table User (group_num INTEGER, group_idx INTEGER, name TEXT, city TEXT, address TEXT, email TEXT, course_name TEXT, target_count INTEGER)")) {
       qDebug() << "Failed to create user table:" << query.lastError();
    }

    return true;
}

bool SqlModel::addCourse(const QDate &date, const QString& name, const int count)
{
    const QString queryStr = QString::fromLatin1("insert into Course (name,date,count) values('%1', '%2', '%3')").arg(name, date.toString("yyyy-MM-dd"), QString::number(count));
    qDebug() << "executing:" << queryStr;
    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << query.lastError().text();
        return false;
    }
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
    return true;
}
