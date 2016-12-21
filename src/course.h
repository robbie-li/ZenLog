#ifndef COURSE_H
#define COURSE_H

#include <QDateTime>
#include <QObject>
#include <QString>

#include "macros.h"

class Course : public QObject
{
    Q_OBJECT

    DEFINE_Q_PROPERTY(int, index);
    DEFINE_Q_PROPERTY(QString, name);
    DEFINE_Q_PROPERTY(int, count);
    DEFINE_Q_PROPERTY(QDate, date);
    DEFINE_Q_PROPERTY(QDateTime, inputTime);
public:
    explicit Course(QObject *parent = 0);
signals:
    void indexChanged(const int index);
    void nameChanged(const QString &name);
    void countChanged(const int count);
    void dateChanged(const  QDate &date);
    void inputTimeChanged(const QDateTime &date);
};

#endif  // COURSE_H
