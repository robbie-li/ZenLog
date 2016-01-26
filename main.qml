import QtQuick 2.5
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "content"

ApplicationWindow {
    id: root

    visible: true
    width: Units.dp(720)
    height: Units.dp(1208)
    title: "精进修行"

    theme {
        primaryColor: "blue"
        accentColor: "red"
        tabHighlightColor: "white"
    }

    initialPage: MainPage {
    }
}
