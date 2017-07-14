#ifndef USER_MODEL_H
#define USER_MODEL_H

#include "user.h"

class UserModel : public QObject {
  Q_OBJECT
  Q_PROPERTY(User* currentUser READ currentUser WRITE setCurrentUser NOTIFY currentUserChanged)

 public:
  UserModel(QObject* parent = nullptr);

  Q_INVOKABLE void create();
  Q_INVOKABLE void update();
  Q_INVOKABLE void remove();

  User* currentUser() const;
  void setCurrentUser(User* user);

 signals:
  void modelChanged();
  void currentUserChanged();

 private:
  User* current_user_;
};

#endif
