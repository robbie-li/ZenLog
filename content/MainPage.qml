import QtQuick 2.5
import Material 0.2
import "."

NavigationDrawerPage {
    navDrawer: UserSettings {
        onUserSettingsChanged: {
            dailyLog.reloadUserSetting();
        }
    }

    page: DailyLogPage {
        id: dailyLog
    }
}
