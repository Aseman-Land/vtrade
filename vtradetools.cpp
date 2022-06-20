#include "vtradetools.h"
#include <QTimer>

#ifdef Q_OS_MACX
#include "objective-c/macmanager.h"
#endif

VTradeTools::VTradeTools(QObject *parent) :
    QObject(parent)
{

}

QColor VTradeTools::fromColor(int code)
{
    return QColor(code);
}

int VTradeTools::colorToInt(QColor color)
{
    return color.rgb();
}

void VTradeTools::setupWindowColor(QColor color)
{
#ifdef Q_OS_MACX
    QTimer::singleShot(100, [color](){
        MacManager::removeTitlebarFromWindow(color.redF(), color.greenF(), color.blueF());
    });
#endif
}
