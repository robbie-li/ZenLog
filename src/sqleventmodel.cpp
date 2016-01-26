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

#include "sqleventmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>

SqlEventModel::SqlEventModel() :
    QSqlQueryModel()
{
    createConnection();
}

QList<QObject*> SqlEventModel::coursesForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Course WHERE '%1' == date").arg(date.toString("yyyy-MM-dd"));

    //qDebug() << "Executing:" << queryStr;

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    QList<QObject*> courses;
    while (query.next()) {
        Course *course = new Course(this);
        course->setIndex(query.value("id").toInt());
        course->setName(query.value("name").toString());
        course->setCount(query.value("count").toInt());

        QDateTime date;
        date.setDate(query.value("date").toDate());
        course->setDate(date);
        courses.append(course);
    }

    return courses;
}

/*
    Defines a helper function to open a connection to an
    in-memory SQLITE database and to create a test table.
*/
void SqlEventModel::createConnection()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    //db.setDatabaseName(":memory:");
    db.setDatabaseName("zenlog.db");
    if (!db.open()) {
        qFatal("Cannot open database");
        return;
    }

    QSqlQuery query;
    // We store the time as seconds because it's easier to query.
    if(!query.exec("create table Course (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date DATE, count INTEGER)")) {
       //qFatal("Failed to create table");
    }
    return;
}

bool SqlEventModel::addCourse(const QDate &date, const QString& name, const int count)
{
    const QString queryStr = QString::fromLatin1("insert into Course (name,date,count) values('%1', '%2', '%3')").arg(name, date.toString("yyyy-MM-dd"), QString::number(count));
    qDebug() << "executing:" << queryStr;
    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << query.lastError().text();
        return false;
    }
    return true;
}

bool SqlEventModel::delCourse(const int index)
{
    const QString queryStr = QString::fromLatin1("delete from Course where id='%1'").arg(index);
    qDebug() << "executing:" << queryStr;
    QSqlQuery query;
    if (!query.exec(queryStr)) {
        qDebug() << query.lastError().text();
        return false;
    }
    return true;
}
