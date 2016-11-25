import QtQuick 2.7

pragma Singleton

QtObject {
    id: units

    /*!
       \internal
       This holds the pixel density used for converting millimeters into pixels. This is the exact
       value from \l Screen:pixelDensity, but that property only works from within a \l Window type,
       so this is hardcoded here and we update it from within \l ApplicationWindow
     */
    property real pixelDensity: 4.46
    property real multiplier: 1.4 //default multiplier, but can be changed by user

    /*!
       This is the standard function to use for accessing device-independent pixels. You should use
       this anywhere you need to refer to distances on the screen.
     */
    function dp(number) {
        return Math.round(number*((pixelDensity*25.4)/160)*multiplier);
    }

    function gu(number) {
        return number * gridUnit
    }

    property int gridUnit: dp(64)
}
