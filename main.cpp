
#include <QApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#ifdef QT_WEBVIEW_LIB
#include <QtWebView>
#endif
#include <QQuickStyle>

#include "appoptions.h"
#include "vtradetools.h"

static QObject *create_trickstoole_singleton(QQmlEngine *, QJSEngine *)
{
    return new VTradeTools;
}

int main(int argc, char *argv[])
{
    qputenv("QT_ANDROID_ENABLE_WORKAROUND_TO_DISABLE_PREDICTIVE_TEXT", "1");
    qputenv("QT_LOGGING_RULES", "qt.qml.connections=false");

#ifdef Q_OS_WIN
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

#ifdef QT_WEBVIEW_LIB
    QtWebView::initialize();
#endif

#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
    QQuickStyle::setStyle("QtQuick.Controls.IOSStyle");
    QQuickStyle::setFallbackStyle("Material");
#endif

    qmlRegisterType<AppOptions>("VTrade", 1, 0, "AppOptions");
    qmlRegisterSingletonType<VTradeTools>("VTrade", 1, 0, "VTradeTools", create_trickstoole_singleton);

    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/imports/globals/logo.png"));

    QQmlApplicationEngine engine;
    engine.addImportPath(":/imports/");
    engine.rootContext()->setContextProperty("testMode", false);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
