import Foundation


class AppInstance: NSObject {

    static let shared = AppInstance()
    
    var userProfile: UserProfile?
    var feedbackOptionsData: FeedbackOptionsResponse?
    var isRedo3dBodyScan: Bool = false
    //var fcmToken: String?
    
    var isUserProfileExists: Bool {
        return userProfile != nil
    }
        
    override private init() {
        super.init()
    }
    
    func clearSessionData() {
        userProfile = nil
        UserDefaults.clearAllData()
        APIManager.shared.cleanSessionData()
    }
}
