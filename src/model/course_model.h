#ifndef COURSE_MODEL_H
#define COURSE_MODEL_H

#include "model/course.h"
#include "utils/macros.h"
#include <QAbstractListModel>

class CourseModel : public QAbstractListModel {
  Q_OBJECT

  DEFINE_Q_PROPERTY(QString, userID);
  DEFINE_Q_PROPERTY(QDate, courseDate);

 public:
  enum CourseRole {
    CourseNameRole  = Qt::DisplayRole,
    CourseCountRole = Qt::UserRole,
    CourseIDRole,
    CourseInputTimeRole,
    CourseDateRole,
    UserIDRole
  };
  Q_ENUM(CourseRole)

 public:
  CourseModel(QObject* parent = nullptr);

  int rowCount(const QModelIndex& = QModelIndex()) const;
  QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

 signals:
  void userIDChanged(const QString& userId);
  void courseDateChanged(const QDate& courseDate);

 private slots:
  void reloadCourse();

 private:
  QList<Course> courses_;
};

#endif  // COURSE_MODEL_H
