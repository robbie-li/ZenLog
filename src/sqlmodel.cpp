#include "sqlmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>

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
        user->set_courseName(query.value("course_name").toString());
        user->set_qq(query.value("qq").toString());
        user->set_name(query.value("name").toString());
        user->set_classNum(query.value("class_num").toInt());
        user->set_groupNum(query.value("group_num").toInt());
        user->set_groupIdx(query.value("group_idx").toInt());
        user->set_targetCount(query.value("target_count").toInt());
        return user;
    }

    return NULL;
}

bool SqlModel::saveUser(const QString& course_name,
                        const QString& qq, const QString& name,
                        int class_num, int group_num,
                        int group_idx, int target_count)
{
    const QString sqlSelect = QString::fromLatin1("SELECT * FROM User");

    QSqlQuery query;
    if (!query.exec(sqlSelect))
    {
        qDebug() << "failed to query user for save" << query.lastError();
    }

    QString sqlSave;
    if(query.first()) {
        sqlSave  = QString::fromLatin1("update User set "
                                       "course_name='%1',"
                                       "name='%3',"
                                       "class_num='%4',"
                                       "group_num='%5',"
                                       "group_idx='%6',"
                                       "target_count='%7'"
                                       " where qq='%2'")
                .arg(course_name)
                .arg(qq)
                .arg(name)
                .arg(QString::number(class_num))
                .arg(QString::number(group_num))
                .arg(QString::number(group_idx))
                .arg(target_count);
    }
    else
    {
        sqlSave = QString::fromLatin1("insert into User (course_name, qq, name, class_num, group_num, group_idx, target_count) values('%1', '%2', '%3', '%4', '%5', '%6', '%7')")
                .arg(course_name)
                .arg(qq)
                .arg(name)
                .arg(QString::number(class_num))
                .arg(QString::number(group_num))
                .arg(QString::number(group_idx))
                .arg(target_count);
    }

    qDebug() << "Executing:" << sqlSave;

    bool success = query.exec(sqlSave);
    if(success)
    {
        qDebug() << "user saved.";
        emit userSaved();
    }
    else
    {
        qDebug() << "Failed to execute SQL:" << query.lastError();
    }

    return success;
}

QList<QObject*> SqlModel::courseDetailsForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Course WHERE course_date = '%1' order by course_input_time desc")
            .arg(date.toString("yyyy-MM-dd"));

    qDebug() << "Executing:" << queryStr;

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
        course->set_date(query.value("course_date").toDate());
        course->set_inputTime(query.value("course_input_time").toDateTime());
        qDebug() << course->inputTime();
        courses.append(course);
    }

    return courses;
}

bool SqlModel::addCourse(const QDate &date, const QString& name, const int count)
{
    const QString queryStr = QString::fromLatin1
            ("insert into Course (course_name,course_date,course_count) values('%1', '%2', '%3')")
            .arg(name)
            .arg(date.toString("yyyy-MM-dd"))
            .arg(QString::number(count));
    qDebug() << "Executing:" << queryStr;
    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug() << query.lastError().text();
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
    if (!query.exec(queryStr))
    {
        qDebug() << query.lastError().text();
        return false;
    }

    emit courseChanged();
    return true;
}

int SqlModel::courseTotalForMonth(const int year, const int month)
{
    const QString queryStr = QString::fromLatin1
            ("SELECT sum(course_count) FROM "
             "(SELECT "
             "course_count, "
             "strftime('%Y-%m', course_date) as month, "
             "strftime('%Y-%m-%d', course_date) as day "
             "from Course WHERE '%1-%2' = month group by day ORDER BY course_input_time DESC)")
            .arg(year, 4, 10)
            .arg((month+1), 2, 10, QLatin1Char('0'));

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug() << "Query failed: " << query.lastError();
    }

    int totalCount = 0;

    if (query.first())
    {
        totalCount = query.value(0).toInt();
    }

    return totalCount;
}

QString SqlModel::courseAverageForMonth(const int year, const int month)
{
    const QString queryStr = QString::fromLatin1
            ("SELECT avg(course_count) FROM "
             "(SELECT "
             "course_count, "
             "strftime('%Y-%m', course_date) as month, "
             "strftime('%Y-%m-%d', course_date) as day "
             "from Course WHERE '%1-%2' = month group by day ORDER BY course_input_time DESC)")
            .arg(year, 4, 10)
            .arg((month+1), 2, 10, QLatin1Char('0'));

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug() << "Query failed: " << query.lastError();
    }

    int totalCount = 0;

    if (query.first())
    {
        totalCount = query.value(0).toInt();
    }

    return QString::number(totalCount);
}

