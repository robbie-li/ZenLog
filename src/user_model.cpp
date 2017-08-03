#include "user_model.h"
#include "sql_model.h"
#include <QDebug>
#include <QUuid>

UserModel::UserModel(QObject* parent)
  : QObject(parent) {
}

User* UserModel::createUser() {
  User* user = new User(this);
  user->set_userId(QUuid::createUuid().toString());
  return user;
}

bool UserModel::saveUser(User* user) {
  SqlModel model;
  if (model.createUser(user)) {
    delete  user;
    emit modelChanged();
    return true;
  }
  return false;
}

User* UserModel::getCurrentUser() {
  SqlModel model;
  return model.getCurrentUser();
}

QList<QObject*> UserModel::listUsers() const {
  SqlModel model;
  QList<QObject*> users = model.listUsers();
  return  users;
}

