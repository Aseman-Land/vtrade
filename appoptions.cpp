#include "appoptions.h"

#include <QTimer>

#ifndef QT_NO_SSL
#include <QSslCertificate>
#include <QSslSocket>
#include <QSslConfiguration>
#endif

AppOptions::AppOptions(QObject *parent) :
    QObject(parent)
{
    QMetaObject::invokeMethod(this, "reloadSettings", Qt::QueuedConnection);
}

void AppOptions::reloadSettings()
{
    auto sslCert = property("sslCertificate").toString();
    if (sslCert.length())
    {
#ifndef QT_NO_SSL
        QSslCertificate cert(sslCert.toUtf8());
//        QSslSocket::addDefaultCaCertificate(cert);
        QSslConfiguration configs = QSslConfiguration::defaultConfiguration();
        configs.setCaCertificates({cert});
//        QSslConfiguration::setDefaultDtlsConfiguration(configs);
        QSslConfiguration::setDefaultConfiguration(configs);
#endif
    }
}

AppOptions::~AppOptions()
{

}
