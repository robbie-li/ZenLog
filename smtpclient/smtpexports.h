#ifndef SMTPEXPORTS_H
#define SMTPEXPORTS_H

#ifdef SMTP_USES_SHARED_LIBRARY
#ifdef SMTP_BUILD
#define SMTP_EXPORT Q_DECL_EXPORT
#else
#define SMTP_EXPORT Q_DECL_IMPORT
#endif
#else
#define SMTP_EXPORT
#endif

#endif // SMTPEXPORTS_H
