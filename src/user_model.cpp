#include "user_model.h"
#include "sql_model.h"
#include <QDebug>
#include <QUuid>

UserModel::UserModel(QObject* parent)
  : QObject(parent)
  , current_user_(nullptr) {
  loadCurrentUser();
}

void UserModel::create() {
  SqlModel model;
  model.createUser(current_user_);
  emit modelChanged();
}

void UserModel::update() {
  SqlModel model;
  model.updateUser(current_user_);
  emit modelChanged();
}

void UserModel::remove() {
  SqlModel model;
  model.removeUser(current_user_);
  emit modelChanged();
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
  loadCurrentUser();
  return current_user_;
}

QStringList UserModel::listUserNames() const {
  SqlModel model;
  QList<User*> users = model.listUsers();
  QStringList result;
  for (User* user : users) {
    result.push_back(user->name());
  }
  return  result;
}

QList<User*> UserModel::listUsers() const {
  SqlModel model;
  QList<User*> users = model.listUsers();
  return  users;
}

void UserModel::loadCurrentUser() {
  SqlModel model;
  QList<User*> users = model.listUsers();

  if (users.count() == 1) {
    current_user_ = users[0]->clone();
  } else {
    for (User* user : users) {
      if (user->current()) current_user_ = user->clone();
    }
  }

  if (current_user_ == nullptr && users.count()) {
    current_user_ = users[0]->clone();
  }
  qDebug() << "CurrentUser:" << current_user_;
  qDebug() << "CurrentUserName:" << current_user_->name();
}
