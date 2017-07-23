#ifndef USER_MODEL_H
#define USER_MODEL_H

#include "user.h"

class UserModel : public QObject {
  Q_OBJECT

 public:
  UserModel(QObject* parent = nullptr);

  Q_INVOKABLE void create();
  Q_INVOKABLE void update();
  Q_INVOKABLE void remove();

  Q_INVOKABLE User* createUser();
  Q_INVOKABLE bool  saveUser(User* user);
  Q_INVOKABLE User* getCurrentUser();
  Q_INVOKABLE QStringList listUserNames() const;
  Q_INVOKABLE QList<User*> listUsers() const;

 signals:
  void modelChanged();

 private:
  void loadCurrentUser();

 private:
  User* current_user_;
};

#endif
