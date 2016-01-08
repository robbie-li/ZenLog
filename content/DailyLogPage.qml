/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import robbie.calendar 1.0
import FlatUI 1.0

Item {
    objectName: 'DailyLog'
    width: parent.width
    height: parent.height

    SqlEventModel {
        id: eventModel
    }

    Rectangle {
        color: flatConstants.concrete
        anchors.fill: parent

        Row {
            id: option
            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 30 }
            spacing: 30

            FlatSelect {
                id: course_name
                width: (parent.width - option.spacing) /2
                height: 80
                dropdownItemHeight: height
                dropdownWidth: width
                dropdownRadius: 0

                model: ListModel {
                    ListElement {item: "大悲咒";}
                    ListElement {item: "佛号"; separator: true}
                    ListElement {item: "心经"; separator: true}
                    ListElement {item: "六字真言"; separator: true}
                }
            }

            FlatSelect {
                id: course_time
                width: (parent.width - option.spacing) /2
                height: 80
                dropdownItemHeight: height
                dropdownWidth: width
                dropdownRadius: 0

                model: ListModel {
                    ListElement {item: "全天";}
                    ListElement {item: "早课"; separator: true}
                    ListElement {item: "午课"; separator: true}
                    ListElement {item: "晚课"; separator: true}
                }
            }
        }


        TextField {
            id: course_count
            height: 80
            anchors { top: option.bottom; left: parent.left; right: parent.right; margins: 30 }
            validator: IntValidator {bottom: 0; top: 1000000;}
            style: touchStyle
            placeholderText: "输入次数:1-1000000"
            verticalAlignment: Text.AlignVCenter
        }

        DatePicker {
            id: datepicker
            anchors { top: course_count.bottom; left: parent.left; right: parent.right; margins: 30; }
        }

        FlatButton {
            anchors { top: datepicker.bottom; left: parent.left; right: parent.right; margins: 30 }
            id: saveButton
            text: "Save"
            height: times.height

            Behavior on y {
                NumberAnimation { duration: 1000 }
            }

            onClicked: {
                if(course_time.text != '') {
                    eventModel.addCourse(datepicker.currentDate, course_name.text, course_time.text, course_count.text)
                    course_time.text = ''
                }
            }
        }
    }

    Component {
        id: touchStyle

        TextFieldStyle {
            textColor: "white"
            font.pixelSize: 28
            background: Item {
                implicitHeight: 50
                implicitWidth: 480
                BorderImage {
                    source: "qrc:/res/images/textinput.png"
                    border.left: 8
                    border.right: 8
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
        }
    }
}
