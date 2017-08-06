import QtQuick 2.9
import QtQuick.Controls 2.2

Dialog {
    modal: true
    focus: true

    title: "精进群修行日志"

    standardButtons: Dialog.Ok

    contentItem: Column {
        id: aboutColumn
        spacing: 20

        Label {
            width: aboutDialog.availableWidth
            text: "诸恶莫作，众善奉行，因果不虚，如影随形，"
            wrapMode: Label.Wrap
            font.pixelSize: 14
        }

        Label {
            width: aboutDialog.availableWidth
            text: "念佛持咒，求生极乐，当勤精进，慎勿放逸。"
            wrapMode: Label.Wrap
            font.pixelSize: 14
        }

        Label {
            width: aboutDialog.availableWidth
            text: "应常诵持，勿生懈怠，馺馺诵持，声声不绝，"
            wrapMode: Label.Wrap
            font.pixelSize: 14
        }

        Label {
            width: aboutDialog.availableWidth
            text: "忏悔业障，净持斋戒，发菩提心，为众忏悔。"
            wrapMode: Label.Wrap
            font.pixelSize: 14
        }
    }
}
