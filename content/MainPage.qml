import QtQuick 2.5
import Material 0.2
import robbie.calendar 1.0
import "."

NavigationDrawerPage {
    navDrawer: UserSettings {
    }

    page: DailyLogPage {
    }
}
