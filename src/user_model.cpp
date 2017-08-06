#include "user_model.h"
#include "sql_model.h"
#include <QDebug>
#include <QUuid>

UserModel::UserModel(QObject* parent)
  : QAbstractListModel(parent)
  , users_(SqlModel::instance()->listUsers()) {
  connect(SqlModel::instance(), &SqlModel::userChanged, this, [this] {
    beginResetModel();
    users_ = SqlModel::instance()->listUsers();
    endResetModel();
  });
}

int UserModel::rowCount(const QModelIndex&) const {
  return users_.count();
}

QVariant UserModel::data(const QModelIndex& index, int role) const {
  if (index.row() < rowCount())
    switch (role) {
      case NameRole:
        return users_.at(index.row()).name();
      case QQRole:
        return users_.at(index.row()).qq();
      case UserIdRole:
        return users_.at(index.row()).userId();
      case CurrentRole:
        return users_.at(index.row()).current();
      case CourseRole:
        return users_.at(index.row()).courseName();
      case TypeRole:
        return users_.at(index.row()).userType();
      case GroupIndexRole:
        return users_.at(index.row()).groupNum();
      case ClassIndexRole:
        return users_.at(index.row()).classNum();
      case GroupNumberRole:
        return users_.at(index.row()).groupIdx();
      case TargetCountRole:
        return users_.at(index.row()).targetCount();
      default:
        return QVariant();
    }
  return QVariant();
}

QHash<int, QByteArray> UserModel::roleNames() const {
  static const QHash<int, QByteArray> roles {
    { NameRole,        "name"        },
    { QQRole,          "QQ"          },
    { UserIdRole,      "userId"      },
    { CurrentRole,     "current"     },
    { CourseRole,      "course"      },
    { TypeRole,        "type"        },
    { GroupIndexRole,  "groupIndex"  },
    { ClassIndexRole,  "classIndex"  },
    { GroupNumberRole, "groupNumber" },
    { TargetCountRole, "targetCount" },
  };
  return roles;
}
