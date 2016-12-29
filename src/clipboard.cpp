#include "clipboard.h"

#include <QApplication>
#include <QClipboard>
#include <QDebug>
#include "sqlmodel.h"
#include "user.h"

Clipboard::Clipboard()
{
}

void Clipboard::copyMonthlyCourse(const int year, const int month)
{
    SqlModel db;

    User* user = qobject_cast<User*>(db.getCurrentUser());

    QVariantMap data = db.dailyCourseCountForMonth(year, month);

    QString result;
    result += "<html>\n<head><h3>" + QString::fromUtf8("功课记录") + user->name()  +"</h3></head>\n";

    result += "<body>\n";
    result += "<table boder=\"1\">\n";
    result += QString::fromUtf8("<tr>\n<th>项</th>\n<th>值</th>\n<tr>\n");
    result += "<tr>\n<td>" + QString::fromUtf8("群内名号</td>\n<td>") + user->name() + "</td>\n</tr>\n";
    result += "<tr>\n<td>" + QString::fromUtf8("功课</td>\n<td>") + user->courseName() + "</td>\n</tr>\n";
    result += "<tr>\n<td>" + QString::fromUtf8("QQ</td>\n<td>") + QString::number(user->qq()) + "</td>\n</tr>\n";
    result += "<tr>\n<td>" + QString::fromUtf8("班组</td>\n<td>") + QString::number(user->classNum()) + QString::fromUtf8("班") + QString::number(user->groupNum()) + QString::fromUtf8("组") + "</td>\n</tr>\n";
    result += "<tr>\n<td>" + QString::fromUtf8("群内编号</td>\n<td>") + QString::number(user->groupIdx()) + "</td>\n</tr>\n";
    result += "<tr>\n<td>" + QString::fromUtf8("功课记录</td>\n<td>") + QString::fromLatin1("%1-%2").arg(year, 4, 10).arg((month+1), 2, 10, QLatin1Char('0')) + "</td>\n</tr>\n";
    result += "</table>";

    result += "<table border=\"1\">\n<tr>\n";
    QDate date(year,month,1);
    for (int i = 1; i < date.daysInMonth(); ++i)
    {
        result += "<td>";
        QString daystr = QString::fromLatin1("%1").arg(i, 2, 10, QLatin1Char('0'));
        if(data.contains(daystr))
        {
            result += data[daystr].toString();
        }
        else
        {
            result += QLatin1String("$$$$");
        }
        result += QLatin1String("</td>\n");
    }
    result += "</tr>\n</table>\n</body>\n</html>";

    qDebug() << "Copy To Clipboard:" << result;

    QApplication::clipboard()->setText(result);
}
