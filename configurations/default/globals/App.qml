pragma Singleton

/*!
 * All app details
 * This file will convert to the C++ codes and to the machine codes with
 * QtQuickCompiler technology.
 * So this mechanism prevent reverse engineering your app.
 */

import QtQuick 2.0
import AsemanQml.Base 2.0
import VTrade 1.0

AppOptions {
    // App Information
    readonly property variant name: {
        "en": "VTrade",
        "fa": "وی‌ترید"
    }
    readonly property string uniqueId: "ee524dd6-6bd2-412e-8c42-26e93bfc6921"
    readonly property string version: "1.0.0"
    readonly property string organizationDomain: "io.aseman"
    readonly property string bundleId: "io.aseman.vtrade"
    readonly property int bundleVersion: 1

    // Connection
    readonly property string domain: "https://vtrade.aseman.io"
    readonly property string sslCertificate: "" // If Any and If Qt Framework built with SSL_SUPPORT
    readonly property bool ignoreSslErrors: true
    readonly property string salt: "92bcd38b-9aae-4528-a5b0-4c38489db279"

    // Translations
    readonly property string countryCode: "98"
    readonly property variant displayName: {
        "en": "Aseman's VTrade System",
        "fa": "سیستم وی‌ترید آسمان"
    }

    // Look and Feel
    readonly property url logo: "logo.png"
}

