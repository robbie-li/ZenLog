#include "mailclient.h"

#include <QDebug>

#include "smtpclient/SmtpMime"
#include "sqlmodel.h"
#include "user.h"

MailClient::MailClient() {
}

void MailClient::sendMail(const int year, const int month) {
  qDebug() << "Begin to send mail";

  SmtpClient smtp("smtp.gmail.com", 465, SmtpClient::SslConnection);

  // We need to set the username (your email address) and password
  // for smtp authentification.
  smtp.setUser("xxxx@gmail.com");
  smtp.setPassword("xxxx");

  SqlModel db;
  QObject* obj = db.getCurrentUser();
  User* user = NULL;
  if(obj) {
    user = qobject_cast<User*>(obj);
  }

  if(!user) {
    return;
  }

  // Now we create a MimeMessage object. This is the email.
  MimeMessage message;

  EmailAddress sender("robbie.xwli@gmail.com", "Robbie Li");
  message.setSender(&sender);

  EmailAddress to("robbie.li@live.com", "Robbie Li");
  message.addRecipient(&to);

  QString date = QString::fromLatin1("%1-%2")
                 .arg(year, 4, 10, QLatin1Char('0'))
                 .arg(month + 1, 2, 10, QLatin1Char('0'));

  QString title = QString::fromUtf8("功课日志: %1， %2").arg(user->name()).arg(date);

  message.setSubject(title);

  // Now add some text to the email.
  // First we create a MimeText object.
  MimeHtml content;
  QString html = "<h1>" + user->name()  + "</h1>"
                 "<h2>" + date  + "</h2>";

  QVariantMap data = db.monthlyCourses(year, month);

  html += "<table border='1'>"
          "<td>"
          "<th>day</th>"
          "<th>count</th>"
          "</td>";
  for(QVariantMap::iterator itr = data.begin(); itr != data.end(); ++itr) {
    html += "<td>";
    html += "<tr>" + itr.key() + "</tr>";
    html += "<tr>" + itr.value().toString() + "</tr>";
    html += "</td>";
  }
  html += "</tr></table>";
  content.setHtml(html);

  // Now add it to the mail
  message.addPart(&content);

  // Now we can send the mail
  if (!smtp.connectToHost()) {
    qDebug() << "Failed to connect to host!" << endl;
    return;
  }

  if (!smtp.login()) {
    qDebug() << "Failed to login!" << endl;
    return;
  }

  if (!smtp.sendMail(message)) {
    qDebug() << "Failed to send mail!" << endl;
    return;
  }

  smtp.quit();

  emit mailSent(true);
}
