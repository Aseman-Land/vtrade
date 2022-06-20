QT += quick multimedia widgets svg quickcontrols2
VERSION = 0.2.1

qtHaveModule(webview): QT += webview

CONFIG += c++11

include(configurations/configurations.pri)
#include(translations/translations.pri)
include(objective-c/objective-c.pri)

exists ($$PWD/qml/imports): QML_IMPORT_PATH += $$PWD/qml/imports

SOURCES += \
        appoptions.cpp \
        main.cpp \
        vtradetools.cpp

HEADERS += \
    appoptions.h \
    vtradetools.h

RESOURCES += qml/qml.qrc

ANDROID_EXTRA_LIBS = \
    $$PWD/libs/armv7/libcrypto_1_1.so \
    $$PWD/libs/armv7/libssl_1_1.so \
    $$PWD/libs/arm64/libcrypto_1_1.so \
    $$PWD/libs/arm64/libssl_1_1.so

ANDROID_ABIS = armeabi-v7a arm64-v8a
