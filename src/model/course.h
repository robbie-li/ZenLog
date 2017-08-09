#ifndef COURSE_H
#define COURSE_H

#include <QDateTime>
#include <QObject>
#include <QString>

#include "utils/macros.h"

class Course : public QObject {
  Q_OBJECT

  DEFINE_Q_PROPERTY(int,          courseId);
  DEFINE_Q_PROPERTY(QString,      name);
  DEFINE_Q_PROPERTY(int,          count);
  DEFINE_Q_PROPERTY(QDate,        date);
  DEFINE_Q_PROPERTY(QDateTime,    inputTime);
  DEFINE_Q_PROPERTY(QString,      userId);

 public:
  explicit Course(QObject* parent = 0);
  Course(const Course& course);
  Course& operator=(const Course& course);

 signals:
  void courseIdChanged(const int courseId);
  void nameChanged(const QString& name);
  void countChanged(const int count);
  void dateChanged(const  QDate& date);
  void inputTimeChanged(const QDateTime& inputTime);
  void userIdChanged(const QString& userId);
};

#endif  // COURSE_H
