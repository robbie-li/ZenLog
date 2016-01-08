import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import FlatUI 1.0

FlatIconButton {
    FlatConstants {
        id: flatConstants
    }

    fontFamily: flatConstants.fontAwesome.name
    pointSize: 20
    defaultColor: flatConstants.concrete
}
