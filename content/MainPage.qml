import QtQuick 2.5
import Material 0.2
import "."

NavigationDrawerPage {
    function selectDate(selectedDate) {
        dailyLog.selectDate(selectedDate)
    }

    navDrawer: UserSettings {
        width: Units.gu(6)
        onUserSettingsChanged: {
            dailyLog.reloadUserSetting();
        }
    }

    page: DailyLogPage {
        id: dailyLog
    }
}
