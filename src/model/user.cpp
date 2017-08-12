#include "model/user.h"
#include <QUuid>

User::User(QObject* parent) :
  QObject(parent) {
}

User::User(const User& user) {
  this->m_userId = user.m_userId;
  this->m_name =  user.m_name;
  this->m_classNum = user.m_classNum;
  this->m_courseName = user.m_courseName;
  this->m_current = user.m_current;
  this->m_groupIdx = user.m_groupIdx;
  this->m_groupNum = user.m_groupNum;
  this->m_qq = user.m_qq;
  this->m_targetCount = user.m_targetCount;
  this->m_userType = user.m_userType;
}

User& User::operator=(const User& user) {
  if (this != &user) {
    this->m_userId = user.m_userId;
    this->m_name =  user.m_name;
    this->m_classNum = user.m_classNum;
    this->m_courseName = user.m_courseName;
    this->m_current = user.m_current;
    this->m_groupIdx = user.m_groupIdx;
    this->m_groupNum = user.m_groupNum;
    this->m_qq = user.m_qq;
    this->m_targetCount = user.m_targetCount;
    this->m_userType = user.m_userType;
  }

  return *this;
}

void User::reset() {
  this->m_userId = QUuid::createUuid().toString();
  this->m_name =  "";
  this->m_classNum = 0;
  this->m_courseName = "";
  this->m_current = true;
  this->m_groupIdx = 0;
  this->m_groupNum = 0;
  this->m_qq = "";
  this->m_targetCount = 0;
  this->m_userType = GroupUser;
}