#ifndef USER_H
#define USER_H

#include <QDateTime>
#include <QObject>
#include <QString>

#include "macros.h"

class User : public QObject
{
    Q_OBJECT

    DEFINE_Q_PROPERTY(int, group);
    DEFINE_Q_PROPERTY(int, index);
    DEFINE_Q_PROPERTY(int, qq);
    DEFINE_Q_PROPERTY(QString, name);
    DEFINE_Q_PROPERTY(QString, address);
    DEFINE_Q_PROPERTY(QString, city);
    DEFINE_Q_PROPERTY(QString, email);
    DEFINE_Q_PROPERTY(QString, courseName);
    DEFINE_Q_PROPERTY(int, targetCount);
public:
    explicit User(QObject* parent = 0);
signals:
    void groupChanged(const int group);
    void qqChanged(const int group);
    void indexChanged(const int index);
    void addressChanged(const QString &address);
    void nameChanged(const QString &name);
    void cityChanged(const QString &city);
    void emailChanged(const QString &email);
    void courseNameChanged(const QString &courseName);
    void targetCountChanged(const int count);
};

#endif  // USER_H
