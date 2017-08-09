#include "course.h"

Course::Course(QObject* parent) :
  QObject(parent) {
}

Course::Course(const Course& course) {
  this->m_courseId =  course.m_courseId;
  this->m_userId = course.m_userId;
  this->m_count = course.m_count;
  this->m_date = course.m_date;
  this->m_inputTime = course.m_inputTime;
  this->m_name = course.m_name;
}

Course& Course::operator=(const Course& course) {
  if (this != &course) {
    this->m_courseId =  course.m_courseId;
    this->m_userId = course.m_userId;
    this->m_count = course.m_count;
    this->m_date = course.m_date;
    this->m_inputTime = course.m_inputTime;
    this->m_name = course.m_name;
  }

  return *this;
}
