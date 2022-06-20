#ifndef VTRADETOOLS_H
#define VTRADETOOLS_H

#include <QObject>
#include <QColor>

class VTradeTools : public QObject
{
    Q_OBJECT
public:
    VTradeTools(QObject *parent = Q_NULLPTR);

public Q_SLOTS:
    QColor fromColor(int code);
    int colorToInt(QColor code);
    void setupWindowColor(QColor color);

};

#endif // VTRADETOOLS_H
