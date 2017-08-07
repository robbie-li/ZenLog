import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../controls"

Dialog {
    id: root
    modal: true
    focus: true

    header: Rectangle {
        width: root.width
        height: 40
        Label {
            width: root.width
            text: "精进群修行日志"
            font.pixelSize: 24
            font.bold: true
            anchors.margins: 10
            anchors.top: parent.top
            horizontalAlignment: Qt.AlignCenter
        }
    }

    contentItem: ColumnLayout {
        id: aboutColumn
        width: root.width
        spacing: 20

        Label {
            width: aboutDialog.availableWidth
            text: "诸恶莫作，众善奉行，"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: aboutDialog.availableWidth
            text: "因果不虚，如影随形，"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: aboutDialog.availableWidth
            text: "念佛持咒，求生极乐，"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: aboutDialog.availableWidth
            text: "当勤精进，慎勿放逸。"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: aboutDialog.availableWidth
            text: "应常诵持，勿生懈怠，"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: aboutDialog.availableWidth
            text: "馺馺诵持，声声不绝，"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: aboutDialog.availableWidth
            text: "忏悔业障，净持斋戒，"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Label {
            width: aboutDialog.availableWidth
            text: "发菩提心，为众忏悔。"
            wrapMode: Label.Wrap
            font.pixelSize: 22
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        ImageTextButton {
            text: "确定"
            Layout.preferredHeight: 35
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            imageVisible: false
            font.pixelSize: 22
            onClicked: {
                aboutDialog.close()
            }
        }
    }
}
