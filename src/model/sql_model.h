/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef SQL_MODEL_H
#define SQL_MODEL_H

#include <QList>
#include <QObject>
#include <QSqlTableModel>

#include "course.h"
#include "user.h"

class SqlModel : public QSqlQueryModel {
  Q_OBJECT

 protected:
  static SqlModel* instance_;

 protected:
  SqlModel();

 public:
  static SqlModel* instance();

  // User Management
  Q_INVOKABLE QList<User> listUsers();
  Q_INVOKABLE QStringList listUserNames();
  Q_INVOKABLE User* getCurrentUser();
  Q_INVOKABLE User* getUser(const QString& userId);
  Q_INVOKABLE bool createUser(User* user);
  Q_INVOKABLE bool updateUser(User* user);
  Q_INVOKABLE bool removeUser(const QString& name);
  Q_INVOKABLE bool setDefaultUser(const QString& name);

  // Course Management
  Q_INVOKABLE QList<Course> listCourse(const QString& userId, const QDate& date);
  Q_INVOKABLE bool createCourse(const QString& userId, const QDate& date, const QString& name, const int count);
  Q_INVOKABLE bool deleteCourse(const int courseId);

  // FOR CALENDAR PAGE
  Q_INVOKABLE QVariantMap monthlyCourses(const QString& userId, const int year, const int month);

  Q_INVOKABLE int courseTotalForMonth(const QString& userId, const int year, const int month);
  Q_INVOKABLE QString courseAverageForMonth(const QString& userId, const int year, const int month);
  Q_INVOKABLE int courseTotalForYear(const QString& userId, const int year);
  Q_INVOKABLE QString courseAverageForYear(const QString& userId, const int year);
  Q_INVOKABLE int courseTotal(const QString& userId);
  Q_INVOKABLE QString courseAverage(const QString& userId);

 signals:
  void userChanged();
  void courseChanged();

 private:
  int getDatabaseVersion();
 private:
  static bool createConnection();
  static bool createTables();
  static bool updateTables();
};

#endif