#ifndef USER_H
#define USER_H

#include <QObject>
#include <QString>

#include "utils/macros.h"

class User : public QObject {
  Q_OBJECT

  DEFINE_Q_PROPERTY(QString,  userId);
  DEFINE_Q_PROPERTY(bool,     current);
  DEFINE_Q_PROPERTY(int,      userType);
  DEFINE_Q_PROPERTY(int,      classNum);
  DEFINE_Q_PROPERTY(int,      groupNum);
  DEFINE_Q_PROPERTY(int,      groupIdx);
  DEFINE_Q_PROPERTY(QString,  qq);
  DEFINE_Q_PROPERTY(QString,  name);
  DEFINE_Q_PROPERTY(QString,  courseName);
  DEFINE_Q_PROPERTY(int,      targetCount);

 public:
  enum UserType {
    GroupUser,
    ExternalUser
  };
  Q_ENUMS(UserType)

 public:
  explicit User(QObject* parent = 0);
  User(const User& user);
  User& operator=(const User& user);

  Q_INVOKABLE void reset();

 signals:
  void userIdChanged(const QString& userId);
  void externalUserChanged(const bool externalUser);
  void currentChanged(const bool current);
  void userTypeChanged(const int userType);
  void classNumChanged(const int classNum);
  void groupNumChanged(const int groupNum);
  void groupIdxChanged(const int groupIdx);
  void qqChanged(const QString& qq);
  void nameChanged(const QString& name);
  void courseNameChanged(const QString& courseName);
  void targetCountChanged(const int targetCount);
};

#endif  // USER_H