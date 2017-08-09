#include "model/course_model.h"
#include "model/sql_model.h"
#include <QDebug>
#include <QUuid>

CourseModel::CourseModel(QObject* parent)
  : QAbstractListModel(parent) {
  connect(SqlModel::instance(), &SqlModel::courseChanged, this, &CourseModel::reloadCourse);
  connect(this, &CourseModel::userIDChanged, this,  &CourseModel::reloadCourse);
  connect(this, &CourseModel::courseDateChanged, this,  &CourseModel::reloadCourse);
}

int CourseModel::rowCount(const QModelIndex&) const {
  return courses_.count();
}

QVariant CourseModel::data(const QModelIndex& index, int role) const {
  if (index.row() < rowCount())
    switch (role) {
      case CourseNameRole:
        return courses_.at(index.row()).name();
      case CourseIDRole:
        return courses_.at(index.row()).courseId();
      case CourseCountRole:
        return courses_.at(index.row()).count();
      case CourseDateRole:
        return courses_.at(index.row()).date();
      case CourseInputTimeRole:
        return courses_.at(index.row()).inputTime();
      case UserIDRole:
        return courses_.at(index.row()).userId();
      default:
        return QVariant();
    }

  return QVariant();
}

QHash<int, QByteArray> CourseModel::roleNames() const {
  static const QHash<int, QByteArray> roles {
    { CourseNameRole,  "courseName"  },
    { CourseCountRole, "courseCount" },
    { CourseIDRole,    "courseID"    },
    { CourseDateRole,  "courseDate"  },
    { CourseInputTimeRole, "courseInputTime" },
    { UserIDRole,      "userID"      },
  };

  return roles;
}

void CourseModel::reloadCourse() {
  if (m_userID.isEmpty()) return;

  beginResetModel();
  courses_ = SqlModel::instance()->listCourse(m_userID, m_courseDate);
  endResetModel();
}
