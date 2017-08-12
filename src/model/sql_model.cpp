#include "model/sql_model.h"

#include <mutex>
#include <QDebug>
#include <QDir>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>

#include "model/user.h"

namespace {
  static bool connected = false;
  std::mutex sql_model_instance_mutex;
}

SqlModel* SqlModel::instance_ = nullptr;

SqlModel* SqlModel::instance() {
  static std::once_flag oc;
  std::call_once(oc, [&] { instance_ = new SqlModel; });
  return instance_;
}

SqlModel::SqlModel() : QSqlQueryModel() {
  if (!connected) {
    connected = createConnection();

    if (connected) {
      //int dbversion = getDatabaseVersion();
      //if (dbversion != 1) {
      updateTables();
      //}

      createTables();
    } else {
      qFatal("failed to connect database.");
    }
  }
}

QList<User> SqlModel::listUsers() {
  const QString queryStr = QString::fromLatin1("SELECT * FROM user");

  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug() << ("failed to load user") << query.lastError();
  }

  QList<User> users;

  while (query.next()) {
    User user;
    user.set_userId(query.value("user_id").toString());
    user.set_userType(query.value("user_type").toInt());
    user.set_current(query.value("is_default").toInt());
    user.set_courseName(query.value("course_name").toString());
    user.set_qq(query.value("qq").toString());
    user.set_name(query.value("name").toString());
    user.set_classNum(query.value("class_num").toInt());
    user.set_groupNum(query.value("group_num").toInt());
    user.set_groupIdx(query.value("group_idx").toInt());
    user.set_targetCount(query.value("target_count").toInt());
    users.append(user);
  }

  return users;
}

QStringList SqlModel::listUserNames() {
  const QString queryStr = QString::fromLatin1("SELECT name FROM user");

  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug() << ("failed to load user") << query.lastError();
  }

  QStringList users;

  while (query.next()) {
    users.append(query.value("name").toString());
  }

  return users;
}

User* SqlModel::getCurrentUser() {
  const QString queryStr = QString::fromLatin1("SELECT * FROM user where is_default='1' ");

  QSqlQuery query;

  qDebug() << "Executing:" << queryStr;

  if (!query.exec(queryStr)) {
    qDebug() << ("failed to load user") << query.lastError();
  }

  if (query.first()) {
    User* user = new User();
    user->set_userId(query.value("user_id").toString());
    user->set_userType(query.value("user_type").toInt());
    user->set_current(query.value("is_default").toInt());
    user->set_courseName(query.value("course_name").toString());
    user->set_qq(query.value("qq").toString());
    user->set_name(query.value("name").toString());
    user->set_classNum(query.value("class_num").toInt());
    user->set_groupNum(query.value("group_num").toInt());
    user->set_groupIdx(query.value("group_idx").toInt());
    user->set_targetCount(query.value("target_count").toInt());
    qDebug() << "Current User:" << user->name();
    return user;
  }

  return nullptr;
}

User* SqlModel::getUser(const QString& userId) {
  const QString queryStr = QString::fromLatin1("SELECT * FROM user where user_id='%1'").arg(userId);

  QSqlQuery query;

  qDebug() << "Executing:" << queryStr;

  if (!query.exec(queryStr)) {
    qDebug() << ("failed to load user") << query.lastError();
  }

  if (query.first()) {
    User* user = new User();
    user->set_userId(query.value("user_id").toString());
    user->set_userType(query.value("user_type").toInt());
    user->set_current(query.value("is_default").toInt());
    user->set_courseName(query.value("course_name").toString());
    user->set_qq(query.value("qq").toString());
    user->set_name(query.value("name").toString());
    user->set_classNum(query.value("class_num").toInt());
    user->set_groupNum(query.value("group_num").toInt());
    user->set_groupIdx(query.value("group_idx").toInt());
    user->set_targetCount(query.value("target_count").toInt());
    return user;
  }

  return nullptr;
}

