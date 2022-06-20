
ios {
    OTHER_FILES += \
        $$PWD/Launch.xib \
        $$PWD/Info.plist \
        $$files($$PWD/*.png, true)
}

ios {
    QMAKE_INFO_PLIST = $$PWD/Info.plist
    QTPLUGIN += qavfcamera

    app_launch_images.files = $$PWD/Launch.xib $$files($$PWD/splash/LaunchImage*.png)
    QMAKE_BUNDLE_DATA += app_launch_images

    ios_icon.files = $$files($$PWD/icons/*.png)
    QMAKE_BUNDLE_DATA += ios_icon
}
