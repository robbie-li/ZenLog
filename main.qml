import QtQuick 2.5
import QtQuick.Window 2.2
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "content"

ApplicationWindow {
    id: root

    visible: true
    height: 960
    width: 540
    //width: Screen.desktopAvailableWidth
    //height: Screen.desktopAvailableHeight
    //visibility: "AutomaticVisibility"
    //visibility: "FullScreen"

    title: "精进修行"

    theme {
        primaryColor: "#3498db"
        accentColor: "#e74c3c"
        tabHighlightColor: "white"
    }

    initialPage: MainPage {
    }
}