bool SqlModel::createUser(User* user) {
  if (!user) return false;

  QSqlQuery query;

  QString sqlSave = QString::fromLatin1(R"(insert into User (user_id, is_default, user_type, class_num, group_num, group_idx, qq, name, course_name, target_count)
                                          values('%1', '%2', '%3', '%4', '%5', '%6', '%7', '%8', '%9', '%10'))")
                    .arg(user->userId())
                    .arg(user->current())
                    .arg(user->userType())
                    .arg(user->classNum())
                    .arg(user->groupNum())
                    .arg(user->groupIdx())
                    .arg(user->qq())
                    .arg(user->name())
                    .arg(user->courseName())
                    .arg(user->targetCount());

  qDebug() << "Executing:" << sqlSave;

  bool success = query.exec(sqlSave);
  if (success) {
    qDebug() << "user created.";
    emit userChanged();
  } else {
    qDebug() << "Failed to execute SQL:" << query.lastError();
  }

  return success;
}

bool SqlModel::updateUser(User* user) {
  if (!user) return false;

  QSqlQuery query;

  QString sqlSave = QString::fromLatin1(R"(update User set
                                          is_default='%2',
                                          user_type='%3',
                                          class_num='%4',
                                          group_num='%5',
                                          group_idx='%6',
                                          qq='%7',
                                          name='%8',
                                          course_name='%9',
                                          target_count='%10'
                                          where user_id='%1'
                                          )")
                    .arg(user->userId())
                    .arg(user->current())
                    .arg(user->userType())
                    .arg(user->classNum())
                    .arg(user->groupNum())
                    .arg(user->groupIdx())
                    .arg(user->qq())
                    .arg(user->name())
                    .arg(user->courseName())
                    .arg(user->targetCount());


  qDebug() << "Executing:" << sqlSave;

  bool success = query.exec(sqlSave);
  if (success) {
    qDebug() << "user updated.";
    emit userChanged();
  } else {
    qDebug() << "Failed to execute SQL:" << query.lastError();
  }

  return success;
}

bool SqlModel::removeUser(const QString& name) {
  if (name.isEmpty()) return false;

  QSqlQuery query;

  QString sqlDelete = QString::fromLatin1(R"(delete from User where name='%1')").arg(name);

  qDebug() << "Executing:" << sqlDelete;

  bool success = query.exec(sqlDelete);
  if (success) {
    qDebug() << "user deleted.";
    emit userChanged();
  } else {
    qDebug() << "Failed to execute SQL:" << query.lastError();
  }

  return success;
}

bool SqlModel::setDefaultUser(const QString& name) {
  if (name.isEmpty()) return false;

  QSqlQuery query;

  QString sqlUpdateAll = QString::fromLatin1(R"(update User set is_default='0')");

  QString sqlUpdateOne = QString::fromLatin1(R"(update User set is_default='1' where name='%1')").arg(name);

  qDebug() << "Executing:" << sqlUpdateAll;
  bool success = query.exec(sqlUpdateAll);
  if (!success) {
    qDebug() << "Failed to execute SQL:" << query.lastError();
    return false;
  }

  qDebug() << "Executing:" << sqlUpdateOne;
  success = query.exec(sqlUpdateOne);
  if (!success) {
    qDebug() << "Failed to execute SQL:" << query.lastError();
    return false;
  } else {
    emit userChanged();
  }

  return success;
}

QList<Course> SqlModel::listCourse(const QString& userId, const QDate& date) {
  const QString queryStr = QString::fromLatin1("SELECT course_id, course_name, course_count, course_date, user_id, datetime(course_input_time, 'localtime') as input_time FROM Course WHERE course_date = '%1' and user_id='%2' order by course_input_time desc")
                           .arg(date.toString("yyyy-MM-dd"))
                           .arg(userId);

  qDebug() << "Executing:" << queryStr;

  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug() << "Failed to load course" << query.lastError();
  }

  QList<Course> courses;

  while (query.next()) {
    Course course;
    course.set_courseId(query.value("course_id").toInt());
    course.set_name(query.value("course_name").toString());
    course.set_count(query.value("course_count").toInt());
    course.set_date(query.value("course_date").toDate());
    course.set_inputTime(query.value("input_time").toDateTime());
    course.set_userId(query.value("user_id").toString());
    courses.append(course);
  }

  return courses;
}

