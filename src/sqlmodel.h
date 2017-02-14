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


class SqlModel : public QSqlQueryModel {
    Q_OBJECT

  public:
    SqlModel();

    Q_INVOKABLE QObject* getCurrentUser();
    Q_INVOKABLE bool saveUser(const QString& course_name, const QString& qq, const QString& name,
                              int class_num, int group_num, int group_idx, int target_count);

    // FOR DAILY LOG PAGE.
    Q_INVOKABLE QList<QObject*> courseDetailsForDate(const QDate& date);
    Q_INVOKABLE bool addCourse(const QDate& date, const QString& name, const int count);
    Q_INVOKABLE bool delCourse(const int index);

    // FOR CALENDAR PAGE
    Q_INVOKABLE QVariantMap dailyCourseCountForMonth(const int year, const int month);
    Q_INVOKABLE int courseTotalForMonth(const int year, const int month);
    Q_INVOKABLE QString courseAverageForMonth(const int year, const int month);
    Q_INVOKABLE int courseTotalForYear(const int year);
    Q_INVOKABLE QString courseAverageForYear(const int year);
    Q_INVOKABLE int courseTotal();
    Q_INVOKABLE QString courseAverage();

  signals:
    void userSaved();
    void courseChanged();

  private:
    static bool createConnection();
    static bool createTables();
};

#endif
