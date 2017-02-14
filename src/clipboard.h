#ifndef CLIPBOARD_H
#define CLIPBOARD_H

#include <QObject>

class Clipboard : public QObject {
    Q_OBJECT

  public:
    Clipboard();

    Q_INVOKABLE void copyMonthlyCourse(const int year, const int month);

    Q_INVOKABLE void copyMonthlyCourseAsHtml(const int year, const int month);
};

#endif
