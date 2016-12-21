#include "clipboard.h"

#include <QApplication>
#include <QClipboard>
#include <QDebug>
#include "sqlmodel.h"

Clipboard::Clipboard()
{
}

void Clipboard::copyMonthlyCourse(const int year, const int month)
{
    SqlModel db;

    QVariantMap data = db.dailyCourseCountForMonth(year, month);

    QString result;
    QDate date(year,month,1);
    for (int i = 1; i < date.daysInMonth(); ++i) {
        QString daystr = QString::fromLatin1("%1").arg(i, 2, 10, QLatin1Char('0'));
        if(data.contains(daystr)) {
            result += data[daystr].toString();
        } else {
            result += QLatin1String("$$$$");
        }
        result += QLatin1String("\t");
    }

    QApplication::clipboard()->setText(result);
}
