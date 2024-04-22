import Foundation


struct NotificationSettings: Codable {
    let id: Int?
    var isDNDOn: Bool?
    var accountNotificationSettings: AccountNotificationSettings?
    var orderNotificationSettings: OrderNotificationSettings?
    var isAppUpdatesOn: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isDNDOn = "is_dnd_on"
        case accountNotificationSettings = "account_notification_settings"
        case orderNotificationSettings = "order_notification_settings"
        case isAppUpdatesOn = "is_app_updates_on"
    }
}


struct AccountNotificationSettings: Codable {
    var isEmailOn: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isEmailOn = "is_email_on"
    }
}


struct OrderNotificationSettings: Codable {
    var isEmailOn: Bool?
    var isSmsOn: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isEmailOn = "is_email_on"
        case isSmsOn = "is_sms_on"
    }
}
