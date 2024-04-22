import Foundation


class NotificationSettingsViewModel: BaseViewModel {
    //Notification setting options
    let settings = NotificationSettingsType.allCases
    //All notification settings
    var notificationSettings: NotificationSettings?
    
    var isDNDOn: Bool {
        return notificationSettings?.isDNDOn ?? false
    }
    
    var isAccountNotificationsEmailOn: Bool {
        return notificationSettings?.accountNotificationSettings?.isEmailOn ?? false
    }
    
    var isOrderNotificationsEmailOn: Bool {
        return notificationSettings?.orderNotificationSettings?.isEmailOn ?? false
    }
    
    var isOrderNotificationsSmsOn: Bool {
        return notificationSettings?.orderNotificationSettings?.isSmsOn ?? false
    }
    
    var isAppUpdatesOn: Bool {
        return notificationSettings?.isAppUpdatesOn ?? false
    }
}


//MARK: Fetch Notification Settings
extension NotificationSettingsViewModel {
    
    func fetchNotificationSettings() {
        //MARK: Set Dummy Data ---- Remove below code before production ----
        let accountNotificationSettings = AccountNotificationSettings(isEmailOn: true)
        let orderNotificationSettings = OrderNotificationSettings(isEmailOn: true, isSmsOn: true)
        
        notificationSettings = NotificationSettings(
            id: 15, isDNDOn: true,
            accountNotificationSettings: accountNotificationSettings,
            orderNotificationSettings: orderNotificationSettings,
            isAppUpdatesOn: true
        )
        self.reloadTableViewClosure?()
    }
}


//MARK: Update Notification Settings
extension NotificationSettingsViewModel {
    
    func updateNotificationSettings() {
        guard let _notificationSettings = notificationSettings, APIManager.shared.isLoggedIn() else {
            return
        }
        //Hit API to update NotificationSettings date to server
    }
}
