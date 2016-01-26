/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import Material 0.2

Object {
    id: platform

    property var platformExtensions

    property color decorationColor: Theme.primaryDarkColor
    property var window: null
    readonly property real multiplier: platformExtensions ? platformExtensions.multiplier : 1

    onDecorationColorChanged: {
        if (platformExtensions && color != "#000000") {
            platformExtensions.decorationColor = decorationColor
        }
    }

    onWindowChanged: {
        if (platformExtensions) {
            platformExtensions.window = window
        }
    }

    Component.onCompleted: {
        try {
            var code = 'import Papyros.Material 0.1; PlatformExtensions {}'
            platformExtensions = Qt.createQmlObject(code, platform, "PapyrosExtensions");

            platformExtensions.window = window
            if (decorationColor != "#000000")
                platformExtensions.decorationColor = decorationColor
        } catch (error) {
            // Ignore the error; it only means that the Papyros
            // platform extensions are not available
        }
    }
}
