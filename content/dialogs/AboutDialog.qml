import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "../controls"

Dialog {
    id: root
    modal: true
    focus: true

    contentItem: ColumnLayout {
        Text {
            Layout.fillWidth: true
            font.pixelSize: 18
            text: '欢迎关注微信公众号！<br/>
            守月亮: shuoyueliang2014<br/>'
            horizontalAlignment: Qt.AlignHCenter
        }

        Image {
            Layout.fillHeight: true
            Layout.alignment:  Qt.AlignHCenter
            source: "qrc:/resources/images/weixin.png"
            smooth: true
            fillMode: Image.PreserveAspectFit
        }

        Text {
            Layout.fillWidth: true
            font.pixelSize: 18
            text: '欢迎加入QQ群！<br/>极乐世界普度2群:191955754。<br/>
            参加共修佛号、大悲咒。<br/><br/>'
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
