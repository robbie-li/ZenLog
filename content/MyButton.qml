import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import Material 0.2

FlatIconButton {
    FlatConstants {
        id: flatConstants
    }

    fontFamily: flatConstants.fontAwesome.name
    pointSize: 20
    defaultColor: flatConstants.concrete
}
