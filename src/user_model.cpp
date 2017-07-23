#include "user_model.h"
#include "sql_model.h"
#include <QDebug>

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

QStringList UserModel::listUserNames() const {
  SqlModel model;
  QList<User*> users = model.listUsers();
  QStringList result;
  for (User* user : users) {
    result.push_back(user->name());
  }
  return  result;
}

QString UserModel::currentUserName() const {
  SqlModel model;
  QList<User*> users = model.listUsers();

  for (User* user : users) {
    if (user->current()) return user->name();
  }

  return "";
}

User* UserModel::currentUser() const {
  return current_user_;
}

void UserModel::setCurrentUser(User* user) {
  current_user_ = user;
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

  qDebug() << "CurrentUser:" << current_user_;
  qDebug() << "CurrentUserName:" << current_user_->name();
}
