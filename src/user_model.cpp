#include "user_model.h"
#include "sql_model.h"

UserModel::UserModel(QObject* parent)
  : QObject(parent)
  , current_user_(nullptr) {
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

User* UserModel::currentUser() const {
  return current_user_;
}

void UserModel::setCurrentUser(User* user) {
  current_user_ = user;
}
