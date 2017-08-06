#ifndef USER_MODEL_H
#define USER_MODEL_H

#include "user.h"
#include <QAbstractListModel>

class UserModel : public QAbstractListModel {
  Q_OBJECT
 public:
  enum UserRole {
    NameRole    = Qt::DisplayRole,
    QQRole      = Qt::UserRole,
    UserIdRole,
    CurrentRole,
    CourseRole,
    TypeRole,
    GroupIndexRole,
    ClassIndexRole,
    GroupNumberRole,
    TargetCountRole
  };
  Q_ENUM(UserRole)

 public:
  UserModel(QObject* parent = nullptr);

  int rowCount(const QModelIndex& = QModelIndex()) const;
  QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

 private:
  QList<User> users_;
};

#endif