bool SqlModel::createCourse(const QString& userId, const QDate& date, const QString& name, const int count) {
  const QString queryStr = QString::fromLatin1
                           ("insert into Course (course_name,course_date,course_count,user_id) values('%1', '%2', '%3', '%4')")
                           .arg(name)
                           .arg(date.toString("yyyy-MM-dd"))
                           .arg(QString::number(count))
                           .arg(userId);
  qDebug() << "Executing:" << queryStr;
  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug() << query.lastError().text();
    return false;
  }

  emit courseChanged();
  return true;
}

bool SqlModel::deleteCourse(const int courseId) {
  const QString queryStr = QString::fromLatin1("delete from Course where course_id='%1'").arg(courseId);
  qDebug() << "executing:" << queryStr;
  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug() << query.lastError().text();
    return false;
  }

  emit courseChanged();
  return true;
}

int SqlModel::courseTotalForMonth(const QString& userId, const int year, const int month) {
  const QString queryStr = QString::fromLatin1
                           ("SELECT sum(course_count) FROM "
                            "(SELECT "
                            "course_count, "
                            "strftime('%Y-%m', course_date) as month, "
                            "strftime('%Y-%m-%d', course_date) as day "
                            "from Course WHERE '%1-%2' = month and user_id='%3' group by day ORDER BY course_input_time DESC)")
                           .arg(year, 4, 10)
                           .arg((month + 1), 2, 10, QLatin1Char('0'))
                           .arg(userId);

  qDebug() << "Executing:" << queryStr;

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

QString SqlModel::courseAverageForMonth(const QString& userId, const int year, const int month) {
  const QString queryStr = QString::fromLatin1
                           ("SELECT avg(course_count) FROM "
                            "(SELECT "
                            "course_count, "
                            "strftime('%Y-%m', course_date) as month, "
                            "strftime('%Y-%m-%d', course_date) as day "
                            "from Course WHERE '%1-%2' = month and user_id='%3' group by day ORDER BY course_input_time DESC)")
                           .arg(year, 4, 10)
                           .arg((month + 1), 2, 10, QLatin1Char('0'))
                           .arg(userId);

  qDebug() << "Executing:" << queryStr;

  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug() << "Query failed: " << query.lastError();
  }

  int totalCount = 0;

  if (query.first()) {
    totalCount = query.value(0).toInt();
  }

  return QString::number(totalCount);
}

int SqlModel::courseTotalForYear(const QString& userId, const int year) {
  const QString queryStr = QString::fromLatin1
                           ("SELECT sum(course_count) FROM "
                            "(SELECT "
                            "course_count, "
                            "strftime('%Y', course_date) as year, "
                            "strftime('%Y-%m-%d', course_date) as day "
                            "from Course WHERE '%1' = year and user_id='%2' group by day ORDER BY course_input_time DESC)")
                           .arg(year, 4)
                           .arg(userId);

  qDebug() << "Executing:" << queryStr;

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

QString SqlModel::courseAverageForYear(const QString& userId, const int year) {
  const QString queryStr = QString::fromLatin1
                           ("SELECT avg(course_count) FROM "
                            "(SELECT "
                            "course_count, "
                            "strftime('%Y', course_date) as year, "
                            "strftime('%Y-%m-%d', course_date) as day "
                            "from Course WHERE '%1' = year and user_id='%2' group by day ORDER BY course_input_time DESC)")
                           .arg(year, 4)
                           .arg(userId);

  qDebug() << "Executing:" << queryStr;

  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug("Query failed");
  }

  int totalCount = 0;

  if (query.first()) {
    totalCount = query.value(0).toInt();
  }

  return QString::number(totalCount);
}

int SqlModel::courseTotal(const QString& userId) {
  const QString queryStr = QString::fromLatin1
                           ("SELECT sum(course_count) FROM "
                            "(SELECT "
                            "course_count, "
                            "strftime('%Y-%m-%d', course_date) as day "
                            "from Course where user_id='%1' group by day ORDER BY course_input_time DESC)")
                           .arg(userId);

  qDebug() << "Executing:" << queryStr;

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

QString SqlModel::courseAverage(const QString& userId) {
  const QString queryStr = QString::fromLatin1
                           ("SELECT avg(course_count) FROM "
                            "(SELECT "
                            "course_count, "
                            "strftime('%Y-%m-%d', course_date) as day "
                            "from Course where user_id='%1' group by day ORDER BY course_input_time DESC)")
                           .arg(userId);

  qDebug() << "Executing:" << queryStr;

  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug("Query failed");
  }

  int totalCount = 0;

  if (query.first()) {
    totalCount = query.value(0).toInt();
  }

  return QString::number(totalCount);
}

