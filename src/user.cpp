#include "user.h"

User::User(QObject* parent) :
  QObject(parent) {
}

User* User::clone() const {
  User* user = new User;
  user->m_name = m_name;
  user->m_classNum = m_classNum;
  user->m_courseName = m_courseName;
  user->m_current = m_current;
  user->m_groupIdx = m_groupIdx;
  user->m_groupNum = m_groupNum;
  user->m_qq = m_qq;
  user->m_targetCount = m_targetCount;
  user->m_userId = m_userId;
  user->m_userType = m_userType;
  return  user;
}
