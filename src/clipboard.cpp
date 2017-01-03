#include "clipboard.h"

#include <QApplication>
#include <QClipboard>
#include <QDebug>
#include <QtXml>
#include "sqlmodel.h"
#include "user.h"

Clipboard::Clipboard()
{
}

QString formatXML(const QString& xmlIn)
{
   QDomDocument doc;
   doc.setContent(xmlIn);
   return doc.toString(1);
}

void Clipboard::copyMonthlyCourse(const int year, const int month)
{
    SqlModel db;

    User* user = qobject_cast<User*>(db.getCurrentUser());

    QVariantMap data = db.dailyCourseCountForMonth(year, month);

    QString result;
    result += "<html>";
    result += "<head>";
    result += "<title>";
    result += QString::fromUtf8("功课记录:") + user->name()  +"\t";
    result += QString::fromUtf8("时间:") + QString::fromLatin1("%1-%2").arg(year, 4, 10).arg((month+1), 2, 10, QLatin1Char('0'));
    result +="</title>";
    result +="</head>";

    result += "<body>";
    result += "<table>";
    result += QString::fromUtf8("<tr><th>项</th><th>值</th></tr>");
    result += "<tr><td>" + QString::fromUtf8("群内名号</td><td>") + user->name() + "</td></tr>";
    result += "<tr><td>" + QString::fromUtf8("功课</td><td>") + user->courseName() + "</td></tr>";
    result += "<tr><td>" + QString::fromUtf8("QQ</td><td>") + QString::number(user->qq()) + "</td></tr>";
    result += "<tr><td>" + QString::fromUtf8("班组</td><td>") + QString::number(user->classNum()) + QString::fromUtf8("班") + QString::number(user->groupNum()) + QString::fromUtf8("组") + "</td></tr>";
    result += "<tr><td>" + QString::fromUtf8("群内编号</td><td>") + QString::number(user->groupIdx()) + "</td></tr>";
    result += "<tr><td>" + QString::fromUtf8("功课记录</td><td>") + QString::fromLatin1("%1-%2").arg(year, 4, 10).arg((month+1), 2, 10, QLatin1Char('0')) + "</td></tr>";
    result += "</table>";

    result += "<table><tr>";
    QDate date(year,month+1,1);
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
            result += QString::fromUtf8("无记录");
        }
        result += QLatin1String("</td>");
    }
    result += "</tr></table></body></html>";

    QApplication::clipboard()->setText(formatXML(result));
}