QVariantMap SqlModel::monthlyCourses(const QString& userId, const int year, const int month) {
  const QString queryStr = QString::fromLatin1
                           ("SELECT course_count, strftime('%d', course_date) as cd from Course WHERE strftime('%Y-%m', course_date) = '%1-%2' and user_id='%3' group by cd  ORDER BY course_input_time DESC")
                           .arg(year, 4)
                           .arg(month + 1, 2, 10, QLatin1Char('0'))
                           .arg(userId);

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
    courses.insert(QString::fromLatin1("%1").arg(course_day, 2, 10, QLatin1Char('0')), QVariant::fromValue(course_count));
  }

  return courses;
}

int SqlModel::getDatabaseVersion() {
  const QString queryStr = QString::fromLatin1("SELECT version FROM dbversion")                           ;

  qDebug() << "Executing:" << queryStr;

  QSqlQuery query;
  if (!query.exec(queryStr)) {
    qDebug("Query failed");
  }

  int dbversion = 0;

  if (query.first()) {
    dbversion = query.value(0).toInt();
  }

  return dbversion;
}

bool SqlModel::createConnection() {
  QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
  QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
  QDir dbdir;
  dbdir.mkpath(appDataPath);
  db.setDatabaseName(appDataPath + QDir::separator() + QLatin1String("zenlog.db"));
  return db.open();
}

bool SqlModel::createTables() {
  QSqlQuery query;

  if (!query.exec(R"(CREATE TABLE IF NOT EXISTS user (
                    user_id       guid NOT NULL PRIMARY KEY,
                    user_type     smallint NOT NULL,
                    is_default    smallint NOT NULL,
                    course_name   text NOT NULL,
                    qq            text,
                    name          text,
                    group_num     integer,
                    group_idx     integer,
                    class_num     integer,
                    target_count  integer NOT NULL
                    );)")) {
    qDebug() << "Failed to create user table:" << query.lastError();
  }

  query.clear();

  if (!query.exec(R"(CREATE TABLE IF NOT EXISTS course (
                    course_id          integer NOT NULL PRIMARY KEY AUTOINCREMENT,
                    course_count       integer NOT NULL,
                    course_name        text NOT NULL,
                    course_date        date NOT NULL,
                    course_input_time  timestamp DEFAULT CURRENT_TIMESTAMP,
                    user_id            guid NOT NULL,
                    /* Foreign keys */
                    CONSTRAINT Foreign_key01
                    FOREIGN KEY (user_id)
                    REFERENCES user(user_id)
                    );)")) {
    qDebug() << "Failed to create course table" << query.lastError();
  }

  query.clear();

  if (!query.exec(R"(CREATE TABLE dbversion (
                    version       smallint NOT NULL
                    );)")) {
    qDebug() << "Failed to create dbversion table:" << query.lastError();
  } else {
    query.exec(R"(INSERT INTO dbversion VALUES (
                   '1'
                   );)");
  }

  query.clear();

  return true;
}

bool SqlModel::updateTables() {
  QSqlQuery query;

  if (!query.exec(R"(ALTER TABLE user
                    ADD
                    COLUMN user_type  smallint NOT NULL default 0
                    ;)")) {
    qDebug() << "Failed to alter user table:" << query.lastError();
  }

  if (!query.exec(R"(ALTER TABLE user
                    ADD
                    COLUMN is_default smallint NOT NULL default 0
                    ;)")) {
    qDebug() << "Failed to alter user table:" << query.lastError();
  }

  if (!query.exec(R"(ALTER TABLE course
                    ADD
                    COLUMN user_id guid
                    ;)")) {
    qDebug() << "Failed to alter course table:" << query.lastError();
  }

  if (!query.exec(R"(ALTER TABLE course
                    ADD
                    CONSTRAINT Foreign_key01
                    FOREIGN KEY (user_id)
                    REFERENCES user(user_id)
                    ;)")) {
    qDebug() << "Failed to alter course table:" << query.lastError();
  }
}
