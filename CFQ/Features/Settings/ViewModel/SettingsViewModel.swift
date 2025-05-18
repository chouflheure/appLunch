import Foundation

class SettingsViewModel {
    
    var isGuestMode: Bool
    
    init(isGuestMode: Bool) {
        self.isGuestMode = isGuestMode
    }
    
    var getArrayIconTitleForNextScreen: [ScreenSettingsData] {
        return isGuestMode ? arrayIconTitleForNextScreenGuestScreen : arrayIconTitleForNextScreen
    }
    
    var getArrayIconTitleForPopUp: [ScreenSettingsData] {
        return isGuestMode ? arrayIconTitleForPopUpGuestMode : arrayIconTitleForPopUp
    }

    var arrayIconTitleForNextScreen: [ScreenSettingsData] = [
        ScreenSettingsData(
            icon: .iconNavProfile,
            label: StringsToken.Settings.headereditMyProfil,
            screen: .editProfile
        ),

        ScreenSettingsData(
            icon: .iconPlus,
            label: StringsToken.Settings.onboardingPreview,
            screen: .onboarding
        ),

        ScreenSettingsData(
            icon: .iconBug,
            label: StringsToken.Settings.aBugTellUs,
            screen: .bugReport
        ),

        ScreenSettingsData(
            icon: .iconArchive,
            label: StringsToken.Settings.archives,
            screen: .archive
        ),
        
        ScreenSettingsData(
            icon: .iconNotifs,
            label: StringsToken.Settings.notifications,
            screen: .notifications
        )
    ]
    
    var arrayIconTitleForNextScreenGuestScreen: [ScreenSettingsData] = [
        ScreenSettingsData(
            icon: .iconPlus,
            label: StringsToken.Settings.onboardingPreview,
            screen: .onboarding
        )
    ]
    
    var arrayIconTitleForPopUp: [ScreenSettingsData] = [
        ScreenSettingsData(
            icon: .iconDoor,
            label: StringsToken.Settings.logOut,
            screen: .logout,
            color: .purpleDark
        ),
        ScreenSettingsData(
            icon: .iconCross,
            label: StringsToken.Settings.deleteAccount,
            screen: .removeAccount,
            color: .red
        ),
    ]
    
    var arrayIconTitleForPopUpGuestMode: [ScreenSettingsData] = [
        ScreenSettingsData(
            icon: .iconDoor,
            label: StringsToken.Settings.SignIn,
            screen: .logout,
            color: .purpleDark
        )
    ]
    
}