int SqlModel::courseTotalForYear(const int year)
{
    const QString queryStr = QString::fromLatin1
            ("SELECT sum(course_count) FROM "
             "(SELECT "
             "course_count, "
             "strftime('%Y', course_date) as year, "
             "strftime('%Y-%m-%d', course_date) as day "
             "from Course WHERE '%1' = year group by day ORDER BY course_input_time DESC)")
            .arg(year, 4);

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug("Query failed");
    }

    int totalCount = 0;

    if (query.first())
    {
        totalCount = query.value(0).toInt();
    }

    return totalCount;
}

QString SqlModel::courseAverageForYear(const int year)
{
    const QString queryStr = QString::fromLatin1
            ("SELECT avg(course_count) FROM "
             "(SELECT "
             "course_count, "
             "strftime('%Y', course_date) as year, "
             "strftime('%Y-%m-%d', course_date) as day "
             "from Course WHERE '%1' = year group by day ORDER BY course_input_time DESC)")
            .arg(year, 4);

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug("Query failed");
    }

    int totalCount = 0;

    if (query.first())
    {
        totalCount = query.value(0).toInt();
    }

    return QString::number(totalCount);
}

int SqlModel::courseTotal()
{
    const QString queryStr = QString::fromLatin1
            ("SELECT sum(course_count) FROM "
             "(SELECT "
             "course_count, "
             "strftime('%Y-%m-%d', course_date) as day "
             "from Course group by day ORDER BY course_input_time DESC)");

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug("Query failed");
    }

    int totalCount = 0;

    if (query.first())
    {
        totalCount = query.value(0).toInt();
    }

    return totalCount;
}

QString SqlModel::courseAverage()
{
    const QString queryStr = QString::fromLatin1
            ("SELECT avg(course_count) FROM "
             "(SELECT "
             "course_count, "
             "strftime('%Y-%m-%d', course_date) as day "
             "from Course group by day ORDER BY course_input_time DESC)");

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug("Query failed");
    }

    int totalCount = 0;

    if (query.first())
    {
        totalCount = query.value(0).toInt();
    }

    return QString::number(totalCount);
}

QVariantMap SqlModel::dailyCourseCountForMonth(const int year, const int month)
{
    const QString queryStr =QString::fromLatin1
            ("SELECT course_count, strftime('%d', course_date) as cd from Course WHERE strftime('%Y-%m', course_date) = '%1-%2' group by cd  ORDER BY course_input_time DESC")
            .arg(year, 4)
            .arg(month + 1, 2, 10, QLatin1Char('0'));

    qDebug() << "Executing:" << queryStr;

    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug() << "Failed to query course" << query.lastError();
    }

    QVariantMap courses;
    while (query.next())
    {
        int course_day = query.value(1).toInt();
        int course_count = query.value(0).toInt();
        qDebug() << "Course Day:" << course_day << ", Sum:" << course_count;
        courses.insert(QString::fromLatin1("%1").arg(course_day,2,10,QLatin1Char('0')), QVariant::fromValue(course_count));
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

    if(!query.exec("CREATE TABLE IF NOT EXISTS Course (id INTEGER PRIMARY KEY AUTOINCREMENT, course_name TEXT, course_date DATE, course_count INTEGER, course_input_time TIMESTAMP DEFAULT (datetime('now','localtime')))"))
    {
        qDebug() << "Failed to create course table" << query.lastError();
    }
    else if(!query.exec("ALTER TABLE Course ADD course_input_time TIMESTAMP DEFAULT (datetime('now','localtime'))"))
    {
        qDebug() << "Failed to update course table" << query.lastError();
    }

    if(!query.exec("CREATE TABLE IF NOT EXISTS User (course_name TEXT, qq TEXT, name TEXT, class_num INTEGER, group_num INTEGER, group_idx INTEGER, target_count INTEGER)"))
    {
        qDebug() << "Failed to create user table:" << query.lastError();
    }

    return true;
}
