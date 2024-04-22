//
//  Constants.swift
//  Bould
//
//  Created by Naveen on 17/10/23.
//

import UIKit

typealias CompletionVoid                    = () -> Void
typealias CompletionError                   = (_ error: Error?) -> Void
typealias CompletionURL                     = (_ url: URL?) -> Void
typealias CompletionBool                    = (_ isSuccess: Bool) -> Void
typealias CompletionString                  = (_ value: String?) -> Void
typealias CompletionStringResult            = (Result<String?, NSError>) -> Void
typealias CompletionImage                   = (_ image: UIImage?, _ error: Error?)->Void
typealias CompletionFeedbackOptions         = (_ feedbackOptions: FeedbackOptionsResponse?)->Void
typealias CompletionFeedback                = (Result<Feedback?, Error>) -> Void
typealias CompletionMeasurements            = (Result<Measurements?, Error>) -> Void
typealias CompletionUserProfile             = (Result<UserProfile?, Error>) -> Void
typealias CompletionProduct                 = (Result<Product?, Error>) -> Void
typealias CompletionProducts                = (Result<[Product], Error>) -> Void
typealias CompletionURLResult               = (Result<URL?, NSError>) -> Void

struct AppSupport {
    static let phoneNumber                  = "_"
    static let instagramID                  = "shopbould"
    
    static let email                        = "support@bouldhq.com"
    static let supportEmailSubject          = "General Assistance Needed"
    static let supportEmailMessageBody      = """
                                            Hello Support Team,
                                            
                                            I hope this email finds you well. I'm reaching out because I need some general assistance with using the app. Could you provide guidance on [briefly describe what help is needed]?
                                            
                                            Thank you for your time and support.
                                            
                                            Regards,
                                            """
}

struct ValidationRegex {
    static let email : String               = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let password : String            = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#@!$"
}

struct LimitCount {
    static let minimumPasswordLength: Int   = 6
    static let minimumPhoneNoLength: Int    = 5
    static let maximumDecimalPlaces: Int    = 2
}

public struct DateFormats {
    static let hh_mm_a                      = "hh:mm a"
    static let hh_mm_ss_a                   = "hh:mm:ss a"
    static let dd_MM_yy                     = "dd/MM/yy"
    static let dd_MM_yyyy                   = "dd/MM/yyyy"
    static let MM_dd_yyyy                   = "MM/dd/yyyy"
    static let yyyy_MM_dd                   = "yyyy-MM-dd"
    static let d_M_yy_h_mm_a                = "d/M/yy, h:mm a"
    static let MM_dd_yyyy_hh_mm_a           = "MM/dd/yyyy hh:mm a"
    static let MMM_dd_yyyy_HH_mm            = "MMM dd, yyyy HH:mm"
    static let MMM_dd_yyyy_hh_mm_a          = "MMM dd, yyyy hh:mm a"
    static let yyyy_MM_dd_HH_mm_ss_SSSZ     = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

public enum Gender: String, Codable, CaseIterable {
    case Male
    case Female
}

public enum BodyPose {
    case frontProfile
    case sideProfile
    case standingPose
    
    var image: String {
        switch self {
        case .frontProfile:
            return "front-side-view-outline"
        case .standingPose:
            return "front-side-view-outline"
        case .sideProfile:
            return "profile-side-view-outline"
        }
    }
    
    var title: String {
        switch self {
        case .frontProfile:
            return "Front Side View"
        case .sideProfile:
            return "Profile Side View"
        case .standingPose:
            return "Front Side View"
        }
    }
}

public enum MLModelConstants {
  static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
  static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
  static let originalScale: CGFloat = 1.0
  static let padding: CGFloat = 10.0
}

public enum SettingOption: String, CaseIterable {
    case accountSettings
    case feedback
    case help
    case logout
    
    var title: String {
        self.rawValue.camelCaseToNormal()
    }
    
    var description: String {
        switch self {
        case .accountSettings:
            return "Change your name, and other personal information."
        case .feedback:
            return "keep them informed about new clothing additions, feature updates, and other"
        case .help:
            return "About, Contact Us, Authenticity and Protection"
        case .logout:
            return "Securely exit your account with a single click."
        }
    }
}

public enum NotificationSettingsType: String, CaseIterable {
    case enableNotifications
    case accountNotifications
    case orderNotifications
    case appUpdates
    
    var title: String {
        self.rawValue.camelCaseToNormal()
    }
    
    var descriptionText: String {
        switch self {
        case .enableNotifications:
            return "Allow all Notifications"
        case .accountNotifications:
            return "Stay informed about security alerts and service or privacy policy changes by receiving account updates."
        case .orderNotifications:
            return "Get notified of promotions to stay updated on special offers,discounds, or marketing deals."
        case .appUpdates:
            return "Recieve timely notifications about app updates, new features."
        }
    }
}

public enum UserSettings: String, CaseIterable {
    case profileSettings
    case notificationSettings
    case accountSettings
    
    var title: String {
        self.rawValue.camelCaseToNormal()
    }
    
    var description: String {
        switch self {
        case .profileSettings:
            return "Change your name, and other personal information."
        case .notificationSettings:
            return "Customize your notification preferences"
        case .accountSettings:
            return "Open Phone Settings, Delete Account"
        }
    }
}

public enum AccountSettings: String, CaseIterable {
    case phoneSettings
    case deleteAccount
    
    var title: String {
        self.rawValue.camelCaseToNormal()
    }
    
    var description: String {
        switch self {
        case .phoneSettings:
            return "Open phone settings in bould section"
        case .deleteAccount:
            return "Erase Account"
        }
    }
}

public enum DatePickerOption: Int {
    case Day        = 1
    case Month      = 2
    case Year       = 3
    
    var title: String {
        return "\(self)"
    }
}

public enum MonthPickerOption: Int, CaseIterable {
    case January    = 1
    case February   = 2
    case March      = 3
    case April      = 4
    case May        = 5
    case June       = 6
    case July       = 7
    case August     = 8
    case September  = 9
    case October    = 10
    case November   = 11
    case December   = 12
    
    var title: String {
        return "\(self)"
    }
    
    func numberOfDays() -> Int {
        switch self {
        case .January, .March, .May, .July, .August, .October, .December:
            return 31
        case .April, .June, .September, .November:
            return 30
        case .February:
            return 28
        }
    }
}
